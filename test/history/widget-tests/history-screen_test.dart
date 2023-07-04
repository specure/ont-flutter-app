import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/api-errors.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/widgets/error.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/history-net-neutrality-item.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/screens/history.screen.dart';
import 'package:nt_flutter_standalone/modules/history/store/net-neutrality-history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/net-neutrality-history.state.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/net-neutrality-view.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/no-results.view.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/speed-view/speed.view.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.state.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-results.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-category.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-measurement.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

extension _HistoryWidgetTester on WidgetTester {
  findWidgetOfType(Type type, Widget widget) async {
    await this.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider<HistoryCubit>(
          create: (context) => _historyCubit,
        ),
        BlocProvider<NetNeutralityHistoryCubit>(
          create: (context) => _netNeutralityHistoryCubit,
        )
      ],
      child: MaterialApp(
        home: widget,
      ),
    ));
    await this.pumpAndSettle();
    final errorWidget = find.byType(type);
    expect(errorWidget, findsOneWidget);
  }
}

late final HistoryCubit _historyCubit;
late final NetNeutralityHistoryCubit _netNeutralityHistoryCubit;
late final NetNeutralityCubit _netNeutralityCubit;
final _initialState = HistoryState(speedHistory: [], loading: true);
final _initialNNState =
    NetNeutralityHistoryState(netNeutralityHistory: [], loading: true);
final String _selectedLocaleTag = 'sr-Latn-rs';
final _nnHistory = [
  NetNeutralityHistoryMeasurement(
    openTestUuid: 'openTestUuid1',
    deviceName: 'device',
    networkType: '4G',
    measurementDate: "2022-10-10T10:45:13.309631Z",
    tests: HashMap.fromEntries([
      MapEntry(
          'WEB',
          NetNeutralityHistoryCategory('WEB',
              totalResults: 3,
              successfulResults: 1,
              failedResults: 1,
              deviceName: 'device',
              networkType: '4G',
              measurementDate: '2020-01-01T15:00:00.000Z',
              type: 'WEB',
              items: [])),
      MapEntry(
          'DNS',
          NetNeutralityHistoryCategory('DNS',
              totalResults: 1,
              successfulResults: 1,
              failedResults: 0,
              deviceName: 'device',
              networkType: '4G',
              measurementDate: '2020-01-01T15:00:00.000Z',
              type: 'DNS',
              items: [])),
    ]),
  ),
  NetNeutralityHistoryMeasurement(
    openTestUuid: 'openTestUuid2',
    deviceName: 'device',
    networkType: '4G',
    measurementDate: "2022-10-11T10:43:13.309631Z",
    tests: HashMap.fromEntries([
      MapEntry(
          'WEB',
          NetNeutralityHistoryCategory('WEB',
              totalResults: 3,
              successfulResults: 2,
              failedResults: 1,
              deviceName: 'device',
              networkType: '4G',
              measurementDate: '2020-01-01',
              type: 'WEB',
              items: [])),
    ]),
  )
];

