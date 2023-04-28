import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/permissions-map.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  static const MethodChannel _channel =
      const MethodChannel('nettest/permissions');
  final SharedPreferencesWrapper _preferences =
      GetIt.I.get<SharedPreferencesWrapper>();
  final PlatformWrapper _platformWrapper = GetIt.I.get<PlatformWrapper>();
  var _isLocationPermissionGranted = false;
  var _isPhonePermissionGranted = false;

  void initialize() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  Future<bool> get isLocationPermissionGranted async {
    try {
      _isLocationPermissionGranted =
          await Permission.location.request().isGranted;
    } catch (_) {}
    return _isLocationPermissionGranted;
  }

  Future<bool> get isPhonePermissionGranted async {
    try {
      _isPhonePermissionGranted = await Permission.phone.request().isGranted;
    } catch (_) {}
    return _isPhonePermissionGranted;
  }

  Future<bool> get isLocationWhenInUseEnabled async =>
      await Permission.locationWhenInUse.serviceStatus.isEnabled;

  Future<bool> get isLocationAlwaysEnabled async =>
      await Permission.locationAlways.serviceStatus.isEnabled;

  PermissionsMap get permissionsMap {
    return PermissionsMap(
      locationPermissionsGranted: _preferences.getBool(
            StorageKeys.locationPermissionsGranted,
          ) ??
          false,
      preciseLocationPermissionsGranted: _preferences.getBool(
            StorageKeys.preciseLocationPermissionsGranted,
          ) ??
          false,
      readPhoneStatePermissionsGranted: _preferences.getBool(
            StorageKeys.phoneStatePermissionsGranted,
          ) ??
          false,
    );
  }

  Future<bool> get isSignalPermissionGranted async {
    final permissions = await Future.wait(
        [isLocationWhenInUseEnabled, isLocationAlwaysEnabled]);
    return permissions[0] || permissions[1];
  }

  Future _platformCallHandler(MethodCall call) async {
    print("${call.method}: ${call.arguments}");
    try {
      switch (call.method) {
        case "permissionsChanged":
          final bool? locationPermissionsGranted =
              call.arguments["locationPermissionsGranted"];
          final bool? readPhoneStatePermissionsGranted =
              call.arguments["readPhoneStatePermissionsGranted"];
          var permissionsMap;
          if (_platformWrapper.isAndroid) {
            final bool? preciseLocationPermissionsGranted =
                call.arguments["preciseLocationPermissionsGranted"];
            permissionsMap = PermissionsMap(
                readPhoneStatePermissionsGranted:
                    readPhoneStatePermissionsGranted ?? true,
                locationPermissionsGranted: locationPermissionsGranted ?? true,
                preciseLocationPermissionsGranted:
                    preciseLocationPermissionsGranted ?? true);
            _preferences.setBool(StorageKeys.preciseLocationPermissionsGranted, preciseLocationPermissionsGranted ?? true);
          } else {
            permissionsMap = PermissionsMap(
                readPhoneStatePermissionsGranted:
                    readPhoneStatePermissionsGranted ?? true,
                locationPermissionsGranted: locationPermissionsGranted ?? true);
          }
          GetIt.I.get<MeasurementsBloc>().add(SetPermissions(permissionsMap));
          break;
      }
    } catch (err) {
      print(err);
    }
  }

  Future requestLocalNetworkAccess() async {
    if (GetIt.I.get<PlatformWrapper>().isAndroid) {
      return;
    }
    try {
      var deviceIp = await NetworkInfo().getWifiIP();
      Duration? timeOutDuration = Duration(milliseconds: 100);
      await Socket.connect(deviceIp, 80, timeout: timeOutDuration);
    } catch (err) {
      print(err);
    }
  }
}
