import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:nt_flutter_standalone/modules/settings/models/language.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/languages.screen.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/settings.screen.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';
import 'package:sprintf/sprintf.dart';

import '../../di/service-locator.dart';
import 'settings-screen_test.mocks.dart';

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

final _cubit = MockSettingsCubit();
final _initialState = SettingsState();
final _uuid = 'uuid';
final _widgetTree = BlocProvider<SettingsCubit>(
  create: (context) => GetIt.I.get<SettingsCubit>(),
  child: MaterialApp(
    home: SettingsScreen(),
  ),
);
final String _selectedLocaleTag = 'sr-Latn-rs';

@GenerateMocks([], customMocks: [
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
    whenListen(
        _cubit,
        Stream.fromIterable(
            [_initialState, _initialState.copyWith(clientUuid: _uuid)]),
        initialState: _initialState);
    await dotenv.load(fileName: '.env');
  });

  group('Settings screen', () {
    testWidgets('shows correct title in the app bar', (tester) async {
      await tester.pumpWidget(_widgetTree);
      final cubit = MockSettingsCubitCalls();
      TestingServiceLocator.swapLazySingleton<SettingsCubit>(() => cubit);
      expect(find.byType(NTAppBar), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('shows information section', (tester) async {
      await tester.pumpWidget(_widgetTree);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Information'.toUpperCase()), findsOneWidget);
      expect(find.text('About ${Environment.appName}'), findsOneWidget);
      expect(find.text('Terms of service'), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
      final cubit = MockSettingsCubitCalls();
      TestingServiceLocator.swapLazySingleton<SettingsCubit>(() => cubit);
      await tester.tap(find.text('About ${Environment.appName}'));
      verify(cubit.getPage(any, any)).called(1);
      await tester.tap(find.text('Terms of service'));
      verify(cubit.getPage(any, any)).called(1);
    });

    testWidgets(
        'shows language section with default and opening language settings',
        (tester) async {
      whenListen(
          _cubit,
          Stream.fromIterable([
            _initialState,
            _initialState.copyWith(
                loopModeFeatureEnabled: true,
                loopModeEnabled: true,
                clientUuid: null,
                languageSwitchEnabled: true,
                supportedLanguages: [],
                selectedLanguage: null)
          ]),
          initialState: _initialState);
      await tester.pumpWidget(_widgetTree);
      await tester.pumpAndSettle();
      when(GetIt.I.get<NavigationService>().pushNamed(LanguagesScreen.route))
          .thenReturn(null);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Language'.toUpperCase()), findsOneWidget);
      expect(find.text('Selected language'), findsOneWidget);
      expect(find.text('Default'), findsOneWidget);
      expect(find.text('Information'.toUpperCase()), findsOneWidget);
      expect(find.text('About ${Environment.appName}'), findsOneWidget);
      expect(find.text('Terms of service'), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
      final cubit = MockSettingsCubitCalls();
      TestingServiceLocator.swapLazySingleton<SettingsCubit>(() => cubit);
      await tester.tap(find.text('Selected language'));
      verify(GetIt.I.get<NavigationService>().pushNamed(LanguagesScreen.route))
          .called(1);
    });

    testWidgets('shows language section with some language selected',
        (tester) async {
      whenListen(
          _cubit,
          Stream.fromIterable([
            _initialState,
            _initialState.copyWith(
                loopModeFeatureEnabled: true,
                loopModeEnabled: true,
                clientUuid: null,
                languageSwitchEnabled: true,
                supportedLanguages: [],
                selectedLanguage: Language(
                    name: "name",
                    nativeName: "nativeName",
                    languageCode: "lc",
                    scriptCode: "sc",
                    countryCode: "cc"))
          ]),
          initialState: _initialState);
      await tester.pumpWidget(_widgetTree);
      await tester.pumpAndSettle();
      when(GetIt.I.get<NavigationService>().pushNamed(LanguagesScreen.route))
          .thenReturn(null);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Language'.toUpperCase()), findsOneWidget);
      expect(find.text('Selected language'), findsOneWidget);
      expect(find.text('nativeName'), findsOneWidget);
      expect(find.text('Information'.toUpperCase()), findsOneWidget);
      expect(find.text('About ${Environment.appName}'), findsOneWidget);
      expect(find.text('Terms of service'), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
    });

    // TODO: for general section
    // testWidgets('shows general section', (tester) async {
    //   await tester.pumpWidget(_widgetTree);
    //   expect(find.text('General'.toUpperCase()), findsOneWidget);
    //   expect(find.text('Net Neutrality Measurements'), findsOneWidget);
    //   expect(find.text('On New Network'), findsOneWidget);
    // });

    testWidgets('shows loop mode disabled section', (tester) async {
      whenListen(
          _cubit,
          Stream.fromIterable([
            _initialState,
            _initialState.copyWith(
                loopModeFeatureEnabled: true,
                loopModeEnabled: false,
                clientUuid: null)
          ]),
          initialState: _initialState);
      await tester.pumpWidget(_widgetTree);
      await tester.pumpAndSettle();
      expect(find.text('Loop mode'.toUpperCase()), findsOneWidget);
      expect(find.text('Loop mode'), findsOneWidget);
      expect(find.text('Number of measurements'), findsNothing);
      expect(find.text('Distance (meters)'), findsNothing);
      expect(find.text('Waiting time (minutes)'), findsNothing);
      expect(
          find.text(sprintf('Between %d min - %d mins', [
            LoopMode.loopModeWaitingTimeMinutesMin,
            LoopMode.loopModeWaitingTimeMinutesMax
          ])),
          findsNothing);
      expect(find.text('Include Net Neutrality'), findsNothing);
      expect(find.text('10'), findsNothing);
      expect(find.text('250'), findsNothing);
      expect(find.text('5'), findsNothing);
    });

    testWidgets('shows loop mode enabled section', (tester) async {
      whenListen(
          _cubit,
          Stream.fromIterable([
            _initialState,
            _initialState.copyWith(
                loopModeFeatureEnabled: true,
                loopModeEnabled: true,
                clientUuid: null)
          ]),
          initialState: _initialState);
      await tester.pumpWidget(_widgetTree);
      await tester.pumpAndSettle();
      expect(find.text('Loop mode'.toUpperCase()), findsOneWidget);
      expect(find.text('Loop mode'), findsOneWidget);
      expect(find.text('Number of measurements'), findsOneWidget);
      expect(find.text('Distance (meters)'), findsOneWidget);
      expect(find.text('Waiting time (minutes)'), findsOneWidget);
      expect(
          find.text(sprintf('Between %d min - %d mins', [
            LoopMode.loopModeWaitingTimeMinutesMin,
            LoopMode.loopModeWaitingTimeMinutesMax
          ])),
          findsOneWidget);
      // todo: removed until we do not have implementation for net neutrality tests
      // expect(find.text('Include Net Neutrality'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('250'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('shows loop mode disabled in CMS', (tester) async {
      whenListen(
          _cubit,
          Stream.fromIterable([
            _initialState,
            _initialState.copyWith(
                loopModeFeatureEnabled: false,
                loopModeEnabled: true,
                clientUuid: null)
          ]),
          initialState: _initialState);
      await tester.pumpWidget(_widgetTree);
      await tester.pumpAndSettle();
      expect(find.text('Loop mode'.toUpperCase()), findsNothing);
      expect(find.text('Loop mode'), findsNothing);
      expect(find.text('Number of measurements'), findsNothing);
      expect(find.text('Distance (meters)'), findsNothing);
      expect(find.text('Waiting time (minutes)'), findsNothing);
      expect(
          find.text(sprintf('Between %d min - %d mins', [
            LoopMode.loopModeWaitingTimeMinutesMin,
            LoopMode.loopModeWaitingTimeMinutesMax
          ])),
          findsNothing);
      expect(find.text('Include Net Neutrality'), findsNothing);
      expect(find.text('10'), findsNothing);
      expect(find.text('250'), findsNothing);
      expect(find.text('5'), findsNothing);
    });

    testWidgets('shows privacy section', (tester) async {
      await tester.pumpWidget(_widgetTree);
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Privacy'.toUpperCase()), findsOneWidget);
      expect(find.text('Client UUID'), findsOneWidget);
      expect(find.text(_uuid), findsOneWidget);
      expect(find.text('Persistent client UUID', skipOffstage: false),
          findsOneWidget);
      final switchFinder =
          find.byKey(Key('persistentClientSwitch'), skipOffstage: false);
      await tester.ensureVisible(switchFinder);
      await tester.pumpAndSettle();
      expect(switchFinder, findsOneWidget);
      expect((switchFinder.evaluate().single.widget as CupertinoSwitch).value,
          true);
      expect(find.text('Privacy policy', skipOffstage: false), findsOneWidget);
      final cubit = MockSettingsCubitCalls();
      TestingServiceLocator.swapLazySingleton<SettingsCubit>(() => cubit);
      final privacyPolicy = find.text('Privacy policy', skipOffstage: false);
      await tester.ensureVisible(privacyPolicy);
      await tester.pumpAndSettle();
      await tester.tap(privacyPolicy);
      verify(cubit.getPage(any, any)).called(1);
    });

    testWidgets('shows privacy section without client uuid', (tester) async {
      whenListen(
          _cubit,
          Stream.fromIterable([
            _initialState,
            _initialState.copyWith(
                persistentClientUuidEnabled: false, clientUuid: null)
          ]),
          initialState: _initialState);
      await tester.pumpWidget(_widgetTree);
      await tester.pumpAndSettle();
      expect(find.text(_uuid), findsNothing);
      final switchFinder = find.byType(CupertinoSwitch);
      expect(switchFinder, findsOneWidget);
      expect((switchFinder.evaluate().single.widget as CupertinoSwitch).value,
          false);
    });
  });
}
