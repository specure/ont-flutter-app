import 'dart:collection';

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/loop-median.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/loop-mode-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/loop.mode.service.dart';

import '../../di/service-locator.dart';

final loopModeDetailsDefaults = LoopModeDetails(
  isLoopModeEnabled: false,
 isLoopModeActive: false,
 isLoopModeFeatureEnabled: false,
 isTestRunning: false,
 isLoopModeFinished: false,
 shouldAnotherTestBeStarted: false,
 shouldLoopModeBeStarted: false,
 isLoopModeNetNeutralityTestEnabled: false,
 currentNumberOfTestsStarted: 0,
 currentDistanceMetersPassedFromLastTest: 0,
 currentTimeToNextTestSeconds: 0,
 targetTimeSecondsToNextTest: 0,
 targetDistanceMetersToNextTest: 0,
 targetNumberOfTests: 0,
 medians: HashMap(),
 results: null,
 historyResults: null,
 loopUuid: null,
 lastTestTimestampMillis: null,
 lastTestLocation: null,
 currentTestLocation: null,
);

final loopModeDetailsLoopInitialized = LoopModeDetails(
  isLoopModeEnabled: true,
  isLoopModeActive: true,
  isLoopModeFeatureEnabled: true,
  isTestRunning: false,
  isLoopModeFinished: false,
  shouldAnotherTestBeStarted: false,
  shouldLoopModeBeStarted: false,
  isLoopModeNetNeutralityTestEnabled: true,
  currentNumberOfTestsStarted: 0,
  currentDistanceMetersPassedFromLastTest: 0,
  currentTimeToNextTestSeconds: 0,
  targetTimeSecondsToNextTest: 60,
  targetDistanceMetersToNextTest: 100,
  targetNumberOfTests: 5,
  medians: HashMap(),
  results: null,
  historyResults: null,
  loopUuid: null,
  lastTestTimestampMillis: null,
  lastTestLocation: null,
  currentTestLocation: null,
);

final _medians1 = HashMap<MeasurementPhase, LoopMedian>.from({
  MeasurementPhase.down: LoopMedian(
      values: [2000.0],
      medianValue: 2000.0),
  MeasurementPhase.packLoss: LoopMedian(
      values: [3.0],
      medianValue: 3.0),
  MeasurementPhase.up: LoopMedian(
      values: [2000.0],
      medianValue: 2000.0),
  MeasurementPhase.latency: LoopMedian(
      values: [100.0],
      medianValue: 100.0)
});

final _measurementResult = MeasurementResult(
  bytesDownload: 10000,
  bytesUpload: 10000,
  clientName: 'RMBT',
  localIpAddress: '192.168.0.1',
  nsecDownload: 1000,
  nsecUpload: 1000,
  pingShortest: 100,
  serverIpAddress: '192.168.0.2',
  speedDownload: 2000,
  speedUpload: 2000,
  testNumThreads: 3,
  testPortRemote: 443,
  testToken: 'test_token',
  totalDownloadBytes: 100000,
  totalUploadBytes: 100000,
  time: 1661239706256,
  packetLoss: 3,
  uuid: 'uuid',
);

final _historyResult = MeasurementHistoryResult(
    testUuid: "uuid",
    uploadKbps: 2000.0,
    downloadKbps: 2000.0,
    pingMs: 0.0001,
    measurementDate: DateTime.fromMillisecondsSinceEpoch(DateTime.parse('2022-08-23T07:28:26.256').millisecondsSinceEpoch + DateTime.now().timeZoneOffset.inMilliseconds).toIso8601String(),
    packetLossPercents: 3.0
);

final _medians2 = HashMap<MeasurementPhase, LoopMedian>.from({
  MeasurementPhase.down: LoopMedian(
      values: [2000.0, 4000.0],
      medianValue: 3000.0),
  MeasurementPhase.packLoss: LoopMedian(
      values: [3.0],
      medianValue: 3.0),
  MeasurementPhase.up: LoopMedian(
      values: [2000.0, 3000.0],
      medianValue: 2500.0),
  MeasurementPhase.latency: LoopMedian(
      values: [100.0, 300.0],
      medianValue: 200.0)
});

