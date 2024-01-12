import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/loop-mode.button.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/loop-median.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/loop-mode-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/screens/measurement.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/loop-mode-closing-screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/loop-mode-execution-warning.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-body/measurement-body.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-median-box.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-result-item.widget.dart';

import '../../core/unit-tests/dio-service_test.mocks.dart';
import '../../di/service-locator.dart';
import 'start-test.widget_test.dart';

final _initState = MeasurementsState.init().copyWith(
  isContinuing: true,
  prevPhase: MeasurementPhase.up,
  phase: MeasurementPhase.submittingTestResult,
  phaseFinalResults: Map.fromEntries([
    MapEntry(MeasurementPhase.down, 2134),
    MapEntry(MeasurementPhase.up, 300),
    MapEntry(MeasurementPhase.packLoss, 0.5),
    MapEntry(MeasurementPhase.jitter, 13000000),
    MapEntry(MeasurementPhase.latency, 135000000)
  ]),
);

final String _selectedLocaleTag = 'sr-Latn-rs';

final _initStateWithNoJitterAndPacketLoss = MeasurementsState.init().copyWith(
  isContinuing: true,
  prevPhase: MeasurementPhase.up,
  phase: MeasurementPhase.submittingTestResult,
  phaseFinalResults: Map.fromEntries([
    MapEntry(MeasurementPhase.down, 2134),
    MapEntry(MeasurementPhase.up, 300),
    MapEntry(MeasurementPhase.packLoss, 0.5),
    MapEntry(MeasurementPhase.jitter, -1),
    MapEntry(MeasurementPhase.latency, -1)
  ]),
);

final _initStateWithInitInLoop = MeasurementsState.init().copyWith(
    isContinuing: true,
    prevPhase: MeasurementPhase.init,
    phase: MeasurementPhase.init,
    phaseFinalResults: Map.fromEntries([
      MapEntry(MeasurementPhase.down, null),
      MapEntry(MeasurementPhase.up, null),
      MapEntry(MeasurementPhase.packLoss, 0.5),
      MapEntry(MeasurementPhase.jitter, -1),
      MapEntry(MeasurementPhase.latency, -1)
    ]),
    loopModeDetails: _loopModeDetailsLoopInitFirstTest);

final _loopModeDetailsLoopInitFirstTest = LoopModeDetails(
  isLoopModeEnabled: true,
  isLoopModeActive: true,
  isLoopModeFeatureEnabled: true,
  isTestRunning: true,
  isLoopModeFinished: false,
  shouldAnotherTestBeStarted: false,
  shouldLoopModeBeStarted: false,
  isLoopModeNetNeutralityTestEnabled: false,
  currentNumberOfTestsStarted: 1,
  currentDistanceMetersPassedFromLastTest: 125,
  currentTimeToNextTestSeconds: 50,
  targetTimeSecondsToNextTest: 60,
  targetDistanceMetersToNextTest: 200,
  targetNumberOfTests: 5,
  medians: HashMap<MeasurementPhase, LoopMedian>(),
  results: null,
  loopUuid: null,
  lastTestTimestampMillis: null,
  lastTestLocation: null,
  currentTestLocation: null,
);

final _loopModeDetailsLoopInProgress = LoopModeDetails(
  isLoopModeEnabled: true,
  isLoopModeActive: true,
  isLoopModeFeatureEnabled: true,
  isTestRunning: true,
  isLoopModeFinished: false,
  shouldAnotherTestBeStarted: false,
  shouldLoopModeBeStarted: false,
  isLoopModeNetNeutralityTestEnabled: false,
  currentNumberOfTestsStarted: 2,
  currentDistanceMetersPassedFromLastTest: 125,
  currentTimeToNextTestSeconds: 50,
  targetTimeSecondsToNextTest: 60,
  targetDistanceMetersToNextTest: 200,
  targetNumberOfTests: 5,
  medians: HashMap<MeasurementPhase, LoopMedian>.from({
    MeasurementPhase.down: LoopMedian(values: [5000.0], medianValue: 5000.0),
    MeasurementPhase.packLoss: LoopMedian(values: [3.0], medianValue: 3.0),
    MeasurementPhase.up: LoopMedian(values: [2000.0], medianValue: 2000.0),
    MeasurementPhase.latency: LoopMedian(values: [100.0], medianValue: 100.0)
  }),
  results: [_loopFirstResult],
  historyResults: [_loopFirstResult.mapToHistoryResult()],
  loopUuid: null,
  lastTestTimestampMillis: null,
  lastTestLocation: null,
  currentTestLocation: null,
);

