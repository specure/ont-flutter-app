import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:nt_flutter_standalone/core/mixins/error-state.mixin.dart';
import 'package:nt_flutter_standalone/core/mixins/loading-state.mixin.dart';
import 'package:nt_flutter_standalone/core/models/basic-measurements.state.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-details.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-phase.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-category.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-result-item.dart';

class NetNeutralityState
    with ErrorState, EquatableMixin, LoadingState
    implements BasicMeasurementState {
  final NetNeutralityPhase phase;
  final double lastResultForCurrentPhase;
  final List<NetNeutralityResultItem> interimResults;
  final List<NetNeutralityHistoryItem> historyResults;
  final List<NetNeutralityHistoryItem>? resultDetailsItems;
  final NetNeutralityDetailsConfig? resultDetailsConfig;

  @override
  String get phaseName => 'Net Neutrality'.translated.toUpperCase();

  @override
  String get phaseUnits => '%';

  @override
  String get medianPhaseUnits => phaseUnits;

  @override
  String get formattedPhaseResult => lastResultForCurrentPhase.toString();

  @override
  String get formattedMedianPhaseResult => formattedPhaseResult;

  List<NetNeutralityHistoryItem> getHistoryResultsByType(String type) =>
      historyResults.where((item) => item.type == type).toList();

  List<NetNeutralityHistoryItem> getSuccessfullHistoryResultsByType(
          String type) =>
      getHistoryResultsByType(type)
          .where((item) => item.testStatus == NetNeutralityTestStatus.SUCCEED)
          .toList();

  List<NetNeutralityHistoryItem> getFailedHistoryResultsByType(String type) =>
      getHistoryResultsByType(type)
          .where((item) => item.testStatus != NetNeutralityTestStatus.SUCCEED)
          .toList();

  List<NetNeutralityHistoryItem> getSuccessfulHistoryResult() => historyResults
      .where((item) => item.testStatus == NetNeutralityTestStatus.SUCCEED)
      .toList();

  List<NetNeutralityHistoryItem> getFailedHistoryResult() => historyResults
      .where((item) => item.testStatus != NetNeutralityTestStatus.SUCCEED)
      .toList();

  int get successfullHistoryResultsPercent => historyResults.length != 0
      ? ((historyResults
                      .where((item) =>
                          item.testStatus == NetNeutralityTestStatus.SUCCEED)
                      .length /
                  historyResults.length) *
              100)
          .round()
      : 0;

  List<NetNeutralityHistoryCategory> get categories => [
        NetNeutralityHistoryCategory('Web page',
            type: NetNeutralityType.WEB,
            totalResults: getHistoryResultsByType(NetNeutralityType.WEB).length,
            successfulResults:
                getSuccessfullHistoryResultsByType(NetNeutralityType.WEB)
                    .length,
            failedResults:
                getFailedHistoryResultsByType(NetNeutralityType.WEB).length,
            items: getHistoryResultsByType(NetNeutralityType.WEB)),
        NetNeutralityHistoryCategory('DNS',
            type: NetNeutralityType.DNS,
            totalResults: getHistoryResultsByType(NetNeutralityType.DNS).length,
            successfulResults:
                getSuccessfullHistoryResultsByType(NetNeutralityType.DNS)
                    .length,
            failedResults:
                getFailedHistoryResultsByType(NetNeutralityType.DNS).length,
            items: getHistoryResultsByType(NetNeutralityType.DNS)),
      ];

  NetNeutralityState({
    required this.interimResults,
    required this.historyResults,
    this.phase = NetNeutralityPhase.none,
    this.resultDetailsItems,
    this.resultDetailsConfig,
    this.lastResultForCurrentPhase = 0,
    ConnectivityResult connectivity = ConnectivityResult.none,
    Exception? error,
    bool loading = false,
    NetNeutralityResultItem? resultItem,
  }) {
    this.loading = loading;
    this.error = error;
    this.connectivity = connectivity;
  }

  NetNeutralityState copyWith({
    NetNeutralityPhase? phase,
    double? lastResultForCurrentPhase,
    List<NetNeutralityResultItem>? interimResults,
    List<NetNeutralityHistoryItem>? historyResults,
    List<NetNeutralityHistoryItem>? resultDetailsItems,
    NetNeutralityDetailsConfig? resultDetailsConfig,
    ConnectivityResult? connectivity,
    Exception? error,
    bool? loading,
  }) {
    return NetNeutralityState(
      phase: phase ?? this.phase,
      lastResultForCurrentPhase:
          lastResultForCurrentPhase ?? this.lastResultForCurrentPhase,
      connectivity: connectivity ?? this.connectivity,
      error: error,
      interimResults: interimResults ?? this.interimResults,
      historyResults: historyResults ?? this.historyResults,
      resultDetailsItems: resultDetailsItems ?? this.resultDetailsItems,
      resultDetailsConfig: resultDetailsConfig ?? this.resultDetailsConfig,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [
        this.phase,
        this.lastResultForCurrentPhase,
        this.error,
        this.connectivity,
        this.resultDetailsItems,
        this.resultDetailsConfig,
        this.interimResults,
      ];
}