final _measurementResult2 = MeasurementResult(
  bytesDownload: 10000,
  bytesUpload: 10000,
  clientName: 'RMBT',
  jitter: -1,
  packetLoss: -1,
  localIpAddress: '192.168.0.1',
  nsecDownload: 1000,
  nsecUpload: 1000,
  pingShortest: 300,
  serverIpAddress: '192.168.0.2',
  speedDownload: 4000,
  speedUpload: 3000,
  testNumThreads: 3,
  testPortRemote: 443,
  testToken: 'test_token',
  totalDownloadBytes: 100000,
  totalUploadBytes: 100000,
  time: 1661239706256,
  uuid: 'uuid',
);

final _historyResult2 = MeasurementHistoryResult(
    testUuid: "uuid",
    uploadKbps: 3000.0,
    downloadKbps: 4000.0,
    pingMs: 0.0003,
    measurementDate: DateTime.fromMillisecondsSinceEpoch(DateTime.parse('2022-08-23T07:28:26.256').millisecondsSinceEpoch + DateTime.now().timeZoneOffset.inMilliseconds).toIso8601String(),
    packetLossPercents: null
);

final _medians3 = HashMap<MeasurementPhase, LoopMedian>.from({
  MeasurementPhase.down: LoopMedian(
      values: [2000.0, 4000.0, 8000.0],
      medianValue: 4000.0),
  MeasurementPhase.packLoss: LoopMedian(
      values: [1.0, 3.0],
      medianValue: 2.0),
  MeasurementPhase.up: LoopMedian(
      values: [2000.0, 3000.0, 4000.0],
      medianValue: 3000.0),
  MeasurementPhase.latency: LoopMedian(
      values: [100.0, 200.0, 300],
      medianValue: 200.0)
});

final _historyResult3 = MeasurementHistoryResult(
    testUuid: "uuid",
    uploadKbps: 4000.0,
    downloadKbps: 8000.0,
    pingMs: 0.0002,
    measurementDate: DateTime.fromMillisecondsSinceEpoch(DateTime.parse('2022-08-23T07:28:26.256').millisecondsSinceEpoch + DateTime.now().timeZoneOffset.inMilliseconds).toIso8601String(),
    packetLossPercents: 1
);

final _measurementResult3 = MeasurementResult(
  bytesDownload: 10000,
  bytesUpload: 10000,
  clientName: 'RMBT',
  localIpAddress: '192.168.0.1',
  nsecDownload: 1000,
  jitter: -1,
  packetLoss: 1,
  nsecUpload: 1000,
  pingShortest: 200,
  serverIpAddress: '192.168.0.2',
  speedDownload: 8000,
  speedUpload: 4000,
  testNumThreads: 3,
  testPortRemote: 443,
  testToken: 'test_token',
  totalDownloadBytes: 100000,
  time: 1661239706256,
  totalUploadBytes: 100000,
  uuid: 'uuid',
);

final _locationStart = LocationModel(
latitude: 10.0,
longitude: 20.0,
country: 'USA',
county: 'Country',
city: 'City',
);

final _locationUpdate = LocationModel(
  latitude: 20.0,
  longitude: 10.0,
  country: 'USA',
  county: 'Country2',
  city: 'City2',
);

var loopModeService;
late SharedPreferencesWrapper _prefs;

void main() async {
  group('Loop mode service - ', () {
    _setUpStubs();
    loopModeService = LoopModeService();
    test('initialization', () async {
      await _testInitialization();
    });
    test('Loop Initialization - enabled', () async {
      await _testLoopInitializationEnabled();
    });
    test('Loop Initialization - cms disabled', () async {
      await _testLoopInitializationDisabledInCMS();
    });
    test('Loop Initialization - in app disabled', () async {
      await _testLoopInitializationDisabledInApp();
    });
    test('Loop Initialization - with location', () async {
      await _testLoopInitializationWithLocation();
    });
    test('Loop Should start and clear it after test start', () async {
      await _testShouldStartLoopMode();
    });
    test('Loop test start', () async {
      await _testLoopOnTestStart();
    });
    test('Loop test Phase finished + median calculation', () async {
      await _testOnPhaseFinishedMedianCalculation();
    });
    test('Loop test finished', () async {
      await _testLoopOnTestFinished();
    });
    test('Loop test loop finished', () async {
      await _testLoopOnLoopTestFinished();
    });
  });
}

