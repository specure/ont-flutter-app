import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/models/history-filter.item.dart';
import 'package:nt_flutter_standalone/modules/history/models/history.dart';
import 'package:nt_flutter_standalone/modules/history/models/net-neutrality-history.dart';
import 'package:nt_flutter_standalone/modules/history/services/api/history.api.service.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.state.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-api.service.dart';

class HistoryCubit extends Cubit<HistoryState> implements ErrorHandler {
  final HistoryApiService _historyApiService = GetIt.I.get<HistoryApiService>();
  final NetNeutralityApiService _netNeutralityApiService = GetIt.I.get<NetNeutralityApiService>();
  final SharedPreferencesWrapper _preferencesWrapper =
      GetIt.I.get<SharedPreferencesWrapper>();
  final CMSService _cmsService = GetIt.I.get<CMSService>();

  History? _history;
  NetNeutralityHistory? _netNeutralityHistory;
  int _historySpeedPage = 1;
  int get historySpeedPage => _historySpeedPage;
  int _historyNetNeutralityPage = 1;
  int get historyNetNeutralityPage => _historyNetNeutralityPage;

  List<String> _activeNetworkTypeFilters = [];
  List<String> _activeDeviceFilters = [];

  Timer? _filterTimer;

  bool get _isFiltersActive =>
      _activeNetworkTypeFilters.isNotEmpty || _activeDeviceFilters.isNotEmpty;

  HistoryCubit() : super(HistoryState(speedHistory: [], netNeutralityHistory: []));

  init() async {
    final isHistoryEnabled =
        _preferencesWrapper.getBool(StorageKeys.persistentClientUuidEnabled);
    if (isHistoryEnabled != true) {
      emit(state.copyWith(isHistoryEnabled: isHistoryEnabled, loading: false));
      return;
    }
    emit(state.copyWith(isHistoryEnabled: isHistoryEnabled, loading: true));
    _activeNetworkTypeFilters.clear();
    _activeDeviceFilters.clear();
    _history = await _getSpeedHistory(resetPage: true);
    if (_preferencesWrapper.getBool(StorageKeys.netNeutralityTestsEnabled) == true) {
      _netNeutralityHistory =
        await _getNetNeutralityHistory(resetPage: true);
    }
    if (_netNeutralityHistory != null) {
      emit(state.copyWith(
        speedHistory: state.speedHistory,
        netNeutralityHistory: _netNeutralityHistory!.content,
        loading: false,
      ));
    }

    if (_history == null) {
      return;
    }

    final networkTypeFilters = getFiltersFromHistory(
        _history!.getFlatResult(), MeasurementHistoryResult.networkTypeField);
    final deviceFilters = getFiltersFromHistory(
        _history!.getFlatResult(), MeasurementHistoryResult.deviceField);
    final enableSynchronization =
        (await _cmsService.getProject())?.enableAppResultsSynchronization;

    var newState;
    if (_history != null) {
      newState = state.copyWith(
        speedHistory: _history!.content,
        netNeutralityHistory: state.netNeutralityHistory,
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

  Future<History?> _getSpeedHistory({bool resetPage = false}) async {
    emit(state.copyWith(error: null));
    if (resetPage) {
      _historySpeedPage = 1;
    }
    return _historyApiService.getSpeedHistory(
      _historySpeedPage,
      _activeNetworkTypeFilters,
      _activeDeviceFilters,
      errorHandler: this,
    );
  }

  Future<NetNeutralityHistory?> _getNetNeutralityHistory({bool resetPage = false}) async {
    emit(state.copyWith(error: null));
    if (resetPage) {
      _historyNetNeutralityPage = 1;
    }
    return _netNeutralityApiService.getWholeHistory(
      _historyNetNeutralityPage,
      errorHandler: this,
    );
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
    _activeNetworkTypeFilters = state.networkTypeFilters
        .where((e) => e.active)
        .map((e) => e.text)
        .toList();
    _activeDeviceFilters =
        state.deviceFilters.where((e) => e.active).map((e) => e.text).toList();
    emit(state.copyWith(loading: true));
    if (_filterTimer?.isActive ?? false) {
      _filterTimer?.cancel();
    }
    final completer = Completer();
    _filterTimer = Timer(Duration(milliseconds: 600), () async {
      _history = await _getSpeedHistory(resetPage: true);
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

  Future onEndOfSpeedPage() async {
    if (!(_history?.last ?? false)) {
      _historySpeedPage++;
      _history = await _getSpeedHistory();
      if (_history == null) {
        _historySpeedPage--;
        return;
      }
      var allHistoryList = [...state.speedHistory.expand((element) => {...element.tests}).toList(), ..._history!.getFlatResult()];
      var networkTypeFilters = getFiltersFromHistory(
          allHistoryList, MeasurementHistoryResult.networkTypeField);
      var deviceFilters = getFiltersFromHistory(
          allHistoryList, MeasurementHistoryResult.deviceField);
      emit(state.copyWith(
        speedHistory: [...state.speedHistory, ..._history!.content],
        networkTypeFilters: !_isFiltersActive ? networkTypeFilters : null,
        deviceFilters: !_isFiltersActive ? deviceFilters : null,
      ));
    }
  }

  @override
  process(Exception? error) {
    emit(state.copyWith(loading: false, error: error));
  }
}