final _loopFirstResult = MeasurementResult(
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
  packetLoss: 4,
  uuid: 'uuid',
);

final _loopModeDetailsWaitingAfterFirstTest = LoopModeDetails(
  isLoopModeEnabled: true,
  isLoopModeActive: true,
  isLoopModeFeatureEnabled: true,
  isTestRunning: false,
  isLoopModeFinished: false,
  shouldAnotherTestBeStarted: false,
  shouldLoopModeBeStarted: false,
  isLoopModeNetNeutralityTestEnabled: false,
  currentNumberOfTestsStarted: 1,
  currentDistanceMetersPassedFromLastTest: 125,
  currentTimeToNextTestSeconds: 50,
  targetTimeSecondsToNextTest: 60,
  targetDistanceMetersToNextTest: 200,
  targetNumberOfTests: 5,
  medians: HashMap<MeasurementPhase, LoopMedian>.from({
    MeasurementPhase.down: LoopMedian(values: [5000.0], medianValue: 5000.0),
    MeasurementPhase.packLoss: LoopMedian(values: [3.0], medianValue: 3.0),
    MeasurementPhase.up: LoopMedian(values: [2000.0], medianValue: 2000.0),
    MeasurementPhase.latency: LoopMedian(values: [100.0], medianValue: 100.0),
    MeasurementPhase.jitter: LoopMedian(values: [100.0], medianValue: 100.0)
  }),
  results: [_loopFirstResult],
  historyResults: [_loopFirstResult.mapToHistoryResult()],
  loopUuid: null,
  lastTestTimestampMillis: null,
  lastTestLocation: null,
  currentTestLocation: null,
);

final _loopModeDetailsWaitingAfterFirstFailedTest = LoopModeDetails(
  isLoopModeEnabled: true,
  isLoopModeActive: true,
  isLoopModeFeatureEnabled: true,
  isTestRunning: false,
  isLoopModeFinished: false,
  shouldAnotherTestBeStarted: false,
  shouldLoopModeBeStarted: false,
  isLoopModeNetNeutralityTestEnabled: false,
  currentNumberOfTestsStarted: 1,
  currentDistanceMetersPassedFromLastTest: 125,
  currentTimeToNextTestSeconds: 50,
  targetTimeSecondsToNextTest: 60,
  targetDistanceMetersToNextTest: 200,
  targetNumberOfTests: 5,
  medians: HashMap(),
  results: [],
  historyResults: null,
  loopUuid: null,
  lastTestTimestampMillis: null,
  lastTestLocation: null,
  currentTestLocation: null,
);

final _progressStateWithSecondMeasurementInLoop =
    MeasurementsState.init().copyWith(
        isContinuing: true,
        prevPhase: MeasurementPhase.latency,
        phase: MeasurementPhase.packLoss,
        phaseFinalResults: Map.fromEntries([
          MapEntry(MeasurementPhase.down, null),
          MapEntry(MeasurementPhase.up, null),
          MapEntry(MeasurementPhase.packLoss, 0.5),
          MapEntry(MeasurementPhase.jitter, -1),
          MapEntry(MeasurementPhase.latency, -1)
        ]),
        loopModeDetails: _loopModeDetailsLoopInProgress);

