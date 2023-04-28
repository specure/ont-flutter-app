import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/loop-mode.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/services/localization.service.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/wrappers/firebase-analytics.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/loop.mode.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/loop-mode-agreement.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/markdown.screen.dart';
import 'package:nt_flutter_standalone/modules/settings/services/settings.service.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/language.dart';

class SettingsCubit extends Cubit<SettingsState> implements ErrorHandler {
  final CoreCubit bottomNavigationCubit = GetIt.I.get<CoreCubit>();
  final SettingsService settingsService = GetIt.I.get<SettingsService>();
  final LoopModeService loopModeService = GetIt.I.get<LoopModeService>();
  final LocalizationService localizationService =
      GetIt.I.get<LocalizationService>();
  final CMSService cmsService = GetIt.I.get<CMSService>();
  final SharedPreferencesWrapper _preferences =
      GetIt.I.get<SharedPreferencesWrapper>();
  final NavigationService _navigationService = GetIt.I.get<NavigationService>();

  SettingsCubit() : super(SettingsState());

  init() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final clientUuid = (await _preferences.clientUuid) ??
        GetIt.I.get<MeasurementsBloc>().state.clientUuid;
    final persistentClientUuid =
        _preferences.getBool(StorageKeys.persistentClientUuidEnabled) ?? true;
    final analyticsEnabled =
        _preferences.getBool(StorageKeys.analyticsEnabled) ?? false;
    final loopModeEnabled =
        _preferences.getBool(StorageKeys.loopModeEnabled) ?? false;
    final loopModeQosEnabled =
        _preferences.getBool(StorageKeys.loopModeNetNeutralityEnabled) ?? false;
    final loopModeMeasurementCountSet =
        _preferences.getInt(StorageKeys.loopModeMeasurementCountSet) ??
            LoopMode.loopModeDefaultMeasurementCount;
    final loopModeWaitingTimeMinutesSet =
        _preferences.getInt(StorageKeys.loopModeWaitingTimeMinutesSet) ??
            LoopMode.loopModeDefaultWaitingTimeMinutes;
    final loopModeDistanceMetersSet =
        _preferences.getInt(StorageKeys.loopModeDistanceMetersSet) ??
            LoopMode.loopModeDefaultDistanceMeters;
    final loopModeFeatureEnabled =
        _preferences.getBool(StorageKeys.loopModeFeatureEnabled) ?? false;
    final languageSwitchEnabled =
        _preferences.getBool(StorageKeys.languageSwitchEnabled) ?? false;
    final netNeutralityTestsEnabled =
        _preferences.getBool(StorageKeys.netNeutralityTestsEnabled) ?? false;
    final languageSet = localizationService.loadSelectedLanguage;
    _setUpAnalytics(analyticsEnabled);
    emit(
      state.copyWith(
        appVersion: packageInfo.buildNumber.isEmpty
            ? packageInfo.version
            : '${packageInfo.version} (${packageInfo.buildNumber})',
        clientUuid: clientUuid,
        persistentClientUuidEnabled: persistentClientUuid,
        analyticsEnabled: analyticsEnabled,
        loopModeEnabled: loopModeEnabled,
        loopModeNetNeutralityEnabled: loopModeQosEnabled,
        loopModeWaitingTimeMinSet: loopModeWaitingTimeMinutesSet,
        loopModeDistanceMetersSet: loopModeDistanceMetersSet,
        loopModeMeasurementCountSet: loopModeMeasurementCountSet,
        loopModeFeatureEnabled: loopModeFeatureEnabled,
        languageSwitchEnabled: languageSwitchEnabled,
        netNeutralityTestsEnabled: netNeutralityTestsEnabled,
        selectedLanguage: languageSet,
        supportedLanguages: localizationService.getSupportedLanguages(),
      ),
    );
  }

  getPage(String route, String pageTitle) async {
    emit(state.copyWith(
      clientUuid: state.clientUuid,
      loading: true,
      staticPageTitle: pageTitle,
    ));
    _navigationService.pushNamed(MarkdownScreen.route);
    final pageContent = await cmsService.getPage(route, errorHandler: this);
    if (state.error != null) {
      return;
    }
    emit(state.copyWith(
      clientUuid: state.clientUuid,
      staticPageContent: pageContent,
      loading: false,
    ));
  }

  openLoopModeAgreement() {
    _navigationService.pushNamed(LoopModeAgreementScreen.route);
  }

  onLoopModeEnabledChange(bool value) async {
    await _preferences.setBool(StorageKeys.loopModeEnabled, value);
    emit(
      state.copyWith(
        loopModeEnabled: value,
        clientUuid: state.clientUuid,
      ),
    );
  }

  onLoopModeNetNeutralityChange(bool value) async {
    await _preferences.setBool(StorageKeys.loopModeNetNeutralityEnabled, value);
    emit(
      state.copyWith(
        loopModeNetNeutralityEnabled: value,
        clientUuid: state.clientUuid,
      ),
    );
  }

  onPersistentClientUuidChange(bool value) async {
    if (!value) {
      await _preferences.removeClientUuid();
    } else if (state.clientUuid != null) {
      await _preferences.setString(StorageKeys.clientUuid, state.clientUuid!);
    }
    await _preferences.setBool(StorageKeys.persistentClientUuidEnabled, value);
    emit(
      state.copyWith(
        persistentClientUuidEnabled: value,
        clientUuid: state.clientUuid,
      ),
    );
  }

  onAnalyticsChange(bool value) async {
    await _preferences.setBool(StorageKeys.analyticsEnabled, value);
    _setUpAnalytics(value);
    emit(
      state.copyWith(
        analyticsEnabled: value,
        clientUuid: state.clientUuid,
      ),
    );
  }

  onLoopModeWaitingTimeChange(int? minutes) async {
    if (minutes != null) {
      await _preferences.setInt(
          StorageKeys.loopModeWaitingTimeMinutesSet, minutes);
      emit(
        state.copyWith(
          loopModeWaitingTimeMinSet: minutes,
          clientUuid: state.clientUuid,
        ),
      );
    }
  }

  void onLoopModeDistanceMetersChange(int? meters) async {
    if (meters != null) {
      await _preferences.setInt(StorageKeys.loopModeDistanceMetersSet, meters);
      emit(
        state.copyWith(
          loopModeDistanceMetersSet: meters,
          clientUuid: state.clientUuid,
        ),
      );
    }
  }

  void onLoopModeMeasurementCountChange(int? count) async {
    if (count != null) {
      await _preferences.setInt(StorageKeys.loopModeMeasurementCountSet, count);
      emit(
        state.copyWith(
          loopModeMeasurementCountSet: count,
          clientUuid: state.clientUuid,
        ),
      );
    }
  }

  void setLanguage(Language? language) async {
    final selectedLocale = language?.getAsLocale;
    if (selectedLocale == null || selectedLocale.languageCode == 'Default') {
      await _preferences.remove(StorageKeys.selectedLocaleTag);
    } else {
      await _preferences.setString(
          StorageKeys.selectedLocaleTag, selectedLocale.toLanguageTag());
    }
    await localizationService.getTranslations();
    emit(
      state.copyWith(
        selectedLanguage: language,
        clientUuid: state.clientUuid,
      ),
    );
  }

  void clearUiErrors() {
    var stateUpdated = state.copyWith(
        clientUuid: state.clientUuid,
        loopMeasurementCountSetError: false,
        loopMeasurementDistanceSetError: false,
        loopMeasurementWaitingTimeSetError: false);
    emit(stateUpdated);
  }

  onValidationSucceeded(LoopModeCheckedFieldType? fieldType, int value) async {
    var stateUpdated;
    switch (fieldType) {
      case LoopModeCheckedFieldType.LOOP_MODE_COUNT:
        {
          stateUpdated = state.copyWith(
              clientUuid: state.clientUuid,
              loopModeMeasurementCountSet: value,
              loopMeasurementCountSetError: false);
          await _preferences.setInt(
              StorageKeys.loopModeMeasurementCountSet, value);
          break;
        }
      case LoopModeCheckedFieldType.LOOP_MODE_DISTANCE:
        {
          stateUpdated = state.copyWith(
              clientUuid: state.clientUuid,
              loopModeDistanceMetersSet: value,
              loopMeasurementDistanceSetError: false);
          await _preferences.setInt(
              StorageKeys.loopModeDistanceMetersSet, value);
          break;
        }
      case LoopModeCheckedFieldType.LOOP_MODE_WAITING_TIME:
        {
          stateUpdated = state.copyWith(
              clientUuid: state.clientUuid,
              loopModeWaitingTimeMinSet: value,
              loopMeasurementWaitingTimeSetError: false);
          await _preferences.setInt(
              StorageKeys.loopModeWaitingTimeMinutesSet, value);
          break;
        }
      default:
        break;
    }
    emit(stateUpdated);
  }

  void onValidationFailed(LoopModeCheckedFieldType? fieldType) {
    var stateUpdated;
    switch (fieldType) {
      case LoopModeCheckedFieldType.LOOP_MODE_COUNT:
        stateUpdated = state.copyWith(
            clientUuid: state.clientUuid, loopMeasurementCountSetError: true);
        break;
      case LoopModeCheckedFieldType.LOOP_MODE_DISTANCE:
        stateUpdated = state.copyWith(
            clientUuid: state.clientUuid,
            loopMeasurementDistanceSetError: true);
        break;
      case LoopModeCheckedFieldType.LOOP_MODE_WAITING_TIME:
        stateUpdated = state.copyWith(
            clientUuid: state.clientUuid,
            loopMeasurementWaitingTimeSetError: true);
        break;
      default:
        break;
    }
    emit(stateUpdated);
  }

  _setUpAnalytics(bool analyticsEnabled) async {
    GetIt.I
        .get<FirebaseAnalyticsWrapper>()
        .setAnalyticsEnabled(analyticsEnabled);
  }

  @override
  process(Exception? error) {
    if (error != null) {
      emit(state.copyWith(
        error: error,
        clientUuid: state.clientUuid,
        loading: false,
      ));
    }
  }
}
