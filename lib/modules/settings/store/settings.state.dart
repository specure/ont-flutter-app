import 'package:equatable/equatable.dart';
import 'package:nt_flutter_standalone/core/constants/loop-mode.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/mixins/error-state.mixin.dart';
import 'package:nt_flutter_standalone/core/mixins/loading-state.mixin.dart';

import '../models/language.dart';

class SettingsState with ErrorState, LoadingState, EquatableMixin {
  final String appVersion;
  final String? clientUuid;
  final bool persistentClientUuidEnabled;
  final bool analyticsEnabled;
  final bool languageSwitchEnabled;
  final bool loopModeEnabled;
  final bool loopModeNetNeutralityEnabled;
  final int? loopModeDistanceMeters;
  final int? loopModeTestCount;
  final int? loopModeWaitingTimeMin;
  final bool loopModeFeatureEnabled;
  final bool loopMeasurementCountSetError;
  final bool loopMeasurementDistanceSetError;
  final bool loopMeasurementWaitingTimeSetError;
  final String staticPageTitle;
  final String staticPageContent;
  final Language? selectedLanguage;
  final List<Language>? supportedLanguages;
  final NetNeutralityMeasurement netNeutralityMeasurement;
  final bool netNeutralityTestsEnabled;

  int get loopModeDistanceMetersSet => loopModeDistanceMeters ?? LoopMode.loopModeDefaultDistanceMeters;
  int get loopModeWaitingTimeMinSet => loopModeWaitingTimeMin ?? LoopMode.loopModeDefaultWaitingTimeMinutes;
  int get loopModeTestCountSet => loopModeTestCount ?? LoopMode.loopModeDefaultMeasurementCount;

  SettingsState({
    this.appVersion = '',
    this.clientUuid,
    this.persistentClientUuidEnabled = true,
    this.analyticsEnabled = false,
    this.loopModeFeatureEnabled = false,
    this.languageSwitchEnabled = false,
    this.selectedLanguage,
    this.supportedLanguages,
    this.loopModeEnabled = false,
    this.loopModeNetNeutralityEnabled = false,
    this.loopModeTestCount,
    this.loopModeWaitingTimeMin,
    this.loopModeDistanceMeters,
    this.staticPageContent = '',
    this.staticPageTitle = '',
    this.netNeutralityMeasurement = NetNeutralityMeasurement.ON_NEW_NETWORK,
    this.loopMeasurementCountSetError = false,
    this.loopMeasurementDistanceSetError = false,
    this.loopMeasurementWaitingTimeSetError = false,
    this.netNeutralityTestsEnabled = false,
    Exception? error,
    bool loading = false,
  }) {
    this.error = error;
    this.loading = loading;
  }

  SettingsState copyWith({
    required String? clientUuid,
    Exception? error,
    String? appVersion,
    bool? persistentClientUuidEnabled,
    bool? analyticsEnabled,
    bool? loopModeEnabled,
    bool? loopModeNetNeutralityEnabled,
    int? loopModeMeasurementCountSet,
    int? loopModeWaitingTimeMinSet,
    int? loopModeDistanceMetersSet,
    bool? loopMeasurementCountSetError,
    bool? loopMeasurementDistanceSetError,
    bool? loopMeasurementWaitingTimeSetError,
    bool? loopModeFeatureEnabled,
    bool? languageSwitchEnabled,
    bool? netNeutralityTestsEnabled,
    Language? selectedLanguage,
    List<Language>? supportedLanguages,
    String? staticPageContent,
    String? staticPageTitle,
    bool? loading,
    NetNeutralityMeasurement? netNeutralityMeasurement,
  }) {
    return SettingsState(
      error: error,
      appVersion: appVersion ?? this.appVersion,
      clientUuid: clientUuid,
      persistentClientUuidEnabled:
          persistentClientUuidEnabled ?? this.persistentClientUuidEnabled,
      analyticsEnabled:
      analyticsEnabled ?? this.analyticsEnabled,
      languageSwitchEnabled: languageSwitchEnabled ?? this.languageSwitchEnabled,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
      loopModeFeatureEnabled:
      loopModeFeatureEnabled ?? this.loopModeFeatureEnabled,
      loopModeEnabled:
      loopModeEnabled ?? this.loopModeEnabled,
      loopModeNetNeutralityEnabled:
      loopModeNetNeutralityEnabled ?? this.loopModeNetNeutralityEnabled,
      loopModeTestCount: loopModeMeasurementCountSet ?? this.loopModeTestCountSet,
      loopModeWaitingTimeMin: loopModeWaitingTimeMinSet ?? this.loopModeWaitingTimeMinSet,
      loopModeDistanceMeters: loopModeDistanceMetersSet ?? this.loopModeDistanceMetersSet,
      loopMeasurementCountSetError: loopMeasurementCountSetError ?? this.loopMeasurementCountSetError,
      loopMeasurementDistanceSetError: loopMeasurementDistanceSetError ?? this.loopMeasurementDistanceSetError,
      loopMeasurementWaitingTimeSetError: loopMeasurementWaitingTimeSetError ?? this.loopMeasurementWaitingTimeSetError,
      staticPageContent: staticPageContent ?? this.staticPageContent,
      staticPageTitle: staticPageTitle ?? this.staticPageTitle,
      loading: loading ?? this.loading,
      netNeutralityMeasurement: netNeutralityMeasurement ?? this.netNeutralityMeasurement,
      netNeutralityTestsEnabled: netNeutralityTestsEnabled ?? this.netNeutralityTestsEnabled,
    );
  }

  @override
  List<Object?> get props => [
        error,
        appVersion,
        clientUuid,
        persistentClientUuidEnabled,
        analyticsEnabled,
        languageSwitchEnabled,
        selectedLanguage,
        supportedLanguages,
        loopModeFeatureEnabled,
        loopModeEnabled,
        loopModeNetNeutralityEnabled,
        loopModeTestCountSet,
        loopModeWaitingTimeMinSet,
        loopModeDistanceMetersSet,
        loopMeasurementCountSetError,
        loopMeasurementDistanceSetError,
        loopMeasurementWaitingTimeSetError,
        loading,
        staticPageContent,
        staticPageTitle,
        netNeutralityMeasurement,
        netNeutralityTestsEnabled,
      ];

  bool isLoopModeActivated() {
    return loopModeEnabled && loopModeFeatureEnabled;
  }

  bool isLoopModeConfiguredCorrectly() {
    return !(loopMeasurementWaitingTimeSetError || loopMeasurementDistanceSetError || loopMeasurementCountSetError);
  }
}

enum LoopModeCheckedFieldType {
  LOOP_MODE_COUNT,
  LOOP_MODE_WAITING_TIME,
  LOOP_MODE_DISTANCE
}

enum NetNeutralityMeasurement {
  ON_NEW_NETWORK,
  MANUALLY,
  ALWAYS,
}

extension Naming on NetNeutralityMeasurement {
  String toName() {
    switch (this) {
      case NetNeutralityMeasurement.ALWAYS: return "Always".translated;
      case NetNeutralityMeasurement.MANUALLY: return "Manually".translated;
      case NetNeutralityMeasurement.ON_NEW_NETWORK: return "On New Network".translated;
    }
  }
}
