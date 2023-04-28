import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/settings/models/language.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/languages.screen.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';

import '../../di/service-locator.dart';
import 'settings-screen_test.mocks.dart';

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

final _cubit = MockSettingsCubit();
final _initialState = SettingsState();
final _slovakLanguage = Language(
    name: "Slovak",
    nativeName: "Slovenský jazyk",
    languageCode: "sk",
    countryCode: "sk");
final _defaultLanguage = Language(
    name: "Default",
    nativeName: "Default",
    languageCode: "Default",
    countryCode: "Default");
final _uuid = 'uuid';
final _widgetTree = BlocProvider<SettingsCubit>(
  create: (context) => GetIt.I.get<SettingsCubit>(),
  child: MaterialApp(
    home: LanguagesScreen(),
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
    final dio = GetIt.I.get<Dio>();
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
    when(GetIt.I.get<NavigationService>().goBack()).thenReturn(null);
    whenListen(
        _cubit,
        Stream.fromIterable(
            [_initialState, _initialState.copyWith(clientUuid: _uuid)]),
        initialState: _initialState);
    when(dio.get('/ui-translations', queryParameters: {
      'locale.iso': "sr-Latn",
      '_limit': -1,
      'app_type': 'mobile'
    })).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/ui-translations'),
            statusCode: 200,
            data: {
              'Speed': 'Test',
              'Map': 'Kart',
            }));
    await dotenv.load(fileName: '.env');
  });

  group('Language select screen', () {
    testWidgets('test correct title in the app bar', (tester) async {
      await tester.pumpWidget(_widgetTree);
      final cubit = MockSettingsCubitCalls();
      TestingServiceLocator.swapLazySingleton<SettingsCubit>(() => cubit);
      expect(find.byType(NTAppBar), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      verify(GetIt.I.get<NavigationService>().goBack()).called(1);
    });

    testWidgets('shows list of languages', (tester) async {
      whenListen(
          _cubit,
          Stream.fromIterable([
            _initialState,
            _initialState.copyWith(
                loopModeFeatureEnabled: true,
                loopModeEnabled: true,
                clientUuid: null,
                languageSwitchEnabled: true,
                supportedLanguages: [
                  _defaultLanguage,
                  _slovakLanguage,
                  Language(
                      name: "English",
                      nativeName: "English",
                      languageCode: "en",
                      countryCode: "us"),
                  Language(
                      name: "Serbian",
                      nativeName: "Srpski jezik",
                      languageCode: "sr",
                      scriptCode: "Latn",
                      countryCode: "rs"),
                ],
                selectedLanguage: null)
          ]),
          initialState: _initialState);
      await tester.pumpWidget(_widgetTree);
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Default'), findsOneWidget);
      expect(find.text('Slovenský jazyk'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Srpski jezik'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      final cubit = MockSettingsCubitCalls();
      TestingServiceLocator.swapLazySingleton<SettingsCubit>(() => cubit);
    });

    testWidgets('Selecting default language', (tester) async {
      whenListen(
          _cubit,
          Stream.fromIterable([
            _initialState,
            _initialState.copyWith(
                loopModeFeatureEnabled: true,
                loopModeEnabled: true,
                clientUuid: null,
                languageSwitchEnabled: true,
                supportedLanguages: [
                  Language(
                      name: "Default",
                      nativeName: "Default",
                      languageCode: "Default",
                      countryCode: "Default"),
                  _slovakLanguage,
                  Language(
                      name: "English",
                      nativeName: "English",
                      languageCode: "en",
                      countryCode: "us"),
                  Language(
                      name: "Serbian",
                      nativeName: "Srpski jezik",
                      languageCode: "sr",
                      scriptCode: "Latn",
                      countryCode: "rs"),
                ],
                selectedLanguage: null)
          ]),
          initialState: _initialState);
      await tester.pumpWidget(_widgetTree);
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Default'), findsOneWidget);
      expect(find.text('Slovenský jazyk'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Srpski jezik'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      final cubit = MockSettingsCubitCalls();
      TestingServiceLocator.swapLazySingleton<SettingsCubit>(() => cubit);
      await tester.tap(find.text('Default'));
      verify(cubit.setLanguage(_defaultLanguage)).called(1);
      verify(GetIt.I.get<NavigationService>().goBack()).called(1);
    });

    testWidgets('selecting some language', (tester) async {
      whenListen(
          _cubit,
          Stream.fromIterable([
            _initialState,
            _initialState.copyWith(
                loopModeFeatureEnabled: true,
                loopModeEnabled: true,
                clientUuid: null,
                languageSwitchEnabled: true,
                supportedLanguages: [
                  Language(
                      name: "Default",
                      nativeName: "Default",
                      languageCode: "Default",
                      countryCode: "Default"),
                  _slovakLanguage,
                  Language(
                      name: "English",
                      nativeName: "English",
                      languageCode: "en",
                      countryCode: "us"),
                  Language(
                      name: "Serbian",
                      nativeName: "Srpski jezik",
                      languageCode: "sr",
                      scriptCode: "Latn",
                      countryCode: "rs"),
                ],
                selectedLanguage: null)
          ]),
          initialState: _initialState);
      await tester.pumpWidget(_widgetTree);
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Default'), findsOneWidget);
      expect(find.text('Slovenský jazyk'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Srpski jezik'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      final cubit = MockSettingsCubitCalls();
      TestingServiceLocator.swapLazySingleton<SettingsCubit>(() => cubit);
      await tester.tap(find.text('Slovenský jazyk'));
      verify(cubit.setLanguage(_slovakLanguage)).called(1);
      verify(GetIt.I.get<NavigationService>().goBack()).called(1);
    });
  });
}