final _initStateWithSecondMeasurementInLoop = MeasurementsState.init().copyWith(
    isContinuing: true,
    prevPhase: MeasurementPhase.init,
    phase: MeasurementPhase.init,
    phaseFinalResults: Map.fromEntries([
      MapEntry(MeasurementPhase.down, null),
      MapEntry(MeasurementPhase.up, null),
      MapEntry(MeasurementPhase.packLoss, 0.5),
      MapEntry(MeasurementPhase.jitter, -1),
      MapEntry(MeasurementPhase.latency, -1)
    ]),
    loopModeDetails: _loopModeDetailsLoopInProgress);

final _loopWaitingPhaseAfterFirstMeasurementInLoop =
    MeasurementsState.init().copyWith(
        isContinuing: true,
        prevPhase: MeasurementPhase.up,
        phase: MeasurementPhase.submittingTestResult,
        phaseFinalResults: Map.fromEntries([
          MapEntry(MeasurementPhase.down, 2134),
          MapEntry(MeasurementPhase.up, 300),
          MapEntry(MeasurementPhase.packLoss, 0.5),
          MapEntry(MeasurementPhase.jitter, 13000000),
          MapEntry(MeasurementPhase.latency, 135000000)
        ]),
        loopModeDetails: _loopModeDetailsWaitingAfterFirstTest);

final _loopWaitingPhaseAfterFailedFirstMeasurementInLoop =
    MeasurementsState.init().copyWith(
        isContinuing: true,
        prevPhase: MeasurementPhase.init,
        phase: MeasurementPhase.init,
        phaseFinalResults: Map.fromEntries([
          MapEntry(MeasurementPhase.down, null),
          MapEntry(MeasurementPhase.up, null),
          MapEntry(MeasurementPhase.packLoss, 0.5),
          MapEntry(MeasurementPhase.jitter, -1),
          MapEntry(MeasurementPhase.latency, -1)
        ]),
        loopModeDetails: _loopModeDetailsWaitingAfterFirstFailedTest);

