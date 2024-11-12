import 'package:equatable/equatable.dart';
import 'package:nt_flutter_standalone/core/mixins/error-state.mixin.dart';
import 'package:nt_flutter_standalone/core/mixins/loading-state.mixin.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';

import '../models/measurement-history-result.dart';
import '../models/measurement-history-results.dart';

class MeasurementResultState with ErrorState, LoadingState, EquatableMixin {
  final MeasurementHistoryResult? result;
  final MeasurementHistoryResults? loopResult;
  final NTProject? project;
  final String? appVersion;
  late final String staticPageContent;
  late final String staticPageUrl;

  MeasurementResultState({
    this.result,
    this.loopResult,
    this.project,
    this.appVersion,
    staticPageContent,
    staticPageUrl,
    Exception? error,
    bool loading = false,
  }) {
    this.loading = loading;
    this.error = error;
    this.staticPageContent = staticPageContent ?? '';
    this.staticPageUrl = staticPageUrl ?? '';
  }

  MeasurementResultState copyWith(
      {MeasurementHistoryResult? result,
      MeasurementHistoryResults? loopResult,
      NTProject? project,
      String? appVersion,
      Exception? error,
      bool? loading,
      String? staticPageContent,
      String? staticPageUrl}) {
    return MeasurementResultState(
      result: result ?? this.result,
      loopResult: loopResult ?? this.loopResult,
      project: project ?? this.project,
      appVersion: appVersion ?? this.appVersion,
      error: error,
      loading: loading ?? this.loading,
      staticPageContent: staticPageContent ?? this.staticPageContent,
      staticPageUrl: staticPageUrl ?? this.staticPageUrl,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        result,
        project,
        appVersion,
        error,
        staticPageContent,
        staticPageUrl
      ];
}
