import 'dart:async';
import 'dart:collection';

import 'package:clock/clock.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/loop-mode-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';

import '../../../core/constants/loop-mode.dart';
import '../models/loop-median.dart';

class LoopModeService {
  final SharedPreferencesWrapper _preferences =
      GetIt.I.get<SharedPreferencesWrapper>();

  static const int LOOP_INFORMATION_REFRESH_PERIOD_SECONDS = 1;

  LoopModeChangesHandler? _loopModeChangedHandler;
  LoopModeDetails loopModeDetails = LoopModeDetails(medians: HashMap());
  bool _waitingTestFired = true;
  Timer? nextTestTimer;

  /// Loop mode is enabled in the app and enabled for the app by CMS => true
  get isLoopModeActivated => isLoopModeFeatureEnabled && isLoopModeEnabled;

  /// Loop mode is enabled for the app by CMS => true
  get isLoopModeFeatureEnabled =>
      _preferences.getBool(StorageKeys.loopModeFeatureEnabled) ?? false;

  /// Loop mode is enabled in the app => true
  get isLoopModeEnabled =>
      _preferences.getBool(StorageKeys.loopModeEnabled) ?? false;

  get isLoopModeNetNeutralityEnabled =>
      _preferences.getBool(StorageKeys.loopModeNetNeutralityEnabled) ?? false;

  /// call only once at the start of the whole loop mode
  Future initializeNewLoopMode(LocationModel? currentLocation) async {
    currentLocation = currentLocation;
    await setLoopUuid(null);
    loopModeDetails = LoopModeDetails(
      targetDistanceMetersToNextTest: targetDistanceMetersToNextTest,
      targetTimeSecondsToNextTest: targetTimeSecondsToNextTest,
      targetNumberOfTests: targetMeasurementCount,
      isLoopModeNetNeutralityTestEnabled: isLoopModeNetNeutralityEnabled,
      isLoopModeActive: isLoopModeActivated,
      isLoopModeEnabled: isLoopModeEnabled,
      isLoopModeFeatureEnabled: isLoopModeFeatureEnabled,
      currentTestLocation: currentLocation,
      lastTestLocation: currentLocation,
      isLoopModeFinished: false,
      shouldLoopModeBeStarted: loopModeDetails.shouldLoopModeBeStarted,
      medians: HashMap(),
    );
    _cancelUpdateTimer();
    _loopModeChangedHandler?.onLoopModeDetailsChanged(loopModeDetails);
  }

  /// Location is cleared to get only fresh update via
  /// updateLocation(LocationModel) of location and prevent
  /// to calculate distance from very old locations which
  /// could cause to fire tests right after end of previous one
  onTestStarted() {
    var currentTestNumber = loopModeDetails.currentNumberOfTestsStarted + 1;
    _waitingTestFired = true;
    loopModeDetails = loopModeDetails.copyWithResetLocation(
        currentNumberOfTestsStarted: currentTestNumber,
        isTestRunning: true,
        isLoopModeActive: isLoopModeActivated,
        isLoopModeEnabled: isLoopModeEnabled,
        isLoopModeFeatureEnabled: isLoopModeFeatureEnabled,
        shouldAnotherTestBeStarted: false,
        lastTestTimestampMillis: clock.now().millisecondsSinceEpoch,
        currentTimeToNextTestSeconds: targetTimeSecondsToNextTest,
        currentDistanceMetersPassedFromLastTest: 0,
        shouldLoopModeBeStarted: false);
    _loopModeChangedHandler?.onLoopModeDetailsChanged(loopModeDetails);
    _startUpdateTimer();
  }

