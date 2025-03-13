// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:nt_flutter_standalone/core/mixins/error-state.mixin.dart';
import 'package:nt_flutter_standalone/core/mixins/loading-state.mixin.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-measurement.dart';

class NetNeutralityHistoryState with ErrorState, LoadingState, EquatableMixin {
  final List<NetNeutralityHistoryMeasurement> netNeutralityHistory;

  NetNeutralityHistoryState({
    required this.netNeutralityHistory,
    Exception? error,
    bool loading = false,
  }) {
    this.error = error;
    this.loading = loading;
  }

  NetNeutralityHistoryState copyWith({
    List<NetNeutralityHistoryMeasurement>? netNeutralityHistory,
    bool? loading,
    Exception? error,
  }) {
    return NetNeutralityHistoryState(
      netNeutralityHistory: netNeutralityHistory ?? this.netNeutralityHistory,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [netNeutralityHistory, loading, error];
}