final _bloc = MockMeasurementsBloc();

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => _bloc);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
    when(GetIt.I.get<NavigationService>().goBack())
        .thenAnswer((realInvocation) => {});
  });

  testWidgets('shows measurements process and allows to stop it [landscape]',
      (widgetTester) async {
    final size = Size(1920, 1200);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _basicTest(widgetTester, size);
  });

  testWidgets('loop test in initialization - landscape', (widgetTester) async {
    final size = Size(1920, 1200);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _loopTestInitialization(widgetTester, size);
  });

  testWidgets('loop test in initialization - portrait', (widgetTester) async {
    final size = Size(1200, 1920);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _loopTestInitialization(widgetTester, size);
  });

  testWidgets('loop test in progress - landscape', (widgetTester) async {
    final size = Size(1920, 1200);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _loopTestSecondTestInProgress(widgetTester, size);
  });

  testWidgets('loop test in progress - portrait', (widgetTester) async {
    final size = Size(1200, 1920);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _loopTestSecondTestInProgress(widgetTester, size);
  });

  testWidgets('loop test initialization of 2nd test progress - landscape',
      (widgetTester) async {
    final size = Size(1920, 1200);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _loopTestSecondTestInit(widgetTester, size);
  });

  testWidgets('loop test initialization of 2nd test progress - portrait',
      (widgetTester) async {
    final size = Size(1200, 1920);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _loopTestSecondTestInit(widgetTester, size);
  });

  testWidgets('loop test waiting phase after 1 test - landscape',
      (widgetTester) async {
    final size = Size(1920, 1200);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _loopWaitingPhaseAfterFirstTest(widgetTester, size);
  });

  testWidgets('loop test waiting phase after failed test - landscape',
      (widgetTester) async {
    final size = Size(1920, 1200);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _loopWaitingPhaseAfterFirstFailedTest(widgetTester, size);
  });

  testWidgets('loop test waiting phase after 1 test - portrait',
      (widgetTester) async {
    final size = Size(1200, 1920);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _loopWaitingPhaseAfterFirstTest(widgetTester, size);
  });

  testWidgets('loop test waiting phase after failed test - portrait',
      (widgetTester) async {
    final size = Size(1200, 1920);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _loopWaitingPhaseAfterFirstFailedTest(widgetTester, size);
  });

  testWidgets(
      'shows measurements process and allows to stop it with no jitter and packet loss values [portrait]',
      (widgetTester) async {
    final size = Size(1200, 1920);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _basicTestNoJitterAndPacketLoss(widgetTester, size);
  });

  testWidgets('shows measurements process and allows to stop it [portrait]',
      (widgetTester) async {
    final size = Size(1200, 1920);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _basicTest(widgetTester, size);
  });

  testWidgets(
      'stop loop measurement screen cancelled - waiting phase [portrait]',
      (widgetTester) async {
    final size = Size(1200, 1920);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _stopCancellingLoopMeasurementWaitingPhase(widgetTester, size);
  });

  testWidgets(
      'stop loop measurement screen cancelled - waiting phase [landscape]',
      (widgetTester) async {
    final size = Size(1920, 1200);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _stopCancellingLoopMeasurementWaitingPhase(widgetTester, size);
  });

  testWidgets(
      'stop loop measurement screen cancelled - execution phase [portrait]',
      (widgetTester) async {
    final size = Size(1200, 1920);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _stopCancellingLoopMeasurementExecutionPhase(widgetTester, size);
  });

  testWidgets(
      'stop loop measurement screen cancelled - execution phase [landscape]',
      (widgetTester) async {
    final size = Size(1920, 1200);
    widgetTester.view.physicalSize = size;
    addTearDown(widgetTester.view.resetPhysicalSize);
    await _stopCancellingLoopMeasurementExecutionPhase(widgetTester, size);
  });

  testWidgets('when measurement is stopped screen is closed',
      (widgetTester) async {
    whenListen(
        _bloc,
        Stream.fromIterable([
          _initState,
          _initState.copyWith(
            isContinuing: false,
            phase: MeasurementPhase.none,
          ),
        ]),
        initialState: _initState);
    await widgetTester.pumpWidget(BlocProvider<MeasurementsBloc>(
      create: (_) => _bloc,
      child: MaterialApp(home: MeasurementScreen()),
    ));
    expect(find.byType(MeasurementBody), findsOneWidget);
    verify(GetIt.I.get<NavigationService>().goBack()).called(1);
  });
}

Future<void> _stopCancellingLoopMeasurementWaitingPhase(
    WidgetTester widgetTester, Size size) async {
  whenListen(
      _bloc,
      Stream.fromIterable(
        [
          _loopWaitingPhaseAfterFirstMeasurementInLoop.copyWith(
              leavingScreenShown: true),
        ],
      ),
      initialState: _loopWaitingPhaseAfterFirstMeasurementInLoop.copyWith(
          leavingScreenShown: true));
  await widgetTester.pumpWidget(BlocProvider<MeasurementsBloc>(
    create: (_) => _bloc,
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: MeasurementScreen(),
      ),
    ),
  ));
  await widgetTester.pumpAndSettle();
  final blocCalls = MockMeasurementsBlocCalls();
  TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => blocCalls);
  when(blocCalls.setCloseDialogVisible(true)).thenAnswer((realInvocation) {});
  expect(find.byType(LoopModeClosingWarning), findsOneWidget);
  expect(find.byType(AppBar), findsNothing);
  expect(find.text('Are you sure?'), findsOneWidget);
  expect(find.text('No, continue'), findsOneWidget);
  expect(find.text('Yes, abort measurement'), findsOneWidget);
  expect(
      find.text(
          'Are you sure you want to stop the loop mode measurement? Unfinished measurements will not be saved to your results.'),
      findsOneWidget);
  await widgetTester.tap(find.text('No, continue'));
  verify(blocCalls.setCloseDialogVisible(false)).called(1);
}