  onTestFinished(MeasurementResult? result) {
    var results = loopModeDetails.results;
    var historyResults = loopModeDetails.historyResults;
    if (result != null) {
      if (results == null) {
        results = <MeasurementResult>[result];
      } else {
        results.add(result);
      }
      double jitterUnitsFixed = (result.jitter?.toDouble() ?? -1) * 1000000;
      _updateMedianValue(
          result.pingShortest.toDouble(), MeasurementPhase.latency);
      _updateMedianValue(result.packetLoss, MeasurementPhase.packLoss);
      _updateMedianValue(jitterUnitsFixed, MeasurementPhase.jitter);
      _updateMedianValue(
          result.speedDownload.toDouble(), MeasurementPhase.down);
      _updateMedianValue(result.speedUpload.toDouble(), MeasurementPhase.up);
      if (historyResults == null) {
        historyResults = <MeasurementHistoryResult>[
          result.mapToHistoryResult()
        ];
      } else {
        historyResults.add(result.mapToHistoryResult());
      }
    }
    loopModeDetails = loopModeDetails.copyWith(
      isTestRunning: false,
      results: results,
      historyResults: historyResults,
    );
    checkLoopEndingConditions();
  }

  _onLoopTestUpdated() {
    _delayedUpdateOfStartingLocation();
    var isLoopModeFinished = checkLoopEndingConditions();
    checkStartNextTestCondition();
    _loopModeChangedHandler?.onLoopModeDetailsChanged(loopModeDetails);
    if (isLoopModeFinished) {
      stopLoopTest(false);
    }
  }

  updateLocation(LocationModel? location) {
    loopModeDetails = loopModeDetails.copyWith(currentTestLocation: location);
    _delayedUpdateOfStartingLocation();
  }

  bool checkLoopEndingConditions() {
    var isLoopModeFinished = _isLoopModeFinished;
    loopModeDetails =
        loopModeDetails.copyWith(isLoopModeFinished: isLoopModeFinished);
    return isLoopModeFinished;
  }

  checkStartNextTestCondition() {
    var remainingTimeToTheNextTestSeconds = _remainingTimeSecondsToNextTest;
    var distancePassedFromLastTest = _passedDistanceMetersFromLastTest;
    if (_waitingTestFired == true &&
        (remainingTimeToTheNextTestSeconds == 0 ||
            distancePassedFromLastTest == targetDistanceMetersToNextTest) &&
        !_isLoopModeFinishedOrRunningLastTest) {
      _waitingTestFired = false;
      loopModeDetails = loopModeDetails.copyWith(
          shouldAnotherTestBeStarted: true,
          currentTimeToNextTestSeconds: remainingTimeToTheNextTestSeconds,
          currentDistanceMetersPassedFromLastTest: distancePassedFromLastTest);
    } else {
      loopModeDetails = loopModeDetails.copyWith(
          currentTimeToNextTestSeconds: remainingTimeToTheNextTestSeconds,
          currentDistanceMetersPassedFromLastTest: distancePassedFromLastTest);
    }
  }

  get targetDistanceMetersToNextTest =>
      _preferences.getInt(StorageKeys.loopModeDistanceMetersSet) ??
      LoopMode.loopModeDefaultDistanceMeters;

  String? get loopUuid => _preferences.getString(StorageKeys.loopModeLoopUuid);

  Future setLoopUuid(String? value) async {
    loopModeDetails = loopModeDetails.copyWith(loopUuid: value);
    if (value == null) {
      _preferences.remove(StorageKeys.loopModeLoopUuid);
    } else {
      _preferences.setString(StorageKeys.loopModeLoopUuid, value);
    }
  }

  get targetTimeSecondsToNextTest =>
      (_preferences.getInt(StorageKeys.loopModeWaitingTimeMinutesSet) ??
          LoopMode.loopModeDefaultWaitingTimeMinutes) *
      60;

  get targetMeasurementCount =>
      _preferences.getInt(StorageKeys.loopModeMeasurementCountSet) ??
      LoopMode.loopModeDefaultMeasurementCount;

  get numberOfTestStarted => loopModeDetails.currentNumberOfTestsStarted;

  listenToLoopModeChanges(LoopModeChangesHandler? loopModeChangedHandler) {
    _loopModeChangedHandler = loopModeChangedHandler;
  }

  stopListeningToLoopModeChanges() {
    _loopModeChangedHandler = null;
  }