Future _testInitialization() async {
  expect(
    loopModeService.loopModeDetails,
    loopModeDetailsDefaults,
  );
}

Future _testLoopInitializationEnabled() async {
  when(_prefs.getBool(StorageKeys.loopModeFeatureEnabled)).thenAnswer((_) => true);
  when(_prefs.getBool(StorageKeys.loopModeNetNeutralityEnabled)).thenAnswer((_) => true);
  when(_prefs.getBool(StorageKeys.loopModeEnabled)).thenAnswer((_) => true);
  when(_prefs.getInt(StorageKeys.loopModeMeasurementCountSet)).thenAnswer((_) => 5);
  when(_prefs.getInt(StorageKeys.loopModeDistanceMetersSet)).thenAnswer((_) => 100);
  when(_prefs.getInt(StorageKeys.loopModeWaitingTimeMinutesSet)).thenAnswer((_) => 1);
  when(_prefs.remove(StorageKeys.loopModeLoopUuid)).thenAnswer((_) async => {});
  await loopModeService.initializeNewLoopMode(null);
  expect(
    loopModeService.loopModeDetails,
    loopModeDetailsLoopInitialized,
  );
}

Future _testLoopInitializationDisabledInCMS() async {
  when(_prefs.getBool(StorageKeys.loopModeFeatureEnabled)).thenAnswer((_) => false);
  when(_prefs.getBool(StorageKeys.loopModeNetNeutralityEnabled)).thenAnswer((_) => true);
  when(_prefs.getBool(StorageKeys.loopModeEnabled)).thenAnswer((_) => true);
  when(_prefs.getInt(StorageKeys.loopModeMeasurementCountSet)).thenAnswer((_) => 5);
  when(_prefs.getInt(StorageKeys.loopModeDistanceMetersSet)).thenAnswer((_) => 100);
  when(_prefs.getInt(StorageKeys.loopModeWaitingTimeMinutesSet)).thenAnswer((_) => 1);
  when(_prefs.remove(StorageKeys.loopModeLoopUuid)).thenAnswer((_) async => {});
  await loopModeService.initializeNewLoopMode(null);
  expect(
    loopModeService.loopModeDetails,
    loopModeDetailsLoopInitialized.copyWith(isLoopModeActive: false, isLoopModeFeatureEnabled: false),
  );
}

Future _testLoopInitializationDisabledInApp() async {
  when(_prefs.getBool(StorageKeys.loopModeFeatureEnabled)).thenAnswer((_) => true);
  when(_prefs.getBool(StorageKeys.loopModeNetNeutralityEnabled)).thenAnswer((_) => true);
  when(_prefs.getBool(StorageKeys.loopModeEnabled)).thenAnswer((_) => false);
  when(_prefs.getInt(StorageKeys.loopModeMeasurementCountSet)).thenAnswer((_) => 5);
  when(_prefs.getInt(StorageKeys.loopModeDistanceMetersSet)).thenAnswer((_) => 100);
  when(_prefs.getInt(StorageKeys.loopModeWaitingTimeMinutesSet)).thenAnswer((_) => 1);
  when(_prefs.remove(StorageKeys.loopModeLoopUuid)).thenAnswer((_) async => {});
  await loopModeService.initializeNewLoopMode(null);
  expect(
    loopModeService.loopModeDetails,
    loopModeDetailsLoopInitialized.copyWith(isLoopModeActive: false, isLoopModeEnabled: false),
  );
}

