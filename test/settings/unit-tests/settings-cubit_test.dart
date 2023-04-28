import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/loop-mode.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/services/localization.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/firebase-analytics.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/settings/models/language.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/loop-mode-agreement.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';
import '../../measurements/widgets-tests/start-test.widget_test.dart';

late SettingsCubit _cubit;
late SharedPreferencesWrapper _prefs;
late FirebaseAnalyticsWrapper _analytics;
final DioError _dioError = MockDioError();
final _route = '***REMOVED***';
final _uuid = 'uuid';
final _newUuid = 'newUuid';
final _version = '4.0.0';
final _loopModeMeasurementCountValid = 150;
final _loopModeWaitingTimeValid = 1440;
final _loopModeDistanceValid = 1000;
final _serbianLatinLocaleTag = "sr-Latn-RS";
final _germanLocaleTag = "de-DE";

final supportedLanguages = [
  Language(
      name: 'Default',
      nativeName: 'Default',
      languageCode: 'Default',
      countryCode: 'Default'),
  Language(
      name: 'English',
      nativeName: 'English',
      languageCode: 'en',
      countryCode: 'US'),
  Language(
      name: 'German',
      nativeName: 'Deutsch',
      languageCode: 'de',
      countryCode: 'DE'),
  Language(
      name: 'Serbian Latin',
      nativeName: 'Srpski jezik',
      languageCode: 'sr',
      scriptCode: 'Latn',
      countryCode: 'RS'),
];

class MockFirebase extends Mock implements Firebase {}