  /// we can use this to stop loop mode execution (= abort it)
  stopLoopTest(bool notifyAboutChange) {
    _cancelUpdateTimer();
    _waitingTestFired = true;
    loopModeDetails = loopModeDetails.copyWith(
        currentNumberOfTestsStarted: targetMeasurementCount,
        shouldAnotherTestBeStarted: false,
        isLoopModeFinished: true,
        isTestRunning: false);
    if (notifyAboutChange)
      _loopModeChangedHandler?.onLoopModeDetailsChanged(loopModeDetails);
  }

  get _isLoopModeFinished => (loopModeDetails.isLoopModeFinished ||
      (loopModeDetails.isTestRunning == false) &&
          (loopModeDetails.targetNumberOfTests <=
              loopModeDetails.currentNumberOfTestsStarted));

  get _isLoopModeFinishedOrRunningLastTest =>
      _isLoopModeFinished ||
      (loopModeDetails.targetNumberOfTests <=
          loopModeDetails.currentNumberOfTestsStarted);

  get _remainingTimeSecondsToNextTest {
    var timeCurrentMillis = clock.now().millisecondsSinceEpoch;
    var currentRemainingTimeSeconds = (targetTimeSecondsToNextTest * 1000 -
            (timeCurrentMillis) +
            (loopModeDetails.lastTestTimestampMillis ?? 0)) ~/
        1000;
    currentRemainingTimeSeconds =
        currentRemainingTimeSeconds < 0 ? 0 : currentRemainingTimeSeconds;
    loopModeDetails = loopModeDetails.copyWith(
        currentTimeToNextTestSeconds: currentRemainingTimeSeconds);
    return currentRemainingTimeSeconds;
  }

  get _passedDistanceMetersFromLastTest {
    if (loopModeDetails.currentTestLocation == null ||
        loopModeDetails.lastTestLocation == null) {
      return 0;
    } else {
      try {
        var distance = Geolocator.distanceBetween(
            loopModeDetails.currentTestLocation!.latitude!,
            loopModeDetails.currentTestLocation!.longitude!,
            loopModeDetails.lastTestLocation!.latitude!,
            loopModeDetails.lastTestLocation!.longitude!);
        var distanceMeters = distance.toInt();
        loopModeDetails = loopModeDetails.copyWith(
            currentDistanceMetersPassedFromLastTest: distanceMeters);
        return distanceMeters;
      } catch (e) {
        return 0;
      }
    }
  }

  /// used to update location for the current executed test if location was not acquired previously
  _delayedUpdateOfStartingLocation() {
    if ((loopModeDetails.lastTestLocation == null) &&
        (loopModeDetails.currentTestLocation != null)) {
      loopModeDetails = loopModeDetails.copyWith(
          lastTestLocation: loopModeDetails.currentTestLocation);
    }
  }

  _updateMedianValue(double? value, MeasurementPhase phase) {
    var currentMedian = loopModeDetails.medians[phase];
    if (value != null && value >= 0) {
      if (currentMedian == null) {
        currentMedian = LoopMedian(values: [value], medianValue: value);
      } else {
        List<double> values = currentMedian.values;
        values.add(value);
        values.sort((a, b) => a.compareTo(b));
        currentMedian.values = values;
        if (values.length % 2 == 0) {
          int lowerIndex = (values.length / 2 - 1).toInt();
          currentMedian.medianValue =
              (values[lowerIndex] + values[lowerIndex + 1]) / 2;
        } else {
          int middleIndex = values.length ~/ 2;
          currentMedian.medianValue = values[middleIndex];
        }
      }
      loopModeDetails.medians[phase] = currentMedian;
    }
  }

  _startUpdateTimer() {
    _cancelUpdateTimer();
    nextTestTimer = Timer.periodic(
        Duration(seconds: LOOP_INFORMATION_REFRESH_PERIOD_SECONDS),
        (timer) async {
      await _onLoopTestUpdated();
    });
  }

  _cancelUpdateTimer() {
    nextTestTimer?.cancel();
    nextTestTimer = null;
  }

  void setShouldLoopModeStart(bool shouldStart) {
    loopModeDetails =
        loopModeDetails.copyWith(shouldLoopModeBeStarted: shouldStart);
  }
}

abstract class LoopModeChangesHandler {
  void onLoopModeDetailsChanged(LoopModeDetails loopModeDetails);
}