Future<void> _stopCancellingLoopMeasurementExecutionPhase(
    WidgetTester widgetTester, Size size) async {
  whenListen(
      _bloc,
      Stream.fromIterable(
        [
          _progressStateWithSecondMeasurementInLoop.copyWith(
              leavingScreenShown: true),
        ],
      ),
      initialState: _progressStateWithSecondMeasurementInLoop.copyWith(
          leavingScreenShown: true));
  await widgetTester.pumpWidget(BlocProvider<MeasurementsBloc>(
    create: (_) => _bloc,
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: MeasurementScreen(),
      ),
    ),
  ));
  await widgetTester.pumpAndSettle();
  final blocCalls = MockMeasurementsBlocCalls();
  TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => blocCalls);
  when(blocCalls.setCloseDialogVisible(true)).thenAnswer((realInvocation) {});
  expect(find.byType(LoopModeClosingWarning), findsOneWidget);
  expect(find.byType(AppBar), findsNothing);
  expect(find.text('Are you sure?'), findsOneWidget);
  expect(find.text('No, continue'), findsOneWidget);
  expect(find.text('Yes, abort measurement'), findsOneWidget);
  expect(
      find.text(
          'Are you sure you want to stop the loop mode measurement? Unfinished measurements will not be saved to your results.'),
      findsOneWidget);
  await widgetTester.tap(find.text('No, continue'));
  verify(blocCalls.setCloseDialogVisible(false)).called(1);
}

Future<void> _basicTest(WidgetTester widgetTester, Size size) async {
  whenListen(
      _bloc,
      Stream.fromIterable(
        [
          _initState,
          _initState.copyWith(prevPhase: MeasurementPhase.submittingTestResult),
        ],
      ),
      initialState: _initState);
  await widgetTester.pumpWidget(BlocProvider<MeasurementsBloc>(
    create: (_) => _bloc,
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: MeasurementScreen(),
      ),
    ),
  ));
  expect(find.byType(MeasurementBody), findsOneWidget);
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
  expect(find.byIcon(Icons.close), findsOneWidget);

  await widgetTester.pump();
  expect(find.byType(MeasurementBody), findsOneWidget);
  expect(find.byType(MeasurementResultItem), findsNWidgets(3));
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
  expect(find.byIcon(Icons.close), findsOneWidget);
  final blocCalls = MockMeasurementsBlocCalls();
  TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => blocCalls);
  when(blocCalls.add(any)).thenAnswer((realInvocation) {});
  expect(find.text("2.13"), findsOneWidget);
  expect(find.text("0.3"), findsOneWidget);
  expect(find.text('135'), findsOneWidget);
  await widgetTester.tap(find.byIcon(Icons.close));
  verify(blocCalls.add(any)).called(1);
}

Future<void> _basicTestNoJitterAndPacketLoss(
    WidgetTester widgetTester, Size size) async {
  whenListen(
      _bloc,
      Stream.fromIterable(
        [
          _initStateWithNoJitterAndPacketLoss,
          _initStateWithNoJitterAndPacketLoss.copyWith(
            prevPhase: MeasurementPhase.submittingTestResult,
          ),
        ],
      ),
      initialState: _initStateWithNoJitterAndPacketLoss);
  await widgetTester.pumpWidget(BlocProvider<MeasurementsBloc>(
    create: (_) => _bloc,
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: MeasurementScreen(),
      ),
    ),
  ));
  expect(find.byType(MeasurementBody), findsOneWidget);
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
  expect(find.byIcon(Icons.close), findsOneWidget);
  await widgetTester.pump();
  expect(find.byType(MeasurementBody), findsOneWidget);
  expect(find.byType(MeasurementResultItem), findsNWidgets(3));
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
  expect(find.byIcon(Icons.close), findsOneWidget);
  final blocCalls = MockMeasurementsBlocCalls();
  TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => blocCalls);
  when(blocCalls.add(any)).thenAnswer((realInvocation) {});
  expect(find.text("2.13"), findsOneWidget);
  expect(find.text("0.3"), findsOneWidget);
  expect(find.text('-'), findsNWidgets(1));
  expect(find.byType(LoopModeExecutionWarning), findsNothing);
  await widgetTester.tap(find.byIcon(Icons.close));
  verify(blocCalls.add(any)).called(1);
}

