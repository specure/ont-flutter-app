import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/mixins/endless-history-page.mixin.dart';
import 'package:nt_flutter_standalone/modules/history/models/history-filter.item.dart';
import 'package:nt_flutter_standalone/modules/history/models/history.dart';
import 'package:nt_flutter_standalone/modules/history/services/api/history.api.service.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.state.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';

class HistoryCubit extends Cubit<HistoryState>
    with EndlessHistoryPage<History> {
  final HistoryApiService _historyApiService = GetIt.I.get<HistoryApiService>();
  final SharedPreferencesWrapper _preferencesWrapper =
      GetIt.I.get<SharedPreferencesWrapper>();
  final CMSService _cmsService = GetIt.I.get<CMSService>();

  History? _history;

  Timer? _filterTimer;

  HistoryCubit() : super(HistoryState(speedHistory: []));

  init({HistoryErrorHandler? errorHandler}) async {
    this.errorHandler = errorHandler ?? HistoryErrorHandler();
    final isHistoryEnabled =
        _preferencesWrapper.getBool(StorageKeys.persistentClientUuidEnabled);
    if (isHistoryEnabled != true) {
      emit(state.copyWith(isHistoryEnabled: isHistoryEnabled, loading: false));
      return;
    }
    emit(state.copyWith(isHistoryEnabled: isHistoryEnabled, loading: true));
    activeNetworkTypeFilters.clear();
    activeDeviceFilters.clear();
    _history = await getHistory(resetPage: true);

    if (_history == null) {
      return;
    }

    final networkTypeFilters = getFiltersFromHistory(
        _history!.getFlatResult(), MeasurementHistoryResult.networkTypeField);
    final deviceFilters = getFiltersFromHistory(
        _history!.getFlatResult(), MeasurementHistoryResult.deviceField);
    final enableSynchronization =
        _cmsService.project?.enableAppResultsSynchronization;

    var newState;
    if (_history != null) {
      newState = state.copyWith(
        speedHistory: _history!.content,
        networkTypeFilters: networkTypeFilters,
        deviceFilters: deviceFilters,
        enableSynchronization: enableSynchronization,
        loading: false,
      );
    }
    if (newState != null) {
      emit(newState);
    }
  }

  @override
  onBeforeLoad() {
    emit(state.copyWith(error: null));
  }

  @override
  load(int pageNumber) {
    return _historyApiService.getSpeedHistory(
      pageNumber,
      activeNetworkTypeFilters,
      activeDeviceFilters,
      errorHandler: errorHandler,
    );
  }

  @override
  updateHistory(history) {
    if (history == null || history.content.length <= 0) {
      return;
    }
    var allHistoryList = [
      ...state.speedHistory.expand((element) => [...element.tests]).toList(),
      ...history.getFlatResult()
    ];
    var networkTypeFilters = getFiltersFromHistory(
        allHistoryList, MeasurementHistoryResult.networkTypeField);
    var deviceFilters = getFiltersFromHistory(
        allHistoryList, MeasurementHistoryResult.deviceField);
    emit(state.copyWith(
      speedHistory: [...state.speedHistory, ...history.content],
      networkTypeFilters: !isFiltersActive ? networkTypeFilters : null,
      deviceFilters: !isFiltersActive ? deviceFilters : null,
    ));
  }

  List<HistoryFilterItem> getFiltersFromHistory(
      List<MeasurementHistoryResult> history, String field) {
    return history
        .where((e) => e.getFieldByType(field) != null)
        .map((e) => HistoryFilterItem(text: e.getFieldByType(field)!))
        .toSet()
        .toList();
  }

  Future onFilterTap(HistoryFilterItem filter) async {
    filter.active = !filter.active;
    activeNetworkTypeFilters = state.networkTypeFilters
        .where((e) => e.active)
        .map((e) => e.text)
        .toList();
    activeDeviceFilters =
        state.deviceFilters.where((e) => e.active).map((e) => e.text).toList();
    emit(state.copyWith(loading: true));
    if (_filterTimer?.isActive ?? false) {
      _filterTimer?.cancel();
    }
    final completer = Completer();
    _filterTimer = Timer(Duration(milliseconds: 600), () async {
      _history = await getHistory(resetPage: true);
      if (_history != null) {
        emit(state.copyWith(
          speedHistory: _history!.content,
          loading: false,
        ));
      }
      completer.complete();
    });
    return completer.future;
  }

  processError(Exception? error) {
    emit(state.copyWith(loading: false, error: error));
  }
}

class HistoryErrorHandler implements ErrorHandler {
  @override
  process(Exception? error) {
    GetIt.I.get<HistoryCubit>().processError(error);
  }
}