@GenerateMocks([NetNeutralityCubit])
void main() {
  setUpAll(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getBool(StorageKeys.netNeutralityTestsEnabled))
        .thenReturn(false);
    _historyCubit = GetIt.I.get<HistoryCubit>();
    _netNeutralityHistoryCubit = GetIt.I.get<NetNeutralityHistoryCubit>();
    _netNeutralityCubit = GetIt.I.get<NetNeutralityCubit>();
    TestingServiceLocator.swapLazySingleton<NetNeutralityCubit>(
        () => _netNeutralityCubit);
  });

  group('HistoryScreen', () {
    testWidgets('when the history is not enabled shows no results view',
        (tester) async {
      final state =
          _initialState.copyWith(loading: false, isHistoryEnabled: false);
      whenListen(_historyCubit, Stream.fromIterable([_initialState, state]),
          initialState: _initialState);
      await tester.findWidgetOfType(NoResultsView, HistoryScreen());
      when(GetIt.I.get<CoreCubit>().goToScreen())
          .thenAnswer((realInvocation) async {});
      await tester.tap(find.text('Go to the privacy permissions'));
      verify(GetIt.I.get<CoreCubit>().goToScreen()).called(1);
    });

    testWidgets('when the history is not accessible shows no results view',
        (tester) async {
      final dioError = MockDioError();
      when(dioError.message).thenReturn(ApiErrors.historyNotAccessible);
      final state = _initialState.copyWith(
        loading: false,
        error: dioError,
      );
      whenListen(_historyCubit, Stream.fromIterable([_initialState, state]),
          initialState: _initialState);
      await tester.findWidgetOfType(NoResultsView, HistoryScreen());
      when(GetIt.I.get<CoreCubit>().goToScreen())
          .thenAnswer((realInvocation) async {});
      await tester.tap(find.text('Make your first measurement'));
      verify(GetIt.I.get<CoreCubit>().goToScreen()).called(1);
    });

    testWidgets(
        'when there is an error and history is empty shows generic error widget',
        (tester) async {
      final dioError = MockDioError();
      when(dioError.message).thenReturn('Test');
      final state = _initialState.copyWith(
        loading: false,
        error: dioError,
      );
      whenListen(_historyCubit, Stream.fromIterable([_initialState, state]),
          initialState: _initialState);
      await tester.findWidgetOfType(NTErrorWidget, HistoryScreen());
    });

    testWidgets(
        'when net neutrality tests are enabled but there are no tests yet',
        (tester) async {
      final state = _initialState.copyWith(loading: false);
      final nnState = _initialNNState.copyWith(loading: false);
      when(GetIt.I
              .get<SharedPreferencesWrapper>()
              .getBool(StorageKeys.netNeutralityTestsEnabled))
          .thenReturn(true);
      whenListen(_netNeutralityHistoryCubit,
          Stream.fromIterable([_initialNNState, nnState]),
          initialState: _initialNNState);
      whenListen(_historyCubit, Stream.fromIterable([_initialState, state]),
          initialState: _initialState);
      await tester.findWidgetOfType(NoResultsView, HistoryScreen());
      await tester.findWidgetOfType(HistorySpeedView, HistoryScreen());
      var netNeutralityTab = find.text('Net Neutrality');
      expect(netNeutralityTab, findsOneWidget);
      await tester.tap(netNeutralityTab);
      await tester.pumpAndSettle();
      await tester.findWidgetOfType(NoResultsView, HistoryScreen());
      await tester.findWidgetOfType(NetNeutralityView, HistoryScreen());
      await tester.tap(find.text('Make your first measurement'));
      verify(GetIt.I.get<CoreCubit>().goToScreen()).called(1);
    });

    testWidgets('when net neutrality tests are enabled with some tests',
        (tester) async {
      final dioError = MockDioError();
      when(GetIt.I
              .get<SharedPreferencesWrapper>()
              .getBool(StorageKeys.netNeutralityTestsEnabled))
          .thenReturn(true);
      when(dioError.message).thenReturn('Test');
      final state = _initialState.copyWith(loading: false);
      final nnState = _initialNNState.copyWith(
          loading: false, netNeutralityHistory: _nnHistory);
      whenListen(_historyCubit, Stream.fromIterable([_initialState, state]),
          initialState: _initialState);
      whenListen(_netNeutralityHistoryCubit,
          Stream.fromIterable([_initialNNState, nnState]),
          initialState: _initialNNState);
      await tester.findWidgetOfType(NoResultsView, HistoryScreen());
      await tester.findWidgetOfType(HistorySpeedView, HistoryScreen());
      final netNeutralityTab = find.text('Net Neutrality');
      expect(netNeutralityTab, findsOneWidget);
      await tester.findWidgetOfType(
          NetNeutralityView,
          NetNeutralityView(
            testing: true,
          ));
      final netNeutralityHistoryItems =
          find.byType(HistoryNetNeutralityItemWidget);
      expect(netNeutralityHistoryItems, findsNWidgets(2));
      final pieCharts = find.byType(PieChart);
      expect(pieCharts, findsNWidgets(3));
      expect(find.text('WEB'), findsOneWidget);
      expect(find.text('UDP'), findsNothing);
      expect(find.text('TCP'), findsNothing);
      expect(find.text('DNS'), findsOneWidget);
      expect(find.text('TSP'), findsNothing);
      expect(find.text('TCR'), findsNothing);
      expect(find.text('VOP'), findsNothing);
      expect(find.text('UNM'), findsNothing);
      expect(find.textContaining("10.10.2022"), findsOneWidget);
      final measurementDate = find.textContaining("11.10.2022");
      expect(measurementDate, findsOneWidget);
      await tester.tap(measurementDate);
      verify(_netNeutralityCubit.loadResults('openTestUuid2')).called(1);
    });

    testWidgets(
        'when there is an error and history is not empty shows the table',
        (tester) async {
      final dioError = MockDioError();
      when(dioError.message).thenReturn('Test');
      final state = _initialState.copyWith(
        speedHistory: [
          MeasurementHistoryResults([
            MeasurementHistoryResult(
              testUuid: '',
              uploadKbps: 0,
              downloadKbps: 0,
              pingMs: 0,
              measurementDate: '2020-01-01T15:00:00.000Z',
            )
          ])
        ],
        loading: false,
        error: dioError,
        enableSynchronization: true,
      );
      whenListen(_historyCubit, Stream.fromIterable([_initialState, state]),
          initialState: _initialState);
      await tester.findWidgetOfType(HistorySpeedView, HistoryScreen());
      expect(find.byIcon(Icons.devices), findsOneWidget);
    });
  });
}