Future<void> _loopTestSecondTestInProgress(
    WidgetTester widgetTester, Size size) async {
  whenListen(
      _bloc,
      Stream.fromIterable(
        [
          _progressStateWithSecondMeasurementInLoop,
        ],
      ),
      initialState: _progressStateWithSecondMeasurementInLoop);
  await widgetTester.pumpWidget(BlocProvider<MeasurementsBloc>(
    create: (_) => _bloc,
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: MeasurementScreen(),
      ),
    ),
  ));
  expect(find.byType(MeasurementBody), findsOneWidget);
  expect(find.byType(MeasurementMedianBox), findsOneWidget);
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
  expect(find.byIcon(Icons.close), findsOneWidget);
  await widgetTester.pump();
  expect(find.byType(MeasurementBody), findsOneWidget);
  expect(find.byType(MeasurementResultItem), findsNWidgets(3));
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
  expect(find.byIcon(Icons.close), findsOneWidget);
  final blocCalls = MockMeasurementsBlocCalls();
  TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => blocCalls);
  when(blocCalls.setCloseDialogVisible(true)).thenAnswer((realInvocation) {});
  expect(find.text('3.0'), findsNWidgets(1));
  expect(find.text('5', skipOffstage: false), findsOneWidget);
  expect(find.text('2', skipOffstage: false), findsOneWidget);
  expect(find.text('MEDIAN'), findsNWidgets(2));
  expect(find.text('-'), findsNWidgets(3));
  expect(find.text('125/200m'), findsOneWidget);
  expect(find.text('00:50 min'), findsOneWidget);
  expect(find.text('TIME TO NEXT TEST'), findsOneWidget);
  expect(find.text('MOVEMENT'), findsOneWidget);
  expect(find.text('Loop Measurement 2 of 5'), findsOneWidget);
  expect(find.byType(LoopModeExecutionWarning), findsOneWidget);
  expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
  expect(
      find.text(
          "Due to operating system restrictions, the loop mode will stop if you navigate away from the screen or close the application."),
      findsOneWidget);
  expect(find.byType(LoopModeButton), findsOneWidget);
  await widgetTester.tap(find.byIcon(Icons.close));
  verify(blocCalls.setCloseDialogVisible(true)).called(1);
}

Future<void> _loopTestSecondTestInit(
    WidgetTester widgetTester, Size size) async {
  whenListen(
      _bloc,
      Stream.fromIterable(
        [
          _initStateWithSecondMeasurementInLoop,
        ],
      ),
      initialState: _initStateWithSecondMeasurementInLoop);
  await widgetTester.pumpWidget(BlocProvider<MeasurementsBloc>(
    create: (_) => _bloc,
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: MeasurementScreen(),
      ),
    ),
  ));
  expect(find.byType(MeasurementBody), findsOneWidget);
  expect(find.byType(MeasurementMedianBox), findsNothing);
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
  expect(find.byIcon(Icons.close), findsOneWidget);
  await widgetTester.pump();
  expect(find.byType(MeasurementBody), findsOneWidget);
  expect(find.byType(MeasurementResultItem), findsNWidgets(3));
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
  expect(find.byIcon(Icons.close), findsOneWidget);
  final blocCalls = MockMeasurementsBlocCalls();
  TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => blocCalls);
  when(blocCalls.setCloseDialogVisible(true)).thenAnswer((realInvocation) {});
  expect(find.text('5', skipOffstage: false), findsOneWidget);
  expect(find.text('2', skipOffstage: false), findsOneWidget);
  expect(find.text('MEDIAN'), findsNWidgets(1));
  expect(find.text('-'), findsNWidgets(3));
  expect(find.text('125/200m'), findsOneWidget);
  expect(find.text('00:50 min'), findsOneWidget);
  expect(find.text('TIME TO NEXT TEST'), findsOneWidget);
  expect(find.text('MOVEMENT'), findsOneWidget);
  expect(find.text('Loop Measurement 2 of 5'), findsOneWidget);
  expect(find.byType(LoopModeButton), findsOneWidget);
  await widgetTester.tap(find.byIcon(Icons.close));
  verify(blocCalls.setCloseDialogVisible(true)).called(1);
}

