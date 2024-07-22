import 'package:equatable/equatable.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';

class WizardState extends Equatable {
  final NTProject? project;
  final bool isLocationPermissionsSwitchOn;
  final bool isPhoneStatePermissionsSwitchOn;
  final bool isNetworkAccessSwitchOn;
  final bool isAnalyticsSwitchOn;
  final bool isPersistentClientUuidSwitchOn;
  final bool isNotificationPermissionSwitchOn;

  WizardState({
    this.project,
    this.isLocationPermissionsSwitchOn = true,
    this.isPhoneStatePermissionsSwitchOn = true,
    this.isNetworkAccessSwitchOn = true,
    this.isAnalyticsSwitchOn = true,
    this.isPersistentClientUuidSwitchOn = true,
    this.isNotificationPermissionSwitchOn = true,
  });

  WizardState copyWith({
    NTProject? project,
    bool? isLocationPermissionsSwitchOn,
    bool? isPhoneStatePermissionsSwitchOn,
    bool? isNetworkAccessSwitchOn,
    bool? isAnalyticsSwitchOn,
    bool? isPersistentClientUuidSwitchOn,
    bool? isNotificationPermissionSwitchOn,
  }) =>
      WizardState(
        project: project ?? this.project,
        isLocationPermissionsSwitchOn:
            isLocationPermissionsSwitchOn ?? this.isLocationPermissionsSwitchOn,
        isPhoneStatePermissionsSwitchOn: isPhoneStatePermissionsSwitchOn ??
            this.isPhoneStatePermissionsSwitchOn,
        isNetworkAccessSwitchOn:
            isNetworkAccessSwitchOn ?? this.isNetworkAccessSwitchOn,
        isAnalyticsSwitchOn: isAnalyticsSwitchOn ?? this.isAnalyticsSwitchOn,
        isPersistentClientUuidSwitchOn: isPersistentClientUuidSwitchOn ??
            this.isPersistentClientUuidSwitchOn,
        isNotificationPermissionSwitchOn: isNotificationPermissionSwitchOn ??
            this.isNotificationPermissionSwitchOn,
      );

  @override
  List<Object?> get props => [
        project,
        isLocationPermissionsSwitchOn,
        isPhoneStatePermissionsSwitchOn,
        isNetworkAccessSwitchOn,
        isAnalyticsSwitchOn,
        isPersistentClientUuidSwitchOn,
        isNotificationPermissionSwitchOn,
      ];
}
