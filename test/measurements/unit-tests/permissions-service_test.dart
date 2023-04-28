import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/permissions-map.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/permissions.service.dart';

import '../../di/service-locator.dart';

void main() {
  group('Test permissions check', () {
    TestingServiceLocator.registerInstances();
    test('Test retrieving permissions map', () async {
      await _testPermissionsMap();
    });
  });
}

Future _testPermissionsMap() async {
  when(GetIt.I.get<SharedPreferencesWrapper>().getBool(
        StorageKeys.locationPermissionsGranted,
      )).thenReturn(true);
  when(GetIt.I.get<SharedPreferencesWrapper>().getBool(
    StorageKeys.preciseLocationPermissionsGranted,
  )).thenReturn(true);
  when(GetIt.I.get<SharedPreferencesWrapper>().getBool(
        StorageKeys.phoneStatePermissionsGranted,
      )).thenReturn(true);
  final permissionsService = PermissionsService();
  expect(
    permissionsService.permissionsMap,
    PermissionsMap(
      locationPermissionsGranted: true,
      readPhoneStatePermissionsGranted: true,
      preciseLocationPermissionsGranted: true,
    ),
  );
}