Future _testLoopInitializationWithLocation() async {
  when(_prefs.getBool(StorageKeys.loopModeFeatureEnabled)).thenAnswer((_) => true);
  when(_prefs.getBool(StorageKeys.loopModeNetNeutralityEnabled)).thenAnswer((_) => true);
  when(_prefs.getBool(StorageKeys.loopModeEnabled)).thenAnswer((_) => false);
  when(_prefs.getInt(StorageKeys.loopModeMeasurementCountSet)).thenAnswer((_) => 5);
  when(_prefs.getInt(StorageKeys.loopModeDistanceMetersSet)).thenAnswer((_) => 100);
  when(_prefs.getInt(StorageKeys.loopModeWaitingTimeMinutesSet)).thenAnswer((_) => 1);
  when(_prefs.remove(StorageKeys.loopModeLoopUuid)).thenAnswer((_) async => {});
  await loopModeService.initializeNewLoopMode(_locationStart);
  expect(
    loopModeService.loopModeDetails,
    loopModeDetailsLoopInitialized.copyWith(isLoopModeActive: false, isLoopModeEnabled: false, currentTestLocation: _locationStart, lastTestLocation: _locationStart),
  );
}

Future _testShouldStartLoopMode() async {
  when(_prefs.getBool(StorageKeys.loopModeFeatureEnabled)).thenAnswer((_) => true);
  when(_prefs.getBool(StorageKeys.loopModeNetNeutralityEnabled)).thenAnswer((_) => true);
  when(_prefs.getBool(StorageKeys.loopModeEnabled)).thenAnswer((_) => true);
  when(_prefs.getInt(StorageKeys.loopModeMeasurementCountSet)).thenAnswer((_) => 5);
  when(_prefs.getInt(StorageKeys.loopModeDistanceMetersSet)).thenAnswer((_) => 100);
  when(_prefs.getInt(StorageKeys.loopModeWaitingTimeMinutesSet)).thenAnswer((_) => 1);
  when(_prefs.remove(StorageKeys.loopModeLoopUuid)).thenAnswer((_) async => {});
  loopModeService.setShouldLoopModeStart(true);
  expect(
    loopModeService.loopModeDetails.shouldLoopModeBeStarted, true);
  loopModeService.onTestStarted();
  expect(loopModeService.loopModeDetails.shouldLoopModeBeStarted, false);
}

Future _testLoopOnTestStart() async {
    loopModeService = await withClock(Clock.fixed(DateTime.fromMillisecondsSinceEpoch(1661239706256)), () async {
      loopModeService = LoopModeService();
      when(_prefs.getBool(StorageKeys.loopModeFeatureEnabled)).thenAnswer((_) => true);
            when(_prefs.getBool(StorageKeys.loopModeNetNeutralityEnabled)).thenAnswer((_) => true);
      when(_prefs.getBool(StorageKeys.loopModeEnabled)).thenAnswer((_) => true);
      when(_prefs.getInt(StorageKeys.loopModeMeasurementCountSet)).thenAnswer((_) => 5);
      when(_prefs.getInt(StorageKeys.loopModeDistanceMetersSet)).thenAnswer((_) => 100);
      when(_prefs.getInt(StorageKeys.loopModeWaitingTimeMinutesSet)).thenAnswer((_) => 1);
      when(_prefs.remove(StorageKeys.loopModeLoopUuid)).thenAnswer((_) async => {});
      await loopModeService.initializeNewLoopMode(_locationStart);
      loopModeService.onTestStarted();
      expect(
      loopModeService.loopModeDetails,
      loopModeDetailsLoopInitialized.copyWith(isTestRunning: true, currentNumberOfTestsStarted: 1, currentTimeToNextTestSeconds: 60, lastTestTimestampMillis: 1661239706256),
      );
      return loopModeService;
    });
}

