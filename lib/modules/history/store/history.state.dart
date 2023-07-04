import 'package:equatable/equatable.dart';
import 'package:nt_flutter_standalone/core/mixins/error-state.mixin.dart';
import 'package:nt_flutter_standalone/core/mixins/loading-state.mixin.dart';
import 'package:nt_flutter_standalone/modules/history/models/history-filter.item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-measurement.dart';

import '../../measurement-result/models/measurement-history-results.dart';

class HistoryState with ErrorState, LoadingState, EquatableMixin {
  final List<MeasurementHistoryResults> speedHistory;
  final List<HistoryFilterItem> networkTypeFilters;
  final List<HistoryFilterItem> deviceFilters;
  final bool isHistoryEnabled;
  final bool enableSynchronization;

  HistoryState({
    required this.speedHistory,
    this.networkTypeFilters = const [],
    this.deviceFilters = const [],
    this.isHistoryEnabled = true,
    this.enableSynchronization = false,
    Exception? error,
    bool loading = false,
  }) {
    this.error = error;
    this.loading = loading;
  }

  HistoryState copyWith({
    List<MeasurementHistoryResults>? speedHistory,
    List<NetNeutralityHistoryMeasurement>? netNeutralityHistory,
    bool? loading,
    List<HistoryFilterItem>? networkTypeFilters,
    List<HistoryFilterItem>? deviceFilters,
    bool? isHistoryEnabled,
    bool? enableSynchronization,
    Exception? error,
  }) {
    return HistoryState(
      speedHistory: speedHistory ?? this.speedHistory,
      loading: loading ?? this.loading,
      networkTypeFilters: networkTypeFilters ?? this.networkTypeFilters,
      deviceFilters: deviceFilters ?? this.deviceFilters,
      isHistoryEnabled: isHistoryEnabled ?? this.isHistoryEnabled,
      enableSynchronization:
          enableSynchronization ?? this.enableSynchronization,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        speedHistory,
        loading,
        networkTypeFilters,
        deviceFilters,
        isHistoryEnabled,
        enableSynchronization,
        error,
      ];
}
