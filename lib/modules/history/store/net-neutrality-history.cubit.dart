import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/modules/history/mixins/endless-history-page.mixin.dart';
import 'package:nt_flutter_standalone/modules/history/models/net-neutrality-history.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/net-neutrality-history.state.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-api.service.dart';

class NetNeutralityHistoryCubit extends Cubit<NetNeutralityHistoryState>
    with EndlessHistoryPage<NetNeutralityHistory> {
  final NetNeutralityApiService _netNeutralityApiService =
      GetIt.I.get<NetNeutralityApiService>();

  NetNeutralityHistory? _history;

  NetNeutralityHistoryCubit()
      : super(NetNeutralityHistoryState(netNeutralityHistory: []));

  init({NetNeutralityHistoryErrorHandler? errorHandler}) async {
    this.errorHandler = errorHandler ?? NetNeutralityHistoryErrorHandler();
    emit(state.copyWith(loading: true));
    _history = await getHistory(resetPage: true);

    if (_history == null) {
      return;
    }

    var newState;
    if (_history != null) {
      newState = state.copyWith(
        netNeutralityHistory: _history!.content,
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
    return _netNeutralityApiService.getWholeHistory(pageNumber,
        errorHandler: errorHandler);
  }

  @override
  updateHistory(history) {
    if (history == null || history.content.length <= 0) {
      return;
    }
    final updatedHistory = state.netNeutralityHistory.merge(history.content);
    emit(state.copyWith(
      netNeutralityHistory: updatedHistory,
    ));
  }

  processError(Exception? error) {
    emit(state.copyWith(loading: false, error: error));
  }
}

class NetNeutralityHistoryErrorHandler implements ErrorHandler {
  @override
  process(Exception? error) {
    GetIt.I.get<NetNeutralityHistoryCubit>().processError(error);
    GetIt.I.get<HistoryCubit>().processError(error);
  }
}