Future _testOnPhaseFinishedMedianCalculation() async {
  loopModeService.onTestFinished(_measurementResult);
  expect(
    loopModeService.loopModeDetails,
    loopModeDetailsLoopInitialized.copyWith(
        isTestRunning: false,
        currentNumberOfTestsStarted: 1,
        currentTimeToNextTestSeconds: 60,
        lastTestTimestampMillis: 1661239706256,
        medians: _medians1,
        results: [_measurementResult],
        historyResults: [_historyResult]
    ),
  );
  loopModeService.onTestFinished(_measurementResult2);
  expect(
    loopModeService.loopModeDetails,
    loopModeDetailsLoopInitialized.copyWith(
        isTestRunning: false,
        currentNumberOfTestsStarted: 1,
        currentTimeToNextTestSeconds: 60,
        lastTestTimestampMillis: 1661239706256,
        medians: _medians2,
        results: [_measurementResult, _measurementResult2],
        historyResults: [_historyResult, _historyResult2]
    ),
  );
  loopModeService.onTestFinished(_measurementResult3);
  expect(
    loopModeService.loopModeDetails,
    loopModeDetailsLoopInitialized.copyWith(
        isTestRunning: false,
        currentNumberOfTestsStarted: 1,
        currentTimeToNextTestSeconds: 60,
        lastTestTimestampMillis: 1661239706256,
        medians: _medians3,
        results: [_measurementResult, _measurementResult2, _measurementResult3],
        historyResults: [_historyResult, _historyResult2, _historyResult3]
    ),
  );
}

Future _testLoopOnTestFinished() async {
  loopModeService = await withClock(Clock.fixed(DateTime.fromMillisecondsSinceEpoch(1661239706256)), () async {
    loopModeService = LoopModeService();
    when(_prefs.getBool(StorageKeys.loopModeFeatureEnabled)).thenAnswer((_) => true);
    when(_prefs.getBool(StorageKeys.loopModeNetNeutralityEnabled)).thenAnswer((_) => true);
    when(_prefs.getBool(StorageKeys.loopModeEnabled)).thenAnswer((_) => true);
    when(_prefs.getInt(StorageKeys.loopModeMeasurementCountSet)).thenAnswer((_) => 2);
    when(_prefs.getInt(StorageKeys.loopModeDistanceMetersSet)).thenAnswer((_) => 100);
    when(_prefs.getInt(StorageKeys.loopModeWaitingTimeMinutesSet)).thenAnswer((_) => 1);
    when(_prefs.remove(StorageKeys.loopModeLoopUuid)).thenAnswer((_) async => {});
    await loopModeService.initializeNewLoopMode(null);
    loopModeService.onTestStarted();
    loopModeService.updateLocation(_locationStart);
    loopModeService.onTestFinished(_measurementResult);
    expect(
      loopModeService.loopModeDetails,
      loopModeDetailsLoopInitialized.copyWith(
          isTestRunning: false,
          currentNumberOfTestsStarted: 1,
          targetNumberOfTests: 2,
          currentTimeToNextTestSeconds: 60,
          lastTestTimestampMillis: 1661239706256,
          medians: _medians1,
          results: [_measurementResult],
          historyResults: [_historyResult],
          currentTestLocation: _locationStart,
          lastTestLocation: _locationStart,
      ),
    );
    loopModeService.onTestStarted();
    expect(
      loopModeService.loopModeDetails,
      loopModeDetailsLoopInitialized.copyWith(
        isTestRunning: true,
        isLoopModeFinished: false,
        currentNumberOfTestsStarted: 2,
        targetNumberOfTests: 2,
        currentTimeToNextTestSeconds: 60,
        lastTestTimestampMillis: 1661239706256,
        medians: _medians1,
        results: [_measurementResult],
        historyResults: [_historyResult],
      ),
    );
    loopModeService.updateLocation(_locationStart);
    expect(
      loopModeService.loopModeDetails,
      loopModeDetailsLoopInitialized.copyWith(
        isTestRunning: true,
        isLoopModeFinished: false,
        currentNumberOfTestsStarted: 2,
        targetNumberOfTests: 2,
        currentTimeToNextTestSeconds: 60,
        lastTestTimestampMillis: 1661239706256,
        medians: _medians1,
        results: [_measurementResult],
        historyResults: [_historyResult],
        currentTestLocation: _locationStart,
        lastTestLocation: _locationStart,
      ),
    );
    loopModeService.updateLocation(_locationUpdate);
    expect(
      loopModeService.loopModeDetails,
      loopModeDetailsLoopInitialized.copyWith(
        isTestRunning: true,
        isLoopModeFinished: false,
        currentNumberOfTestsStarted: 2,
        targetNumberOfTests: 2,
        currentTimeToNextTestSeconds: 60,
        lastTestTimestampMillis: 1661239706256,
        medians: _medians1,
        results: [_measurementResult],
        historyResults: [_historyResult],
        currentTestLocation: _locationUpdate,
        lastTestLocation: _locationStart,
      ),
    );
    loopModeService.checkStartNextTestCondition();
    expect(
      loopModeService.loopModeDetails,
      loopModeDetailsLoopInitialized.copyWith(
        isTestRunning: true,
        isLoopModeFinished: false,
        currentNumberOfTestsStarted: 2,
        targetNumberOfTests: 2,
        currentDistanceMetersPassedFromLastTest: 1546488,
        shouldAnotherTestBeStarted: false,
        currentTimeToNextTestSeconds: 60,
        lastTestTimestampMillis: 1661239706256,
        medians: _medians1,
        results: [_measurementResult],
        historyResults: [_historyResult],
        currentTestLocation: _locationUpdate,
        lastTestLocation: _locationStart,
      ),
    );
    loopModeService.onTestFinished(_measurementResult2);
    expect(
      loopModeService.loopModeDetails,
      loopModeDetailsLoopInitialized.copyWith(
        isTestRunning: false,
        isLoopModeFinished: true,
        currentDistanceMetersPassedFromLastTest: 1546488,
        currentNumberOfTestsStarted: 2,
        targetNumberOfTests: 2,
        currentTimeToNextTestSeconds: 60,
        lastTestTimestampMillis: 1661239706256,
        medians: _medians2,
        results: [_measurementResult, _measurementResult2],
        historyResults: [_historyResult, _historyResult2],
        currentTestLocation: _locationUpdate,
        lastTestLocation: _locationStart,
      ),
    );
    return loopModeService;
  });
}

