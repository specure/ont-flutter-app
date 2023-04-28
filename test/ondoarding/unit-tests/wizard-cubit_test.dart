import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/screens/home.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/permissions.service.dart';
import 'package:nt_flutter_standalone/modules/onboarding/store/wizard.cubit.dart';
import 'package:nt_flutter_standalone/modules/onboarding/store/wizard.state.dart';

import '../../di/service-locator.dart';

final _project = NTProject(enableAppNetNeutralityTests: true);
WizardCubit _cubit = WizardCubit();
WizardState _initialState = _cubit.state;

WizardCubit _setUpCubit() {
  _cubit = WizardCubit();
  _initialState = _cubit.state;
  return _cubit;
}

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances();
    when(GetIt.I.get<CMSService>().getProject())
        .thenAnswer(((realInvocation) async => _project));
    when(GetIt.I.get<PermissionsService>().isPhonePermissionGranted)
        .thenAnswer(((realInvocation) async => true));
    when(GetIt.I.get<PermissionsService>().isLocationPermissionGranted)
        .thenAnswer(((realInvocation) async => true));
    when(GetIt.I.get<PermissionsService>().requestLocalNetworkAccess())
        .thenAnswer((realInvocation) async {});
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .setBool(StorageKeys.analyticsEnabled, true))
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .setBool(StorageKeys.isWizardCompleted, true))
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .setBool(StorageKeys.persistentClientUuidEnabled, true))
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .setBool(StorageKeys.locationPermissionsGranted, true))
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .setBool(StorageKeys.phoneStatePermissionsGranted, true))
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I
            .get<NavigationService>()
            .pushNamedAndCleanRoutes(HomeScreen.route))
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I.get<PlatformWrapper>().isAndroid).thenReturn(true);
  });

  group("Wizard cubit", () {
    blocTest(
      'init',
      build: () => _setUpCubit(),
      act: (WizardCubit cubit) {
        cubit.init();
      },
      expect: () => [
        _initialState.copyWith(project: _project),
      ],
    );

    blocTest(
      'handlePermissions',
      build: () => _setUpCubit(),
      act: (WizardCubit cubit) {
        cubit.update(
          _initialState.copyWith(
            isAnalyticsSwitchOn: true,
            isLocationPermissionsSwitchOn: true,
            isPhoneStatePermissionsSwitchOn: true,
            isNetworkAccessSwitchOn: true,
            isPersistentClientUuidSwitchOn: true,
            project: _project,
          ),
        );
        cubit.handlePermissions();
      },
      expect: () => [
        _initialState.copyWith(
          isAnalyticsSwitchOn: true,
          isLocationPermissionsSwitchOn: true,
          isPhoneStatePermissionsSwitchOn: true,
          isNetworkAccessSwitchOn: true,
          isPersistentClientUuidSwitchOn: true,
          project: _project,
        ),
      ],
      verify: (cubit) {
        verify(GetIt.I.get<PermissionsService>().isPhonePermissionGranted)
            .called(1);
        verify(GetIt.I.get<SharedPreferencesWrapper>().setBool(
              StorageKeys.phoneStatePermissionsGranted,
              true,
            )).called(1);
        verify(GetIt.I.get<PermissionsService>().isLocationPermissionGranted)
            .called(1);
        verify(GetIt.I.get<SharedPreferencesWrapper>().setBool(
              StorageKeys.locationPermissionsGranted,
              true,
            )).called(1);
        verify(GetIt.I.get<PermissionsService>().requestLocalNetworkAccess())
            .called(1);
        verify(
          GetIt.I
              .get<SharedPreferencesWrapper>()
              .setBool(StorageKeys.analyticsEnabled, true),
        ).called(1);
        verify(
          GetIt.I
              .get<SharedPreferencesWrapper>()
              .setBool(StorageKeys.persistentClientUuidEnabled, true),
        ).called(1);
        verify(
          GetIt.I
              .get<SharedPreferencesWrapper>()
              .setBool(StorageKeys.isWizardCompleted, true),
        ).called(1);
        verify(
          GetIt.I
              .get<NavigationService>()
              .pushNamedAndCleanRoutes(HomeScreen.route),
        ).called(1);
      },
    );
  });
}
