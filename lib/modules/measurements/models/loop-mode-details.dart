import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/loop-median.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';
import '../../measurement-result/models/location-model.dart';
import '../../measurement-result/models/measurement-history-result.dart';

class LoopModeDetails with EquatableMixin {

  final bool isLoopModeEnabled;
  final bool isLoopModeActive;
  final bool isLoopModeFeatureEnabled;
  final bool isTestRunning;
  final bool isLoopModeFinished;
  final bool isLoopModeNetNeutralityTestEnabled;
  final bool shouldAnotherTestBeStarted;
  final bool shouldLoopModeBeStarted;
  final int currentDistanceMetersPassedFromLastTest;
  final int currentTimeToNextTestSeconds;
  final int currentNumberOfTestsStarted;
  final int targetTimeSecondsToNextTest;
  final int targetDistanceMetersToNextTest;
  final int targetNumberOfTests;
  final HashMap<MeasurementPhase, LoopMedian> medians;
  final List<MeasurementResult>? results;
  final List<MeasurementHistoryResult>? historyResults;
  final String? loopUuid;
  final int? lastTestTimestampMillis;
  final LocationModel? lastTestLocation;
  final LocationModel? currentTestLocation;

  LoopModeDetails({
    this.isLoopModeEnabled = false,
    this.isLoopModeActive = false,
    this.isLoopModeFeatureEnabled = false,
    this.isTestRunning = false,
    this.isLoopModeFinished = false,
    this.shouldAnotherTestBeStarted = false,
    this.shouldLoopModeBeStarted = false,
    this.isLoopModeNetNeutralityTestEnabled = false,
    this.currentNumberOfTestsStarted = 0,
    this.currentDistanceMetersPassedFromLastTest = 0,
    this.currentTimeToNextTestSeconds = 0,
    this.targetTimeSecondsToNextTest = 0,
    this.targetDistanceMetersToNextTest = 0,
    this.targetNumberOfTests = 0,
    required this.medians,
    this.results,
    this.historyResults,
    this.loopUuid,
    this.lastTestTimestampMillis,
    this.lastTestLocation,
    this.currentTestLocation,
  });

  LoopModeDetails copyWith({
    bool? isLoopModeEnabled,
    bool? isLoopModeActive,
    bool? isLoopModeFeatureEnabled,
    bool? isTestRunning,
    bool? isLoopModeFinished,
    bool? shouldAnotherTestBeStarted,
    bool? shouldLoopModeBeStarted,
    bool? isLoopModeNetNeutralityTestEnabled,
    int? currentNumberOfTestsStarted,
    int? currentDistanceMetersPassedFromLastTest,
    int? currentTimeToNextTestSeconds,
    int? targetTimeSecondsToNextTest,
    int? targetDistanceMetersToNextTest,
    int? targetNumberOfTests,
    HashMap<MeasurementPhase, LoopMedian>? medians,
    List<MeasurementResult>? results,
    List<MeasurementHistoryResult>? historyResults,
    String? loopUuid,
    int? lastTestTimestampMillis,
    LocationModel? lastTestLocation,
    LocationModel? currentTestLocation,
  }) {
    return LoopModeDetails(
      isLoopModeEnabled: isLoopModeEnabled ?? this.isLoopModeEnabled,
      isLoopModeActive: isLoopModeActive ?? this.isLoopModeActive,
      isLoopModeFeatureEnabled: isLoopModeFeatureEnabled ?? this.isLoopModeFeatureEnabled,
      isTestRunning: isTestRunning ?? this.isTestRunning,
      isLoopModeFinished: isLoopModeFinished ?? this.isLoopModeFinished,
      shouldAnotherTestBeStarted: shouldAnotherTestBeStarted ?? this.shouldAnotherTestBeStarted,
      shouldLoopModeBeStarted: shouldLoopModeBeStarted ?? this.shouldLoopModeBeStarted,
      isLoopModeNetNeutralityTestEnabled: isLoopModeNetNeutralityTestEnabled ?? this.isLoopModeNetNeutralityTestEnabled,
      currentNumberOfTestsStarted: currentNumberOfTestsStarted ?? this.currentNumberOfTestsStarted,
      currentDistanceMetersPassedFromLastTest: currentDistanceMetersPassedFromLastTest ?? this.currentDistanceMetersPassedFromLastTest,
      currentTimeToNextTestSeconds: currentTimeToNextTestSeconds ?? this.currentTimeToNextTestSeconds,
      targetTimeSecondsToNextTest: targetTimeSecondsToNextTest ?? this.targetTimeSecondsToNextTest,
      targetDistanceMetersToNextTest: targetDistanceMetersToNextTest ?? this.targetDistanceMetersToNextTest,
      targetNumberOfTests: targetNumberOfTests ?? this.targetNumberOfTests,
      medians: medians ?? this.medians,
      results: results ?? this.results,
      historyResults: historyResults ?? this.historyResults,
      loopUuid: loopUuid ?? this.loopUuid,
      lastTestTimestampMillis: lastTestTimestampMillis ?? this.lastTestTimestampMillis,
      lastTestLocation: lastTestLocation ?? this.lastTestLocation,
      currentTestLocation: currentTestLocation ?? this.currentTestLocation,
    );
  }

