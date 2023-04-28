import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/loop-mode.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/loop-mode-agreement.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/loop-mode-settings.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';
import 'package:sprintf/sprintf.dart';

import '../../di/service-locator.dart';
import 'loop-mode-agreement_test.mocks.dart';

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

final _cubit = MockSettingsCubit();
final _initialState = SettingsState();
final _uuid = 'uuid';
final _mockObserver = MockNavigatorObserver();
final String _selectedLocaleTag = 'sr-Latn-rs';

final _widgetTree = BlocProvider<SettingsCubit>(
  create: (context) => GetIt.I.get<SettingsCubit>(),
  child: MaterialApp(
      home: LoopModeAgreementScreen(), navigatorObservers: [_mockObserver]),
);

@GenerateMocks([], customMocks: [
  MockSpec<RouteObserver>(
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<NavigatorObserver>(
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<SettingsCubit>(
    as: #MockSettingsCubitCalls,
    onMissingStub: OnMissingStub.returnDefault,
  )
])
void main() {
  setUp(() async {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    TestingServiceLocator.swapLazySingleton<SettingsCubit>(() => _cubit);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
    when(GetIt.I
            .get<NavigationService>()
            .pushNamed(LoopModeSettingsScreen.route))
        .thenAnswer((realInvocation) async => null);
    whenListen(
        _cubit,
        Stream.fromIterable(
            [_initialState, _initialState.copyWith(clientUuid: _uuid)]),
        initialState: _initialState);
    await dotenv.load(fileName: '.env');
  });

  group('Loop mode agreement screen', () {
    testWidgets('shows correct title in the app bar', (tester) async {
      await tester.pumpWidget(_widgetTree);
      expect(find.byType(NTAppBar), findsOneWidget);
      expect(find.text('Loop mode'), findsOneWidget);
    });

    testWidgets('shows correct body section', (tester) async {
      await tester.pumpWidget(_widgetTree);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline, skipOffstage: false),
          findsNWidgets(6));
      expect(find.text('Activation & Privacy'), findsOneWidget);
      expect(
          find.text(
              'The loop mode allows the automatic repetition of ${Environment.appName}.'),
          findsOneWidget);
      expect(
          find.text(
              'The first test will start immediately after the loop mode has been initiated.'),
          findsOneWidget);
      expect(
          find.text(sprintf(
              'Further tests will be started after either the waiting time (default %d min) has elapsed or the configured distance (default %d meters) has been covered.',
              [
                LoopMode.loopModeDefaultWaitingTimeMinutes,
                LoopMode.loopModeDefaultDistanceMeters
              ])),
          findsOneWidget);
      expect(
          find.text(
              'Tests will be performed until the configured number of tests (default 10 tests) has been reached.'),
          findsOneWidget);
      expect(
          find.text('The loop mode is automatically terminated after 2 days.'),
          findsOneWidget);
      expect(
          find.text('The loop mode can be stopped at any time.',
              skipOffstage: false),
          findsOneWidget);
      expect(
          find.text('These values can be changed under settings.',
              skipOffstage: false),
          findsOneWidget);
      expect(find.text('Data usage'.toUpperCase(), skipOffstage: false),
          findsOneWidget);
      expect(
          find.text(
              'data usage explanation',
              skipOffstage: false),
          findsOneWidget);
      await tester.drag(find.byType(ListView), Offset(0.0, -500));
      await tester.pump();
      final batteryPower = find.text('Battery power'.toUpperCase());
      final batteryText = find.text(
          'battery power explanation',
          skipOffstage: false);
      expect(batteryPower, findsOneWidget);
      expect(batteryText, findsOneWidget);
      expect(find.text('Agree', skipOffstage: false), findsOneWidget);
      expect(find.text('Decline', skipOffstage: false), findsOneWidget);
      final cubit = MockSettingsCubitCalls();
      TestingServiceLocator.swapLazySingleton<SettingsCubit>(() => cubit);
      // await tester.tap(find.text('Agree'));
      // verify(cubit.onLoopModeEnabledChange(true)).called(1);
      await tester.tap(find.text('Decline'));
      verifyNever(cubit.onLoopModeEnabledChange(true));
    });
  });
}