Future<void> _loopTestInitialization(
    WidgetTester widgetTester, Size size) async {
  whenListen(
      _bloc,
      Stream.fromIterable(
        [
          _initStateWithInitInLoop,
        ],
      ),
      initialState: _initStateWithInitInLoop);
  await widgetTester.pumpWidget(BlocProvider<MeasurementsBloc>(
    create: (_) => _bloc,
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: MeasurementScreen(),
      ),
    ),
  ));
  expect(find.byType(MeasurementBody), findsOneWidget);
  expect(find.byType(MeasurementMedianBox), findsNothing);
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
  expect(find.byIcon(Icons.close), findsOneWidget);
  await widgetTester.pump();
  expect(find.byType(MeasurementBody), findsOneWidget);
  expect(find.byType(MeasurementResultItem), findsNWidgets(3));
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
  expect(find.byIcon(Icons.close), findsOneWidget);
  final blocCalls = MockMeasurementsBlocCalls();
  TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => blocCalls);
  when(blocCalls.setCloseDialogVisible(true)).thenAnswer((realInvocation) {});
  expect(find.text('3.0'), findsNothing);
  expect(find.text('5', skipOffstage: false), findsNothing);
  expect(find.text('2', skipOffstage: false), findsNothing);
  expect(find.text('MEDIAN'), findsNothing);
  expect(find.text('-'), findsNWidgets(3));
  expect(find.text('125/200m'), findsOneWidget);
  expect(find.text('00:50 min'), findsOneWidget);
  expect(find.text('TIME TO NEXT TEST'), findsOneWidget);
  expect(find.text('MOVEMENT'), findsOneWidget);
  expect(find.text('Loop Measurement 1 of 5'), findsOneWidget);
  expect(find.byType(LoopModeButton), findsOneWidget);
  await widgetTester.tap(find.byIcon(Icons.close));
  verify(blocCalls.setCloseDialogVisible(true)).called(1);
}

Future<void> _loopWaitingPhaseAfterFirstTest(
    WidgetTester widgetTester, Size size) async {
  whenListen(
      _bloc,
      Stream.fromIterable(
        [
          _loopWaitingPhaseAfterFirstMeasurementInLoop,
        ],
      ),
      initialState: _loopWaitingPhaseAfterFirstMeasurementInLoop);
  await widgetTester.pumpWidget(BlocProvider<MeasurementsBloc>(
    create: (_) => _bloc,
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: MeasurementScreen(),
      ),
    ),
  ));
  await widgetTester.pumpAndSettle();
  expect(find.byType(MeasurementBody), findsNothing);
  expect(find.byType(MeasurementMedianBox), findsNothing);
  expect(find.byType(LinearProgressIndicator), findsNothing);
  expect(find.byIcon(Icons.close), findsOneWidget);
  // await widgetTester.pump();
  widgetTester.allWidgets;
  expect(find.byType(MeasurementBody), findsNothing);
  expect(find.byType(MeasurementResultItem), findsNothing);
  expect(find.byType(LinearProgressIndicator), findsNothing);
  expect(find.byIcon(Icons.close), findsOneWidget);
  final blocCalls = MockMeasurementsBlocCalls();
  TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => blocCalls);
  when(blocCalls.setCloseDialogVisible(true)).thenAnswer((realInvocation) {});
  expect(find.text('Interim results (Median values)'), findsOneWidget);
  expect(find.text('DOWNLOAD'), findsOneWidget);
  expect(find.text('UPLOAD'), findsOneWidget);
  expect(find.text('PING'), findsOneWidget);
  expect(find.text('TIME TO NEXT TEST'), findsOneWidget);
  expect(find.text('MOVEMENT'), findsOneWidget);
  expect(find.textContaining('Mbps'), findsNWidgets(2));
  expect(find.textContaining('ms'), findsNWidgets(1));
  expect(find.textContaining('2', skipOffstage: false), findsNWidgets(2));
  expect(find.text('MEDIAN'), findsNothing);
  expect(find.text('-'), findsNothing);
  expect(find.text('Loop Measurement 1 of 5'), findsOneWidget);
  expect(find.byType(LoopModeButton), findsOneWidget);
  // TODO: why it is not able to find these in waiting screen
  // expect(find.text('125/200m', skipOffstage: false), findsOneWidget);
  // expect(find.text('00:50 min'), findsOneWidget);
  // expect(find.text('Mbps'), findsNWidgets(4));
  // expect(find.textContaining('ms'), findsNWidgets(3));
  // expect(find.textContaining('%'), findsOneWidget);
  await widgetTester.tap(find.byIcon(Icons.close));
  verify(blocCalls.setCloseDialogVisible(true)).called(1);
}

