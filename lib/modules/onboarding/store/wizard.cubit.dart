import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/screens/home.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/permissions.service.dart';
import 'package:nt_flutter_standalone/modules/onboarding/store/wizard.state.dart';

class WizardCubit extends Cubit<WizardState> {
  final PermissionsService _permissionsService =
      GetIt.I.get<PermissionsService>();

  final PlatformWrapper platform = GetIt.I.get<PlatformWrapper>();

  final SharedPreferencesWrapper _preferencesWrapper =
      GetIt.I.get<SharedPreferencesWrapper>();
  final NavigationService _navigationService = GetIt.I.get<NavigationService>();
  final CMSService _cmsService = GetIt.I.get<CMSService>();

  WizardCubit() : super(WizardState());

  init() async {
    emit(state.copyWith(project: await _cmsService.getProject()));
  }

  update(WizardState newState) {
    if(isClosed) return;
    emit(newState);
  }

  handlePermissions() async {
    await _handlePhonePermissions();
    await _handleLocationPermissions();
    await _handleNotificationPermissions();
    await _handleNetworkAcceess();
    await _preferencesWrapper.setBool(
        StorageKeys.analyticsEnabled, state.isAnalyticsSwitchOn);
    await _preferencesWrapper.setBool(
      StorageKeys.persistentClientUuidEnabled,
      state.isPersistentClientUuidSwitchOn,
    );
    await _preferencesWrapper.setBool(StorageKeys.isWizardCompleted, true);
    _navigationService.pushNamedAndCleanRoutes(HomeScreen.route);
  }

  _handlePhonePermissions() async {
    bool isGranted = false;
    if (state.isPhoneStatePermissionsSwitchOn) {
      isGranted = await _permissionsService.isPhonePermissionGranted;
    }
    await _preferencesWrapper.setBool(
      StorageKeys.phoneStatePermissionsGranted,
      isGranted,
    );
  }

  _handleLocationPermissions() async {
    bool isGranted = false;
    if (state.isLocationPermissionsSwitchOn) {
      isGranted = await _permissionsService.isLocationPermissionGranted;
    }
    await _preferencesWrapper.setBool(
      StorageKeys.locationPermissionsGranted,
      isGranted,
    );
  }

  _handleNetworkAcceess() async {
    if (state.isNetworkAccessSwitchOn &&
        state.project?.enableAppNetNeutralityTests == true) {
      await _permissionsService.requestLocalNetworkAccess();
    }
  }

  _handleNotificationPermissions() async {
    bool isGranted = false;
    if (state.isNotificationPermissionSwitchOn && platform.isAndroid) {
      isGranted = await _permissionsService.isNotificationPermissionGranted;
    }
    await _preferencesWrapper.setBool(
      StorageKeys.notificationPermissionGranted,
      isGranted,
    );
  }
}