Future _testLoopOnLoopTestFinished() async {
  loopModeService = await withClock(Clock.fixed(DateTime.fromMillisecondsSinceEpoch(1661239706256)), () async {
    loopModeService = LoopModeService();
    when(_prefs.getBool(StorageKeys.loopModeFeatureEnabled)).thenAnswer((
        _) => true);
    when(_prefs.getBool(StorageKeys.loopModeNetNeutralityEnabled)).thenAnswer((
        _) => true);
    when(_prefs.getBool(StorageKeys.loopModeEnabled)).thenAnswer((_) => true);
    when(_prefs.getInt(StorageKeys.loopModeMeasurementCountSet)).thenAnswer((
        _) => 2);
    when(_prefs.getInt(StorageKeys.loopModeDistanceMetersSet)).thenAnswer((
        _) => 100);
    when(_prefs.getInt(StorageKeys.loopModeWaitingTimeMinutesSet)).thenAnswer((
        _) => 1);
    when(_prefs.remove(StorageKeys.loopModeLoopUuid)).thenAnswer((_) async => {});
    await loopModeService.initializeNewLoopMode(null);
    loopModeService.onTestStarted();
    expect(loopModeService.numberOfTestStarted, 1);
    loopModeService.stopLoopTest(true);
    expect(
      loopModeService.loopModeDetails,
      loopModeDetailsLoopInitialized.copyWith(
        isTestRunning: false,
        isLoopModeFinished: true,
        currentNumberOfTestsStarted: 2,
        targetNumberOfTests: 2,
        currentTimeToNextTestSeconds: 60,
        lastTestTimestampMillis: 1661239706256,
      ),
    );

  });
}

_setUpStubs() {
  TestingServiceLocator.registerInstances();
  _prefs = GetIt.I.get<SharedPreferencesWrapper>();
}