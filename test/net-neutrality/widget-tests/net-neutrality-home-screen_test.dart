import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/widgets/error.snackbar.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-error.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/home-info-box.widget.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-home/net-neutrality-home.screen.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';

import '../../di/service-locator.dart';
import '../../measurements/widgets-tests/start-test.widget_test.dart';
import '../unit-tests/net-neutrality-measurement-service_test.mocks.dart';
import 'net-neutrality-result-screen_test.dart';

final NetNeutralityCubit _cubit = MockNetNeutralityCubit();
final NetNeutralityCubit _cubitCalls = MockNetNeutralityCubitCalls();
final MeasurementsBloc _measurementsBloc = MockMeasurementsBloc();
late NetNeutralityState _state;
final Widget _screen = MultiBlocProvider(
  providers: [
    BlocProvider.value(value: _cubit),
    BlocProvider.value(value: _measurementsBloc),
  ],
  child: MediaQuery(
    data: MediaQueryData(),
    child: MaterialApp(
      home: NetNeutralityHomeScreen(),
    ),
  ),
);

void main() {
  setUpAll(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn('en-US');
    final ms = MeasurementsState.init();
    whenListen(_measurementsBloc, Stream.fromIterable([ms]), initialState: ms);
  });

  group('Test start test widget with connection', () {
    setUpAll(() {
      _state = NetNeutralityState(
        interimResults: [],
        historyResults: [],
        connectivity: ConnectivityResult.wifi,
      );
      whenListen(_cubit, Stream.fromIterable([_state]), initialState: _state);
      when(_cubitCalls.init()).thenAnswer((realInvocation) async => null);
      TestingServiceLocator.swapLazySingleton<NetNeutralityCubit>(
          () => _cubitCalls);
    });
    testWidgets('shows start button and lets to run measurement',
        (tester) async {
      await tester.pumpWidget(_screen);
      await tester.pumpAndSettle();
      expect(find.text('Net Neutrality Measurement'), findsOneWidget);
      expect(find.byKey(Key('home-screen-hero')), findsOneWidget);
      expect(find.byType(HomeInfoBox), findsOneWidget);
      when(_cubitCalls.startMeasurement()).thenReturn(null);
      await tester.tap(find.text('Net Neutrality Measurement'));
      verify(_cubitCalls.startMeasurement());
    });

    testWidgets(
        'shows start button and lets to run measurement in PORTRAIT mode',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = Size(1200, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      await tester.pumpWidget(_screen);
      await tester.pumpAndSettle();
      expect(find.text('Net Neutrality Measurement'), findsOneWidget);
      expect(find.byKey(Key('home-screen-hero')), findsOneWidget);
      expect(find.byType(HomeInfoBox), findsOneWidget);
      when(_cubitCalls.startMeasurement()).thenReturn(null);
      await tester.tap(find.text('Net Neutrality Measurement'));
      verify(_cubitCalls.startMeasurement());
    });
  });

  group('Test start test widget without connection', () {
    setUpAll(() {
      _state = NetNeutralityState(
        interimResults: [],
        historyResults: [],
        connectivity: ConnectivityResult.none,
      );
      whenListen(_cubit, Stream.fromIterable([_state]), initialState: _state);
      when(_cubitCalls.init()).thenAnswer((realInvocation) async => null);
      TestingServiceLocator.swapLazySingleton<NetNeutralityCubit>(
          () => _cubitCalls);
    });

    testWidgets('start button is NOT shown', (tester) async {
      await tester.pumpWidget(_screen);
      expect(find.text('Net Neutrality Measurement'), findsNothing);
      expect(find.byKey(Key('home-screen-hero')), findsOneWidget);
      expect(find.byType(HomeInfoBox), findsNothing);
    });

    testWidgets('start button is NOT shown in PORTRAIT mode', (tester) async {
      tester.binding.window.physicalSizeTestValue = Size(1200, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      await tester.pumpWidget(_screen);
      expect(find.text('Net Neutrality Measurement'), findsNothing);
      expect(find.byKey(Key('home-screen-hero')), findsOneWidget);
      expect(find.byType(HomeInfoBox), findsNothing);
    });
  });

  group('Test start test widget with error', () {
    setUpAll(() {
      _state = NetNeutralityState(
        interimResults: [],
        historyResults: [],
        connectivity: ConnectivityResult.wifi,
      );
      when(_cubitCalls.init()).thenAnswer((realInvocation) async => null);
      TestingServiceLocator.swapLazySingleton<NetNeutralityCubit>(
          () => _cubitCalls);
    });

    testWidgets('AlertDialog is shown for a measurement error', (tester) async {
      final error = MeasurementError();
      _setUpError(error);
      await tester.pumpWidget(_screen);
      expect(find.text('Net Neutrality Measurement'), findsOneWidget);
      expect(find.byType(NTErrorSnackbar), findsNothing);
      expect(find.byType(AlertDialog), findsNothing);
      await tester.pump();
      expect(find.text('Net Neutrality Measurement'), findsOneWidget);
      expect(find.byType(NTErrorSnackbar), findsNothing);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(error.toString()), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      expect(find.text('Finish'), findsOneWidget);
      await tester.tap(find.text('Try again'));
      verify(_cubitCalls.restartMeasurement());
      await tester.tap(find.text('Finish'));
      verify(_cubitCalls.stopMeasurement());
    });

    testWidgets('AlertDialog is not shown for a non-measurement error',
        (tester) async {
      final error = Exception('Test error');
      _setUpError(error);
      await tester.pumpWidget(_screen);
      expect(find.text('Net Neutrality Measurement'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
      await tester.pump();
      expect(find.text('Net Neutrality Measurement'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}

_setUpError(Exception error) {
  final errorState = _state.copyWith(error: error);
  whenListen(_cubit, Stream.fromIterable([_state, errorState]),
      initialState: _state);
}