@GenerateMocks([
  FirebaseAnalyticsWrapper
], customMocks: [
  MockSpec<NavigatorObserver>(
    onMissingStub: OnMissingStub.returnDefault,
  ),
])
void main() {
  setUp(() async {
    setupFirebaseAuthMocks();
    await Firebase.initializeApp();
    TestingServiceLocator.registerInstances();
    _cubit = SettingsCubit();
    _setUpStubs();
  });

  group('Settings cubit', () {
    blocTest<SettingsCubit, SettingsState>(
      'initializes state',
      build: () => _cubit,
      act: (bloc) => bloc.init(),
      expect: () => [
        SettingsState().copyWith(
            clientUuid: _uuid,
            persistentClientUuidEnabled: true,
            analyticsEnabled: true,
            appVersion: _version,
            loopModeEnabled: false,
            loopModeDistanceMetersSet: LoopMode.loopModeDefaultDistanceMeters,
            loopModeWaitingTimeMinSet:
                LoopMode.loopModeDefaultWaitingTimeMinutes,
            loopModeMeasurementCountSet:
                LoopMode.loopModeDefaultMeasurementCount,
            loopModeNetNeutralityEnabled: false,
            supportedLanguages: supportedLanguages,
            netNeutralityMeasurement: NetNeutralityMeasurement.ON_NEW_NETWORK)
      ],
    );
    blocTest<SettingsCubit, SettingsState>(
      'initializes state when no client uuid in prefs',
      build: () => _cubit,
      act: (bloc) {
        when(_prefs.clientUuid).thenAnswer((_) async => null);
        return bloc.init();
      },
      expect: () => [
        SettingsState().copyWith(
            clientUuid: _newUuid,
            persistentClientUuidEnabled: true,
            analyticsEnabled: true,
            appVersion: _version,
            loopModeEnabled: false,
            loopModeDistanceMetersSet: LoopMode.loopModeDefaultDistanceMeters,
            loopModeWaitingTimeMinSet:
                LoopMode.loopModeDefaultWaitingTimeMinutes,
            loopModeMeasurementCountSet:
                LoopMode.loopModeDefaultMeasurementCount,
            loopModeNetNeutralityEnabled: false,
            supportedLanguages: supportedLanguages,
            netNeutralityMeasurement: NetNeutralityMeasurement.ON_NEW_NETWORK)
      ],
    );
    blocTest<SettingsCubit, SettingsState>(
      'gets static pages',
      build: () => _cubit,
      act: (bloc) {
        when(GetIt.I.get<CMSService>().getPage(_route, errorHandler: _cubit))
            .thenAnswer((_) async => 'test');
        return bloc.getPage(_route, '');
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _cubit.state.clientUuid,
          loading: true,
        ),
        SettingsState().copyWith(
          clientUuid: _cubit.state.clientUuid,
          staticPageContent: 'test',
        ),
      ],
    );
    blocTest<SettingsCubit, SettingsState>(
      'handles errors when getting page',
      build: () => _cubit,
      act: (bloc) {
        when(GetIt.I.get<CMSService>().getPage(_route, errorHandler: _cubit))
            .thenAnswer((_) async {
          _cubit.process(_dioError);
          return null;
        });
        return bloc.getPage(_route, '');
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _cubit.state.clientUuid,
          loading: true,
        ),
        SettingsState().copyWith(
          clientUuid: _cubit.state.clientUuid,
          error: _dioError,
        ),
      ],
    );
    blocTest<SettingsCubit, SettingsState>(
      'stores persistent client uuid value and removes client uuid if needed',
      build: () => _cubit,
      act: (bloc) => bloc.onPersistentClientUuidChange(false),
      expect: () => [
        SettingsState().copyWith(
            clientUuid: null,
            persistentClientUuidEnabled: false,
            analyticsEnabled: false)
      ],
      verify: (bloc) {
        verify(_prefs.removeClientUuid());
        verify(_prefs.setBool(StorageKeys.persistentClientUuidEnabled, false));
      },
    );
    blocTest<SettingsCubit, SettingsState>(
      'stores persistent client uuid value and client uuid if needed',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        return bloc.onPersistentClientUuidChange(true);
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          persistentClientUuidEnabled: true,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
        )
      ],
      verify: (bloc) {
        verify(_prefs.setString(StorageKeys.clientUuid, _uuid));
        verify(_prefs.setBool(StorageKeys.persistentClientUuidEnabled, true));
      },
    );
    blocTest<SettingsCubit, SettingsState>(
      'load languages and set selected language with language script',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        bloc.setLanguage(supportedLanguages[3]);
        bloc.setLanguage(supportedLanguages[0]);
        bloc.setLanguage(supportedLanguages[2]);
        return;
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          persistentClientUuidEnabled: true,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          persistentClientUuidEnabled: true,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
          selectedLanguage: supportedLanguages[3],
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          persistentClientUuidEnabled: true,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
          selectedLanguage: supportedLanguages[0],
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          persistentClientUuidEnabled: true,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
          selectedLanguage: supportedLanguages[2],
        )
      ],
      verify: (bloc) {
        verify(_prefs.setString(StorageKeys.selectedLocaleTag, "sr-Latn-RS"));
        verify(_prefs.remove(StorageKeys.selectedLocaleTag));
        verify(_prefs.setString(StorageKeys.selectedLocaleTag, "de-DE"));
      },
    );
  });

  group('Loop mode settings cubit', () {
    blocTest<SettingsCubit, SettingsState>(
      'stores number of measurements with default, null and changed value',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        bloc.onLoopModeMeasurementCountChange(null);
        return bloc
            .onLoopModeMeasurementCountChange(_loopModeMeasurementCountValid);
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          loopModeMeasurementCountSet: LoopMode.loopModeDefaultMeasurementCount,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          loopModeMeasurementCountSet: _loopModeMeasurementCountValid,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
        )
      ],
      verify: (bloc) {
        verify(_prefs.setInt(StorageKeys.loopModeMeasurementCountSet,
            _loopModeMeasurementCountValid));
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'stores waiting time default, null and changed value',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        bloc.onLoopModeWaitingTimeChange(null);
        return bloc.onLoopModeWaitingTimeChange(_loopModeWaitingTimeValid);
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          loopModeWaitingTimeMinSet: LoopMode.loopModeDefaultWaitingTimeMinutes,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          loopModeWaitingTimeMinSet: _loopModeWaitingTimeValid,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
        )
      ],
      verify: (bloc) {
        verify(_prefs.setInt(StorageKeys.loopModeWaitingTimeMinutesSet,
            _loopModeWaitingTimeValid));
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'stores distance default, null and changed value',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        bloc.onLoopModeDistanceMetersChange(null);
        return bloc.onLoopModeDistanceMetersChange(_loopModeDistanceValid);
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          loopModeDistanceMetersSet: LoopMode.loopModeDefaultDistanceMeters,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          loopModeDistanceMetersSet: _loopModeDistanceValid,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
        )
      ],
      verify: (bloc) {
        verify(_prefs.setInt(
            StorageKeys.loopModeDistanceMetersSet, _loopModeDistanceValid));
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'stores distance default, null and changed value',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        bloc.onLoopModeDistanceMetersChange(null);
        return bloc.onLoopModeDistanceMetersChange(_loopModeDistanceValid);
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          loopModeDistanceMetersSet: LoopMode.loopModeDefaultDistanceMeters,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          loopModeDistanceMetersSet: _loopModeDistanceValid,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
        )
      ],
      verify: (bloc) {
        verify(_prefs.setInt(
            StorageKeys.loopModeDistanceMetersSet, _loopModeDistanceValid));
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'validation of loop mode count',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        bloc.onValidationFailed(LoopModeCheckedFieldType.LOOP_MODE_COUNT);
        return bloc.onValidationSucceeded(
            LoopModeCheckedFieldType.LOOP_MODE_COUNT,
            _loopModeMeasurementCountValid);
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopMeasurementCountSetError: false,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopMeasurementCountSetError: true,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
        ),
        SettingsState().copyWith(
            clientUuid: _uuid,
            loopMeasurementCountSetError: false,
            analyticsEnabled: true,
            appVersion: _version,
            supportedLanguages: supportedLanguages,
            loopModeMeasurementCountSet: _loopModeMeasurementCountValid)
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'validation of loop mode waiting time',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        bloc.onValidationFailed(
            LoopModeCheckedFieldType.LOOP_MODE_WAITING_TIME);
        return bloc.onValidationSucceeded(
            LoopModeCheckedFieldType.LOOP_MODE_WAITING_TIME,
            _loopModeWaitingTimeValid);
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopMeasurementWaitingTimeSetError: false,
          supportedLanguages: supportedLanguages,
          appVersion: _version,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          supportedLanguages: supportedLanguages,
          loopMeasurementWaitingTimeSetError: true,
          appVersion: _version,
        ),
        SettingsState().copyWith(
            clientUuid: _uuid,
            loopMeasurementWaitingTimeSetError: false,
            analyticsEnabled: true,
            appVersion: _version,
            supportedLanguages: supportedLanguages,
            loopModeWaitingTimeMinSet: _loopModeWaitingTimeValid)
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'validation of loop mode distance time',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        bloc.onValidationFailed(LoopModeCheckedFieldType.LOOP_MODE_DISTANCE);
        return bloc.onValidationSucceeded(
            LoopModeCheckedFieldType.LOOP_MODE_DISTANCE,
            _loopModeDistanceValid);
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopMeasurementDistanceSetError: false,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopMeasurementDistanceSetError: true,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          loopMeasurementDistanceSetError: false,
          analyticsEnabled: true,
          appVersion: _version,
          loopModeDistanceMetersSet: _loopModeDistanceValid,
          supportedLanguages: supportedLanguages,
        )
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'change of loop mode neutrality settings',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        bloc.onLoopModeNetNeutralityChange(true);
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopModeNetNeutralityEnabled: false,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopModeNetNeutralityEnabled: true,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
      ],
      verify: (bloc) {
        verify(_prefs.setBool(StorageKeys.loopModeNetNeutralityEnabled, true));
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'change of loop mode enabled settings',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        bloc.onLoopModeEnabledChange(true);
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopModeEnabled: false,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopModeEnabled: true,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
      ],
      verify: (bloc) {
        verify(_prefs.setBool(StorageKeys.loopModeEnabled, true));
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'on clear UI errors for loop mode settings',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        bloc.onValidationFailed(LoopModeCheckedFieldType.LOOP_MODE_COUNT);
        bloc.onValidationFailed(LoopModeCheckedFieldType.LOOP_MODE_DISTANCE);
        bloc.onValidationFailed(
            LoopModeCheckedFieldType.LOOP_MODE_WAITING_TIME);
        bloc.clearUiErrors();
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopMeasurementCountSetError: true,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopMeasurementDistanceSetError: true,
          loopMeasurementCountSetError: true,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopMeasurementWaitingTimeSetError: true,
          loopMeasurementDistanceSetError: true,
          loopMeasurementCountSetError: true,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopMeasurementWaitingTimeSetError: false,
          loopMeasurementDistanceSetError: false,
          loopMeasurementCountSetError: false,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'open loop mode agreement screen',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        bloc.openLoopModeAgreement();
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          loopModeEnabled: false,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
      ],
      verify: (bloc) {
        verify(GetIt.I
                .get<NavigationService>()
                .pushNamed(LoopModeAgreementScreen.route))
            .called(1);
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'on analytics changed',
      build: () => _cubit,
      act: (bloc) async {
        await bloc.init();
        bloc.onAnalyticsChange(false);
        bloc.onAnalyticsChange(true);
      },
      expect: () => [
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: false,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
        SettingsState().copyWith(
          clientUuid: _uuid,
          analyticsEnabled: true,
          appVersion: _version,
          supportedLanguages: supportedLanguages,
        ),
      ],
      verify: (bloc) {
        verify(_prefs.setBool(StorageKeys.analyticsEnabled, false));
        verify(_prefs.setBool(StorageKeys.analyticsEnabled, true));
      },
    );
  });
}

