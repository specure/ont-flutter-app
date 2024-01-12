import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/technology-signal.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/advanced-results.screen.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.state.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/results-metadata/results-metadata.view.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/results-qoe.view.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/results-qos.view.dart';
import '../../di/service-locator.dart';
import '../../measurements/unit-tests/network-service_test.mocks.dart';

class MockMeasurementResultCubit extends MockCubit<MeasurementResultState>
    implements MeasurementResultCubit {}

class MeasurementResultStateFake extends Fake
    implements MeasurementResultState {}

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    _setUpStubs();
  });

  group('Advanced Measurement result screen', () {
    testWidgets('Test Tabs', (tester) async {
      await _setUpStateAndPumpWidget(tester);
      final tabs = find.byType(DefaultTabController);
      expect(tabs, findsOneWidget);
      final tabbar = find.byType(TabBar);
      expect(tabbar, findsOneWidget);
      final tabsInTabBar = find.byType(Tab);
      expect(tabsInTabBar, findsNWidgets(3));
    });

    testWidgets('Test Select Tabs', (tester) async {
      await _setUpStateAndPumpWidget(tester);
      final qosTabWidget = find.byType(ResultsQosView);
      expect(qosTabWidget, findsOneWidget);

      final qoeTab = find.text('QoE');
      expect(qoeTab, findsOneWidget);
      await tester.tap(qoeTab);
      await tester.pumpAndSettle();

      final qoeTabWidget = find.byType(ResultsQoeView);
      expect(qoeTabWidget, findsOneWidget);

      final metadataTab = find.text('Metadata');
      expect(metadataTab, findsOneWidget);
      await tester.tap(metadataTab);
      await tester.pumpAndSettle();

      final metadataTabWidget = find.byType(ResultsMetadataView);
      expect(metadataTabWidget, findsOneWidget);
    });

    testWidgets('Test Back button', (tester) async {
      await _setUpStateAndPumpWidget(tester);
      final btn = find.byIcon(Icons.arrow_back);
      expect(btn, findsOneWidget);

      final controllerBefore = find.byType(AdvancedResultsScreen);
      expect(controllerBefore, findsOneWidget);

      await tester.tap(btn);
      await tester.pumpAndSettle();

      final controllerAfter = find.byType(AdvancedResultsScreen);
      expect(controllerAfter, findsNothing);
    });
  });
}

Future<MeasurementResultState> _setUpStateAndPumpWidget(
    WidgetTester tester) async {
  final state = MeasurementResultState(
    result: MeasurementHistoryResult(
        testUuid: 'uuid',
        uploadKbps: 1000,
        uploadSpeedDetails: [1.0, 1.5, 1.0],
        downloadKbps: 2000,
        downloadSpeedDetails: [2.0, 2.5, 2.0],
        pingMs: 100,
        jitterMs: 10.0,
        packetLossPercents: 0.0,
        measurementDate: '2020-01-01T15:00:00.000Z',
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
          home: const AdvancedResultsScreen(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return state;
}

_setUpStubs() {
  TestingServiceLocator.swapLazySingleton<PlatformWrapper>(
      () => MockPlatformWrapper());
  final platform = GetIt.I.get<PlatformWrapper>();
  when(platform.isAndroid).thenReturn(true);
  when(platform.localeName).thenReturn('en_US');
  when(GetIt.I.get<SharedPreferencesWrapper>().init())
      .thenAnswer((_) async => null);
  when(GetIt.I
          .get<SharedPreferencesWrapper>()
          .getString(StorageKeys.selectedLocaleTag))
      .thenReturn(_selectedLocaleTag);
}

MeasurementResultCubit setUpMeasurementResultCubit(
    MeasurementResultState state) {
  final cubit = MockMeasurementResultCubit();
  whenListen(
    cubit,
    Stream.fromIterable([state]),
    initialState: state,
  );
  return cubit;
}
