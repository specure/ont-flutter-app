import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/di/service-locator.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/wrappers/url-launcher-wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/constants/signal-strength.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/technology-signal.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.state.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/network-speed-section.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/result-bottom-sheet.widget.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/results-qos.view.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/technology-over-time.chart.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/text-section.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../di/service-locator.dart';
import '../../measurements/unit-tests/network-service_test.mocks.dart';
import 'results-qos-view-widget_test.mocks.dart';

class MockMeasurementResultCubit extends MockCubit<MeasurementResultState>
    implements MeasurementResultCubit {}

class MeasurementResultStateFake extends Fake
    implements MeasurementResultState {}

var _mockMeasurementResultCubit = MockMeasurementResultCubit();

final _pageUrl = "https://pageUrl.com";

@GenerateMocks([
  UrlLauncherWrapper
], customMocks: [
  MockSpec<MeasurementResultCubit>(
    as: #MockMeasurementResultCubitCalls,
    onMissingStub: OnMissingStub.returnDefault,
  )
])
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ServiceLocator.registerInstances();
    _setUpStubs();
  });

  testWidgets('Test Results QoS view widget', (tester) async {
    final state = await _setUpStateAndPumpWidget(tester);
    _testQoSView(state);
    TestingServiceLocator.registerInstances();
    final cubit = MockMeasurementResultCubitCalls();
    TestingServiceLocator.swapLazySingleton<MeasurementResultCubit>(
        () => cubit);
    final mockUrlLauncher = MockUrlLauncherWrapper();
    TestingServiceLocator.swapLazySingleton<UrlLauncherWrapper>(
        () => mockUrlLauncher);
    when(mockUrlLauncher.canLaunch(Uri.parse(_pageUrl)))
        .thenAnswer((_) async => true);
    when(mockUrlLauncher.launch(Uri.parse(_pageUrl)))
        .thenAnswer((_) async => true);
    var qosExplanationIcon = find.byIcon(Icons.info_outline);
    expect(qosExplanationIcon, findsOneWidget);
    var qosExplanationFinder = find.text("Learn more ***REMOVED*** Quality of Service");
    expect(qosExplanationFinder, findsOneWidget);
    await tester.tap(qosExplanationFinder);
    await tester.pumpAndSettle();
    TestingServiceLocator.swapLazySingleton<MeasurementResultCubit>(
        () => _mockMeasurementResultCubit);
    verify(cubit.getPage(any, pageContent: anyNamed('pageContent'))).called(1);
    var bottomSheetFinder = find.byType(ResultBottomSheet);
    expect(bottomSheetFinder, findsOneWidget);
    var linkPage = find.text("Read more on our website");
    expect(linkPage, findsOneWidget);
    await tester.tap(linkPage);
    await tester.pumpAndSettle();
    verify(mockUrlLauncher.canLaunch(Uri.parse(_pageUrl))).called(1);
    verify(mockUrlLauncher.launch(Uri.parse(_pageUrl))).called(1);
  });
}

_testQoSView(MeasurementResultState state) async {
  final downloadSpeedSectionFinder = find.byWidgetPredicate((widget) =>
      widget is NetworkSpeedSection &&
      widget.speed == '2' &&
      widget.title == 'Download' &&
      widget.speedList == state.result!.downloadSpeedDetails);
  final uploadSpeedSectionFinder = find.byWidgetPredicate((widget) =>
      widget is NetworkSpeedSection &&
      widget.speed == '1' &&
      widget.title == 'Upload' &&
      widget.speedList == state.result!.uploadSpeedDetails);
  final pingFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Ping' &&
      widget.value == '100' &&
      widget.valueUnit == 'ms');
  final signalFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Signal' &&
      widget.value == '-60' &&
      widget.valueUnit == 'dBm');
  final signalQualityFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Quality' &&
      widget.value == getSignalQuality('3G', -60) &&
      widget.valueUnit!.isEmpty);
  final technologyChartFinder = find.byWidgetPredicate((widget) =>
      widget is TechnologyOverTimeChart &&
      widget.signals == state.result!.radioSignals);
  expect(downloadSpeedSectionFinder, findsOneWidget);
  expect(uploadSpeedSectionFinder, findsOneWidget);
  expect(pingFinder, findsOneWidget);
  expect(signalFinder, findsOneWidget);
  expect(signalQualityFinder, findsOneWidget);
  expect(technologyChartFinder, findsOneWidget);
}

Future<MeasurementResultState> _setUpStateAndPumpWidget(
    WidgetTester tester) async {
  final state = MeasurementResultState(
    project: NTProject.fromJson({"enable_app_qos_result_explanation": true}),
    staticPageContent: "page content",
    staticPageUrl: _pageUrl,
    result: MeasurementHistoryResult(
        testUuid: 'uuid',
        uploadKbps: 1000,
        uploadSpeedDetails: [1.0, 1.5, 1.0],
        downloadKbps: 2000,
        downloadSpeedDetails: [2.0, 2.5, 2.0],
        pingMs: 100,
        jitterMs: 10.0,
        packetLossPercents: 0.0,
        measurementDate: '01.01.1970',
        userExperienceMetrics: [],
        radioSignals: [
          TechnologySignal.fromJson({
            'signal': -50,
            'technology': '3G',
            'timeNs': 500,
          }),
          TechnologySignal.fromJson({
            'signal': -55,
            'technology': '3G',
            'timeNs': 1000,
          }),
          TechnologySignal.fromJson({
            'signal': -60,
            'technology': '3G',
            'timeNs': 1500,
          }),
        ]),
  );
  final cubit = setUpMeasurementResultCubit(state);
  await tester.pumpWidget(
    BlocProvider<MeasurementResultCubit>(
      create: (cntx) => cubit,
      child: MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: const ResultsQosView(),
        ),
      ),
    ),
  );
  return state;
}

_setUpStubs() {
  TestingServiceLocator.swapLazySingleton<PlatformWrapper>(
      () => MockPlatformWrapper());
  final platform = GetIt.I.get<PlatformWrapper>();
  when(platform.isAndroid).thenReturn(true);
  when(platform.localeName).thenReturn('en_US');
}

MeasurementResultCubit setUpMeasurementResultCubit(
    MeasurementResultState state) {
  whenListen(
    _mockMeasurementResultCubit,
    Stream.fromIterable([state]),
    initialState: state,
  );
  return _mockMeasurementResultCubit;
}