_setUpStubs() {
  PackageInfo.setMockInitialValues(
    appName: '',
    packageName: '',
    version: _version,
    buildNumber: '',
    buildSignature: '',
  );
  _prefs = GetIt.I.get<SharedPreferencesWrapper>();
  _analytics = GetIt.I.get<FirebaseAnalyticsWrapper>();
  when(_analytics.setAnalyticsEnabled(true)).thenAnswer((_) => (null));
  when(_analytics.setAnalyticsEnabled(false)).thenAnswer((_) => (null));
  when(_prefs.clientUuid).thenAnswer((_) async => _uuid);
  when(_prefs.getBool(StorageKeys.persistentClientUuidEnabled))
      .thenReturn(true);
  when(_prefs.getBool(StorageKeys.analyticsEnabled)).thenReturn(true);
  when(_prefs.setString(StorageKeys.clientUuid, _uuid))
      .thenAnswer((_) async => true);
  when(_prefs.setBool(StorageKeys.persistentClientUuidEnabled, false))
      .thenAnswer((_) async => true);
  when(_prefs.setBool(StorageKeys.persistentClientUuidEnabled, true))
      .thenAnswer((_) async => true);
  when(_prefs.setInt(StorageKeys.loopModeMeasurementCountSet,
          _loopModeMeasurementCountValid))
      .thenAnswer((_) async => _loopModeMeasurementCountValid);
  when(_prefs.setBool(StorageKeys.loopModeFeatureEnabled, false))
      .thenAnswer((_) async => true);
  when(_prefs.setInt(
          StorageKeys.loopModeWaitingTimeMinutesSet, _loopModeWaitingTimeValid))
      .thenAnswer((_) async => _loopModeWaitingTimeValid);
  when(_prefs.setInt(
          StorageKeys.loopModeDistanceMetersSet, _loopModeDistanceValid))
      .thenAnswer((_) async => _loopModeDistanceValid);
  when(_prefs.setBool(StorageKeys.loopModeNetNeutralityEnabled, true))
      .thenAnswer((_) async => true);
  when(_prefs.removeClientUuid()).thenAnswer((_) async => true);
  when(_prefs.setBool(StorageKeys.loopModeEnabled, true))
      .thenAnswer((_) async => true);
  when(_prefs.setBool(StorageKeys.analyticsEnabled, true))
      .thenAnswer((_) async => true);
  when(_prefs.setBool(StorageKeys.analyticsEnabled, false))
      .thenAnswer((_) async => true);
  when(_prefs.setBool(StorageKeys.netNeutralityTestsEnabled, true))
      .thenAnswer((_) async => true);
  when(_prefs.setBool(StorageKeys.netNeutralityTestsEnabled, false))
      .thenAnswer((_) async => true);
  when(_prefs.getBool(StorageKeys.netNeutralityTestsEnabled)).thenReturn(false);
  when(_prefs.getBool(StorageKeys.loopModeEnabled)).thenReturn(false);
  when(_prefs.getBool(StorageKeys.loopModeNetNeutralityEnabled))
      .thenReturn(false);
  when(_prefs.getBool(StorageKeys.loopModeFeatureEnabled)).thenReturn(false);
  when(_prefs.getBool(StorageKeys.languageSwitchEnabled)).thenReturn(false);
  when(_prefs.getInt(StorageKeys.loopModeMeasurementCountSet))
      .thenReturn(LoopMode.loopModeDefaultMeasurementCount);
  when(_prefs.getInt(StorageKeys.loopModeDistanceMetersSet))
      .thenReturn(LoopMode.loopModeDefaultDistanceMeters);
  when(_prefs.getInt(StorageKeys.loopModeWaitingTimeMinutesSet))
      .thenReturn(LoopMode.loopModeDefaultWaitingTimeMinutes);
  when(_prefs.setString(StorageKeys.selectedLocaleTag, _serbianLatinLocaleTag))
      .thenAnswer((_) async => true);
  when(_prefs.setString(StorageKeys.selectedLocaleTag, _germanLocaleTag))
      .thenAnswer((_) async => true);
  when(_prefs.remove(StorageKeys.selectedLocaleTag))
      .thenAnswer((_) async => true);
  when(GetIt.I.get<LocalizationService>().loadSelectedLanguage)
      .thenReturn(null);
  when(GetIt.I.get<LocalizationService>().getSupportedLanguages())
      .thenReturn(supportedLanguages);
  when(GetIt.I
          .get<NavigationService>()
          .pushNamed('settings/markdown', arguments: null))
      .thenReturn(null);
  when(GetIt.I
          .get<NavigationService>()
          .pushNamed('settings/loopModeAgreement', arguments: null))
      .thenReturn(null);
  when(_prefs.setBool(StorageKeys.languageSwitchEnabled, false))
      .thenAnswer((_) async => true);
  final bloc = MockMeasurementsBloc();
  final initState = MeasurementsState.init().copyWith(clientUuid: _newUuid);
  whenListen(bloc, Stream.fromIterable([initState]), initialState: initState);
  if (!GetIt.I.isRegistered<MeasurementsBloc>()) {
    GetIt.I.registerLazySingleton<MeasurementsBloc>(() => bloc);
  }
}