Future<void> _loopWaitingPhaseAfterFirstFailedTest(
    WidgetTester widgetTester, Size size) async {
  whenListen(
      _bloc,
      Stream.fromIterable(
        [_loopWaitingPhaseAfterFailedFirstMeasurementInLoop],
      ),
      initialState: _loopWaitingPhaseAfterFailedFirstMeasurementInLoop);
  await widgetTester.pumpWidget(BlocProvider<MeasurementsBloc>(
    create: (_) => _bloc,
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: MeasurementScreen(),
      ),
    ),
  ));
  await widgetTester.pumpAndSettle();
  expect(find.byType(MeasurementBody), findsNothing);
  expect(find.byType(MeasurementMedianBox), findsNothing);
  expect(find.byType(LinearProgressIndicator), findsNothing);
  expect(find.byIcon(Icons.close), findsOneWidget);
  // await widgetTester.pump();
  widgetTester.allWidgets;
  expect(find.byType(MeasurementBody), findsNothing);
  expect(find.byType(MeasurementResultItem), findsNothing);
  expect(find.byType(LinearProgressIndicator), findsNothing);
  expect(find.byIcon(Icons.close), findsOneWidget);
  final blocCalls = MockMeasurementsBlocCalls();
  TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => blocCalls);
  when(blocCalls.setCloseDialogVisible(true)).thenAnswer((realInvocation) {});
  expect(find.text('Interim results (Median values)'), findsOneWidget);
  expect(find.text('DOWNLOAD'), findsOneWidget);
  expect(find.text('UPLOAD'), findsOneWidget);
  expect(find.text('PING'), findsOneWidget);
  expect(find.text('TIME TO NEXT TEST'), findsOneWidget);
  expect(find.text('MOVEMENT'), findsOneWidget);
  expect(find.textContaining('Mbps'), findsNothing);
  expect(find.textContaining('ms'), findsNothing);
  expect(find.text('MEDIAN'), findsNothing);
  expect(find.text('-'), findsNothing);
  expect(find.text('Loop Measurement 1 of 5'), findsOneWidget);
  expect(find.byType(LoopModeButton), findsOneWidget);
  // TODO: why it is not able to find these in waiting screen
  // expect(find.text('125/200m', skipOffstage: false), findsOneWidget);
  // expect(find.text('00:50 min'), findsOneWidget);
  // expect(find.text('Mbps'), findsNWidgets(2));
  // expect(find.textContaining('ms'), findsNWidgets(3));
  // expect(find.textContaining('%'), findsOneWidget);
  await widgetTester.tap(find.byIcon(Icons.close));
  verify(blocCalls.setCloseDialogVisible(true)).called(1);
}