  LoopModeDetails copyWithResetLocation({
    bool? isLoopModeEnabled,
    bool? isLoopModeActive,
    bool? isLoopModeFeatureEnabled,
    bool? isTestRunning,
    bool? isLoopModeFinished,
    bool? shouldAnotherTestBeStarted,
    bool? shouldLoopModeBeStarted,
    bool? isLoopModeNetNeutralityTestEnabled,
    int? currentNumberOfTestsStarted,
    int? currentDistanceMetersPassedFromLastTest,
    int? currentTimeToNextTestSeconds,
    int? targetTimeSecondsToNextTest,
    int? targetDistanceMetersToNextTest,
    int? targetNumberOfTests,
    HashMap<MeasurementPhase, LoopMedian>? medians,
    List<MeasurementResult>? results,
    List<MeasurementHistoryResult>? historyResults,
    String? loopUuid,
    int? lastTestTimestampMillis
  }) {
    return LoopModeDetails(
      isLoopModeEnabled: isLoopModeEnabled ?? this.isLoopModeEnabled,
      isLoopModeActive: isLoopModeActive ?? this.isLoopModeActive,
      isLoopModeFeatureEnabled: isLoopModeFeatureEnabled ?? this.isLoopModeFeatureEnabled,
      isTestRunning: isTestRunning ?? this.isTestRunning,
      isLoopModeFinished: isLoopModeFinished ?? this.isLoopModeFinished,
      shouldAnotherTestBeStarted: shouldAnotherTestBeStarted ?? this.shouldAnotherTestBeStarted,
      shouldLoopModeBeStarted: shouldLoopModeBeStarted ?? this.shouldLoopModeBeStarted,
      isLoopModeNetNeutralityTestEnabled: isLoopModeNetNeutralityTestEnabled ?? this.isLoopModeNetNeutralityTestEnabled,
      currentNumberOfTestsStarted: currentNumberOfTestsStarted ?? this.currentNumberOfTestsStarted,
      currentDistanceMetersPassedFromLastTest: currentDistanceMetersPassedFromLastTest ?? this.currentDistanceMetersPassedFromLastTest,
      currentTimeToNextTestSeconds: currentTimeToNextTestSeconds ?? this.currentTimeToNextTestSeconds,
      targetTimeSecondsToNextTest: targetTimeSecondsToNextTest ?? this.targetTimeSecondsToNextTest,
      targetDistanceMetersToNextTest: targetDistanceMetersToNextTest ?? this.targetDistanceMetersToNextTest,
      targetNumberOfTests: targetNumberOfTests ?? this.targetNumberOfTests,
      medians: medians ?? this.medians,
      results: results ?? this.results,
      historyResults: historyResults ?? this.historyResults,
      loopUuid: loopUuid ?? this.loopUuid,
      lastTestTimestampMillis: lastTestTimestampMillis ?? this.lastTestTimestampMillis,
      lastTestLocation: null,
      currentTestLocation: null,
    );
  }

  @override
  List<Object?> get props => [
    isLoopModeEnabled,
    isLoopModeActive,
    isLoopModeFeatureEnabled,
    isTestRunning,
    isLoopModeFinished,
    shouldAnotherTestBeStarted,
    shouldLoopModeBeStarted,
    isLoopModeNetNeutralityTestEnabled,
    currentNumberOfTestsStarted,
    currentDistanceMetersPassedFromLastTest,
    currentTimeToNextTestSeconds,
    targetTimeSecondsToNextTest,
    targetDistanceMetersToNextTest,
    targetNumberOfTests,
    medians,
    results,
    historyResults,
    loopUuid,
    lastTestTimestampMillis,
    lastTestLocation,
    currentTestLocation,
  ];
}
