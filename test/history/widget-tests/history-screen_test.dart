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
  findWidgetOfType(Type type) async {
    HistoryScreen widget = HistoryScreen();
    await this.pumpWidget(BlocProvider<HistoryCubit>(
      create: (context) => historyCubit,
      child: MaterialApp(
        home: widget,
      ),
    ));
    await this.pumpAndSettle();
    final errorWidget = find.byType(type);
    expect(errorWidget, findsOneWidget);
  }
}

late final HistoryCubit historyCubit;
late final NetNeutralityCubit netNeutralityCubit;
final initialState =
    HistoryState(speedHistory: [], netNeutralityHistory: [], loading: true);
final String _selectedLocaleTag = 'sr-Latn-rs';

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
    historyCubit = GetIt.I.get<HistoryCubit>();
    netNeutralityCubit = GetIt.I.get<NetNeutralityCubit>();
    TestingServiceLocator.swapLazySingleton<NetNeutralityCubit>(
        () => netNeutralityCubit);
  });

  group('HistoryScreen', () {
    testWidgets('when the history is not enabled shows no results view',
        (tester) async {
      final state =
          initialState.copyWith(loading: false, isHistoryEnabled: false);
      whenListen(historyCubit, Stream.fromIterable([initialState, state]),
          initialState: initialState);
      await tester.findWidgetOfType(NoResultsView);
      when(GetIt.I.get<CoreCubit>().goToScreen())
          .thenAnswer((realInvocation) async {});
      await tester.tap(find.text('Go to the privacy permissions'));
      verify(GetIt.I.get<CoreCubit>().goToScreen()).called(1);
    });

    testWidgets('when the history is not accessible shows no results view',
        (tester) async {
      final dioError = MockDioError();
      when(dioError.message).thenReturn(ApiErrors.historyNotAccessible);
      final state = initialState.copyWith(
        loading: false,
        error: dioError,
      );
      whenListen(historyCubit, Stream.fromIterable([initialState, state]),
          initialState: initialState);
      await tester.findWidgetOfType(NoResultsView);
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
      final state = initialState.copyWith(
        loading: false,
        error: dioError,
      );
      whenListen(historyCubit, Stream.fromIterable([initialState, state]),
          initialState: initialState);
      await tester.findWidgetOfType(NTErrorWidget);
    });

    testWidgets(
        'when net neutrality tests are enabled but there are no tests yet',
        (tester) async {
      final dioError = MockDioError();
      when(GetIt.I
              .get<SharedPreferencesWrapper>()
              .getBool(StorageKeys.netNeutralityTestsEnabled))
          .thenReturn(true);
      when(dioError.message).thenReturn('Test');
      final state = initialState.copyWith(loading: false);
      whenListen(historyCubit, Stream.fromIterable([initialState, state]),
          initialState: initialState);
      await tester.findWidgetOfType(NoResultsView);
      await tester.findWidgetOfType(HistorySpeedView);
      var netNeutralityTab = find.text('Net Neutrality');
      expect(netNeutralityTab, findsOneWidget);
      await tester.tap(netNeutralityTab);
      await tester.pumpAndSettle();
      await tester.findWidgetOfType(NoResultsView);
      await tester.findWidgetOfType(NetNeutralityView);
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
      final state =
          initialState.copyWith(loading: false, netNeutralityHistory: [
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
      ]);
      whenListen(historyCubit, Stream.fromIterable([initialState, state]),
          initialState: initialState);
      await tester.findWidgetOfType(NoResultsView);
      await tester.findWidgetOfType(HistorySpeedView);
      final netNeutralityTab = find.text('Net Neutrality');
      expect(netNeutralityTab, findsOneWidget);
      await tester.tap(netNeutralityTab);
      await tester.pumpAndSettle();
      await tester.findWidgetOfType(NetNeutralityView);
      final deviceTexts = find.text('device');
      expect(deviceTexts, findsNWidgets(2));
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
      verify(netNeutralityCubit.loadResults('openTestUuid2')).called(1);
    });

    testWidgets(
        'when there is an error and history is not empty shows the table',
        (tester) async {
      final dioError = MockDioError();
      when(dioError.message).thenReturn('Test');
      final state = initialState.copyWith(
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
      whenListen(historyCubit, Stream.fromIterable([initialState, state]),
          initialState: initialState);
      await tester.findWidgetOfType(HistorySpeedView);
      expect(find.byIcon(Icons.devices), findsOneWidget);
    });
  });
}
