// Mocks generated by Mockito 5.3.2 from annotations
// in nt_flutter_standalone/test/measurements/unit-tests/measurements-bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i19;
import 'dart:ui' as _i10;

import 'package:connectivity_plus/connectivity_plus.dart' as _i18;
import 'package:device_info_plus/device_info_plus.dart' as _i32;
import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart'
    as _i8;
import 'package:dio/dio.dart' as _i4;
import 'package:flutter/material.dart' as _i7;
import 'package:flutter/services.dart' as _i2;
import 'package:mapbox_gl/mapbox_gl.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;
import 'package:nt_flutter_standalone/core/models/bloc-event.dart' as _i23;
import 'package:nt_flutter_standalone/core/models/error-handler.dart' as _i28;
import 'package:nt_flutter_standalone/core/models/project.dart' as _i39;
import 'package:nt_flutter_standalone/core/models/settings.dart' as _i29;
import 'package:nt_flutter_standalone/core/services/cms.service.dart' as _i38;
import 'package:nt_flutter_standalone/core/services/localization.service.dart'
    as _i33;
import 'package:nt_flutter_standalone/core/services/navigation.service.dart'
    as _i31;
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart'
    as _i16;
import 'package:nt_flutter_standalone/core/wrappers/wakelock.wrapper.dart'
    as _i36;
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart'
    as _i24;
import 'package:nt_flutter_standalone/modules/measurement-result/models/loop-mode-settings-model.dart'
    as _i25;
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart'
    as _i22;
import 'package:nt_flutter_standalone/modules/measurements/models/loop-mode-details.dart'
    as _i11;
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart'
    as _i20;
import 'package:nt_flutter_standalone/modules/measurements/models/permissions-map.dart'
    as _i3;
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/carrier-info.wrapper.dart'
    as _i14;
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/cell-info.wrapper.dart'
    as _i15;
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/geocoding-wrapper.dart'
    as _i5;
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/wifi-for-iot-plugin.wrapper.dart'
    as _i13;
import 'package:nt_flutter_standalone/modules/measurements/services/app.review.service.dart'
    as _i34;
import 'package:nt_flutter_standalone/modules/measurements/services/ip-info.service.dart'
    as _i12;
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart'
    as _i30;
import 'package:nt_flutter_standalone/modules/measurements/services/loop.mode.service.dart'
    as _i35;
import 'package:nt_flutter_standalone/modules/measurements/services/measurement.service.dart'
    as _i21;
import 'package:nt_flutter_standalone/modules/measurements/services/network.service.dart'
    as _i37;
import 'package:nt_flutter_standalone/modules/measurements/services/permissions.service.dart'
    as _i26;
import 'package:nt_flutter_standalone/modules/measurements/services/signal.service.dart'
    as _i17;
import 'package:nt_flutter_standalone/modules/settings/models/language.dart'
    as _i9;
import 'package:nt_flutter_standalone/modules/settings/services/settings.service.dart'
    as _i27;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeMethodChannel_0 extends _i1.SmartFake implements _i2.MethodChannel {
  _FakeMethodChannel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePermissionsMap_1 extends _i1.SmartFake
    implements _i3.PermissionsMap {
  _FakePermissionsMap_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDio_2 extends _i1.SmartFake implements _i4.Dio {
  _FakeDio_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGeocodingWrapper_3 extends _i1.SmartFake
    implements _i5.GeocodingWrapper {
  _FakeGeocodingWrapper_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLatLng_4 extends _i1.SmartFake implements _i6.LatLng {
  _FakeLatLng_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGlobalKey_5<T extends _i7.State<_i7.StatefulWidget>>
    extends _i1.SmartFake implements _i7.GlobalKey<T> {
  _FakeGlobalKey_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAndroidDeviceInfo_6 extends _i1.SmartFake
    implements _i8.AndroidDeviceInfo {
  _FakeAndroidDeviceInfo_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeIosDeviceInfo_7 extends _i1.SmartFake implements _i8.IosDeviceInfo {
  _FakeIosDeviceInfo_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLinuxDeviceInfo_8 extends _i1.SmartFake
    implements _i8.LinuxDeviceInfo {
  _FakeLinuxDeviceInfo_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWebBrowserInfo_9 extends _i1.SmartFake
    implements _i8.WebBrowserInfo {
  _FakeWebBrowserInfo_9(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeMacOsDeviceInfo_10 extends _i1.SmartFake
    implements _i8.MacOsDeviceInfo {
  _FakeMacOsDeviceInfo_10(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWindowsDeviceInfo_11 extends _i1.SmartFake
    implements _i8.WindowsDeviceInfo {
  _FakeWindowsDeviceInfo_11(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBaseDeviceInfo_12 extends _i1.SmartFake
    implements _i8.BaseDeviceInfo {
  _FakeBaseDeviceInfo_12(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLanguage_13 extends _i1.SmartFake implements _i9.Language {
  _FakeLanguage_13(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLocale_14 extends _i1.SmartFake implements _i10.Locale {
  _FakeLocale_14(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLoopModeDetails_15 extends _i1.SmartFake
    implements _i11.LoopModeDetails {
  _FakeLoopModeDetails_15(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeIPInfoService_16 extends _i1.SmartFake
    implements _i12.IPInfoService {
  _FakeIPInfoService_16(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWifiForIoTPluginWrapper_17 extends _i1.SmartFake
    implements _i13.WifiForIoTPluginWrapper {
  _FakeWifiForIoTPluginWrapper_17(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCarrierInfoWrapper_18 extends _i1.SmartFake
    implements _i14.CarrierInfoWrapper {
  _FakeCarrierInfoWrapper_18(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCellInfoWrapper_19 extends _i1.SmartFake
    implements _i15.CellInfoWrapper {
  _FakeCellInfoWrapper_19(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePlatformWrapper_20 extends _i1.SmartFake
    implements _i16.PlatformWrapper {
  _FakePlatformWrapper_20(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSignalService_21 extends _i1.SmartFake
    implements _i17.SignalService {
  _FakeSignalService_21(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeConnectivity_22 extends _i1.SmartFake implements _i18.Connectivity {
  _FakeConnectivity_22(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStreamSubscription_23<T> extends _i1.SmartFake
    implements _i19.StreamSubscription<T> {
  _FakeStreamSubscription_23(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeNetworkInfoDetails_24 extends _i1.SmartFake
    implements _i20.NetworkInfoDetails {
  _FakeNetworkInfoDetails_24(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MeasurementService].
///
/// See the documentation for Mockito's code generation for more information.
class MockMeasurementService extends _i1.Mock
    implements _i21.MeasurementService {
  MockMeasurementService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.MethodChannel get channel => (super.noSuchMethod(
        Invocation.getter(#channel),
        returnValue: _FakeMethodChannel_0(
          this,
          Invocation.getter(#channel),
        ),
      ) as _i2.MethodChannel);
  @override
  set lastPhase(_i22.MeasurementPhase? _lastPhase) => super.noSuchMethod(
        Invocation.setter(
          #lastPhase,
          _lastPhase,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set lastDispatchedEvent(_i23.BlocEvent<dynamic>? _lastDispatchedEvent) =>
      super.noSuchMethod(
        Invocation.setter(
          #lastDispatchedEvent,
          _lastDispatchedEvent,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i19.Future<String?> startTest(
    String? flavor, {
    String? clientUUID,
    _i24.LocationModel? location,
    int? measurementServerId,
    _i25.LoopModeSettings? loopModeSettings,
    dynamic enableAppJitterAndPacketLoss = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #startTest,
          [flavor],
          {
            #clientUUID: clientUUID,
            #location: location,
            #measurementServerId: measurementServerId,
            #loopModeSettings: loopModeSettings,
            #enableAppJitterAndPacketLoss: enableAppJitterAndPacketLoss,
          },
        ),
        returnValue: _i19.Future<String?>.value(),
      ) as _i19.Future<String?>);
  @override
  _i19.Future<String?> stopTest() => (super.noSuchMethod(
        Invocation.method(
          #stopTest,
          [],
        ),
        returnValue: _i19.Future<String?>.value(),
      ) as _i19.Future<String?>);
  @override
  _i19.Future<dynamic> platformCallHandler(_i2.MethodCall? call) =>
      (super.noSuchMethod(
        Invocation.method(
          #platformCallHandler,
          [call],
        ),
        returnValue: _i19.Future<dynamic>.value(),
      ) as _i19.Future<dynamic>);
}

/// A class which mocks [PermissionsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockPermissionsService extends _i1.Mock
    implements _i26.PermissionsService {
  MockPermissionsService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i19.Future<bool> get isLocationPermissionGranted => (super.noSuchMethod(
        Invocation.getter(#isLocationPermissionGranted),
        returnValue: _i19.Future<bool>.value(false),
      ) as _i19.Future<bool>);
  @override
  _i19.Future<bool> get isPhonePermissionGranted => (super.noSuchMethod(
        Invocation.getter(#isPhonePermissionGranted),
        returnValue: _i19.Future<bool>.value(false),
      ) as _i19.Future<bool>);
  @override
  _i19.Future<bool> get isLocationWhenInUseEnabled => (super.noSuchMethod(
        Invocation.getter(#isLocationWhenInUseEnabled),
        returnValue: _i19.Future<bool>.value(false),
      ) as _i19.Future<bool>);
  @override
  _i19.Future<bool> get isLocationAlwaysEnabled => (super.noSuchMethod(
        Invocation.getter(#isLocationAlwaysEnabled),
        returnValue: _i19.Future<bool>.value(false),
      ) as _i19.Future<bool>);
  @override
  _i3.PermissionsMap get permissionsMap => (super.noSuchMethod(
        Invocation.getter(#permissionsMap),
        returnValue: _FakePermissionsMap_1(
          this,
          Invocation.getter(#permissionsMap),
        ),
      ) as _i3.PermissionsMap);
  @override
  _i19.Future<bool> get isSignalPermissionGranted => (super.noSuchMethod(
        Invocation.getter(#isSignalPermissionGranted),
        returnValue: _i19.Future<bool>.value(false),
      ) as _i19.Future<bool>);
  @override
  void initialize() => super.noSuchMethod(
        Invocation.method(
          #initialize,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i19.Future<dynamic> requestLocalNetworkAccess() => (super.noSuchMethod(
        Invocation.method(
          #requestLocalNetworkAccess,
          [],
        ),
        returnValue: _i19.Future<dynamic>.value(),
      ) as _i19.Future<dynamic>);
}

/// A class which mocks [SettingsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSettingsService extends _i1.Mock implements _i27.SettingsService {
  MockSettingsService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Dio get dio => (super.noSuchMethod(
        Invocation.getter(#dio),
        returnValue: _FakeDio_2(
          this,
          Invocation.getter(#dio),
        ),
      ) as _i4.Dio);
  @override
  bool get testing => (super.noSuchMethod(
        Invocation.getter(#testing),
        returnValue: false,
      ) as bool);
  @override
  set testing(bool? _testing) => super.noSuchMethod(
        Invocation.setter(
          #testing,
          _testing,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i19.Future<String?> saveClientUuidAndSettings(
          {_i28.ErrorHandler? errorHandler}) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveClientUuidAndSettings,
          [],
          {#errorHandler: errorHandler},
        ),
        returnValue: _i19.Future<String?>.value(),
      ) as _i19.Future<String?>);
  @override
  _i19.Future<String?> setSettings(
    _i29.Settings? settings, {
    _i28.ErrorHandler? errorHandler,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #setSettings,
          [settings],
          {#errorHandler: errorHandler},
        ),
        returnValue: _i19.Future<String?>.value(),
      ) as _i19.Future<String?>);
  @override
  _i4.Dio dioInstanceForUrl(String? url) => (super.noSuchMethod(
        Invocation.method(
          #dioInstanceForUrl,
          [url],
        ),
        returnValue: _FakeDio_2(
          this,
          Invocation.method(
            #dioInstanceForUrl,
            [url],
          ),
        ),
      ) as _i4.Dio);
}

/// A class which mocks [LocationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocationService extends _i1.Mock implements _i30.LocationService {
  MockLocationService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.GeocodingWrapper get geocoding => (super.noSuchMethod(
        Invocation.getter(#geocoding),
        returnValue: _FakeGeocodingWrapper_3(
          this,
          Invocation.getter(#geocoding),
        ),
      ) as _i5.GeocodingWrapper);
  @override
  _i19.Future<bool> get isLocationServiceEnabled => (super.noSuchMethod(
        Invocation.getter(#isLocationServiceEnabled),
        returnValue: _i19.Future<bool>.value(false),
      ) as _i19.Future<bool>);
  @override
  _i19.Future<_i24.LocationModel?> get latestLocation => (super.noSuchMethod(
        Invocation.getter(#latestLocation),
        returnValue: _i19.Future<_i24.LocationModel?>.value(),
      ) as _i19.Future<_i24.LocationModel?>);
  @override
  _i4.Dio get dio => (super.noSuchMethod(
        Invocation.getter(#dio),
        returnValue: _FakeDio_2(
          this,
          Invocation.getter(#dio),
        ),
      ) as _i4.Dio);
  @override
  bool get testing => (super.noSuchMethod(
        Invocation.getter(#testing),
        returnValue: false,
      ) as bool);
  @override
  set testing(bool? _testing) => super.noSuchMethod(
        Invocation.setter(
          #testing,
          _testing,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i19.Future<_i24.LocationModel?> getAddressByLocation(
    double? latitude,
    double? longitude,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAddressByLocation,
          [
            latitude,
            longitude,
          ],
        ),
        returnValue: _i19.Future<_i24.LocationModel?>.value(),
      ) as _i19.Future<_i24.LocationModel?>);
  @override
  _i19.Future<_i6.LatLng> getCoordinatesByName(String? name) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCoordinatesByName,
          [name],
        ),
        returnValue: _i19.Future<_i6.LatLng>.value(_FakeLatLng_4(
          this,
          Invocation.method(
            #getCoordinatesByName,
            [name],
          ),
        )),
      ) as _i19.Future<_i6.LatLng>);
  @override
  _i4.Dio dioInstanceForUrl(String? url) => (super.noSuchMethod(
        Invocation.method(
          #dioInstanceForUrl,
          [url],
        ),
        returnValue: _FakeDio_2(
          this,
          Invocation.method(
            #dioInstanceForUrl,
            [url],
          ),
        ),
      ) as _i4.Dio);
}

/// A class which mocks [NavigationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockNavigationService extends _i1.Mock implements _i31.NavigationService {
  MockNavigationService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.GlobalKey<_i7.NavigatorState> get navigatorKey => (super.noSuchMethod(
        Invocation.getter(#navigatorKey),
        returnValue: _FakeGlobalKey_5<_i7.NavigatorState>(
          this,
          Invocation.getter(#navigatorKey),
        ),
      ) as _i7.GlobalKey<_i7.NavigatorState>);
  @override
  _i19.Future<dynamic> pushRoute(
    String? routeName,
    dynamic arguments,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #pushRoute,
          [
            routeName,
            arguments,
          ],
        ),
        returnValue: _i19.Future<dynamic>.value(),
      ) as _i19.Future<dynamic>);
  @override
  _i19.Future<dynamic> pushReplacementRoute(
    String? routeName,
    dynamic arguments,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #pushReplacementRoute,
          [
            routeName,
            arguments,
          ],
        ),
        returnValue: _i19.Future<dynamic>.value(),
      ) as _i19.Future<dynamic>);
  @override
  _i19.Future<dynamic>? pushScreen(_i7.Widget? screen) =>
      (super.noSuchMethod(Invocation.method(
        #pushScreen,
        [screen],
      )) as _i19.Future<dynamic>?);
  @override
  _i19.Future<dynamic>? pushNamed(
    String? routeName, {
    dynamic arguments,
  }) =>
      (super.noSuchMethod(Invocation.method(
        #pushNamed,
        [routeName],
        {#arguments: arguments},
      )) as _i19.Future<dynamic>?);
  @override
  _i19.Future<dynamic>? pushNamedAndCleanRoutes(
    String? routeName, {
    dynamic arguments,
  }) =>
      (super.noSuchMethod(Invocation.method(
        #pushNamedAndCleanRoutes,
        [routeName],
        {#arguments: arguments},
      )) as _i19.Future<dynamic>?);
  @override
  dynamic goBack({int? levels = 1}) => super.noSuchMethod(Invocation.method(
        #goBack,
        [],
        {#levels: levels},
      ));
  @override
  dynamic showBottomSheet(
    _i7.Widget? child, {
    _i10.Color? backgroundColor,
    _i10.Color? barrierColor,
    bool? dismissible,
  }) =>
      super.noSuchMethod(Invocation.method(
        #showBottomSheet,
        [child],
        {
          #backgroundColor: backgroundColor,
          #barrierColor: barrierColor,
          #dismissible: dismissible,
        },
      ));
}

/// A class which mocks [DeviceInfoPlugin].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeviceInfoPlugin extends _i1.Mock implements _i32.DeviceInfoPlugin {
  MockDeviceInfoPlugin() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i19.Future<_i8.AndroidDeviceInfo> get androidInfo => (super.noSuchMethod(
        Invocation.getter(#androidInfo),
        returnValue:
            _i19.Future<_i8.AndroidDeviceInfo>.value(_FakeAndroidDeviceInfo_6(
          this,
          Invocation.getter(#androidInfo),
        )),
      ) as _i19.Future<_i8.AndroidDeviceInfo>);
  @override
  _i19.Future<_i8.IosDeviceInfo> get iosInfo => (super.noSuchMethod(
        Invocation.getter(#iosInfo),
        returnValue: _i19.Future<_i8.IosDeviceInfo>.value(_FakeIosDeviceInfo_7(
          this,
          Invocation.getter(#iosInfo),
        )),
      ) as _i19.Future<_i8.IosDeviceInfo>);
  @override
  _i19.Future<_i8.LinuxDeviceInfo> get linuxInfo => (super.noSuchMethod(
        Invocation.getter(#linuxInfo),
        returnValue:
            _i19.Future<_i8.LinuxDeviceInfo>.value(_FakeLinuxDeviceInfo_8(
          this,
          Invocation.getter(#linuxInfo),
        )),
      ) as _i19.Future<_i8.LinuxDeviceInfo>);
  @override
  _i19.Future<_i8.WebBrowserInfo> get webBrowserInfo => (super.noSuchMethod(
        Invocation.getter(#webBrowserInfo),
        returnValue:
            _i19.Future<_i8.WebBrowserInfo>.value(_FakeWebBrowserInfo_9(
          this,
          Invocation.getter(#webBrowserInfo),
        )),
      ) as _i19.Future<_i8.WebBrowserInfo>);
  @override
  _i19.Future<_i8.MacOsDeviceInfo> get macOsInfo => (super.noSuchMethod(
        Invocation.getter(#macOsInfo),
        returnValue:
            _i19.Future<_i8.MacOsDeviceInfo>.value(_FakeMacOsDeviceInfo_10(
          this,
          Invocation.getter(#macOsInfo),
        )),
      ) as _i19.Future<_i8.MacOsDeviceInfo>);
  @override
  _i19.Future<_i8.WindowsDeviceInfo> get windowsInfo => (super.noSuchMethod(
        Invocation.getter(#windowsInfo),
        returnValue:
            _i19.Future<_i8.WindowsDeviceInfo>.value(_FakeWindowsDeviceInfo_11(
          this,
          Invocation.getter(#windowsInfo),
        )),
      ) as _i19.Future<_i8.WindowsDeviceInfo>);
  @override
  _i19.Future<_i8.BaseDeviceInfo> get deviceInfo => (super.noSuchMethod(
        Invocation.getter(#deviceInfo),
        returnValue:
            _i19.Future<_i8.BaseDeviceInfo>.value(_FakeBaseDeviceInfo_12(
          this,
          Invocation.getter(#deviceInfo),
        )),
      ) as _i19.Future<_i8.BaseDeviceInfo>);
}

/// A class which mocks [LocalizationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalizationService extends _i1.Mock
    implements _i33.LocalizationService {
  MockLocalizationService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get appLocaleSeparator => (super.noSuchMethod(
        Invocation.getter(#appLocaleSeparator),
        returnValue: '',
      ) as String);
  @override
  set selectedLocale(_i10.Locale? _selectedLocale) => super.noSuchMethod(
        Invocation.setter(
          #selectedLocale,
          _selectedLocale,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i9.Language get defaultLanguage => (super.noSuchMethod(
        Invocation.getter(#defaultLanguage),
        returnValue: _FakeLanguage_13(
          this,
          Invocation.getter(#defaultLanguage),
        ),
      ) as _i9.Language);
  @override
  _i10.Locale get currentLocale => (super.noSuchMethod(
        Invocation.getter(#currentLocale),
        returnValue: _FakeLocale_14(
          this,
          Invocation.getter(#currentLocale),
        ),
      ) as _i10.Locale);
  @override
  List<_i10.Locale> get supportedLocales => (super.noSuchMethod(
        Invocation.getter(#supportedLocales),
        returnValue: <_i10.Locale>[],
      ) as List<_i10.Locale>);
  @override
  _i4.Dio get dio => (super.noSuchMethod(
        Invocation.getter(#dio),
        returnValue: _FakeDio_2(
          this,
          Invocation.getter(#dio),
        ),
      ) as _i4.Dio);
  @override
  bool get testing => (super.noSuchMethod(
        Invocation.getter(#testing),
        returnValue: false,
      ) as bool);
  @override
  set testing(bool? _testing) => super.noSuchMethod(
        Invocation.setter(
          #testing,
          _testing,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String languageCodeAndScriptFromLanguageTag(String? languageTag) =>
      (super.noSuchMethod(
        Invocation.method(
          #languageCodeAndScriptFromLanguageTag,
          [languageTag],
        ),
        returnValue: '',
      ) as String);
  @override
  _i19.Future<void> getTranslations() => (super.noSuchMethod(
        Invocation.method(
          #getTranslations,
          [],
        ),
        returnValue: _i19.Future<void>.value(),
        returnValueForMissingStub: _i19.Future<void>.value(),
      ) as _i19.Future<void>);
  @override
  List<_i9.Language> getSupportedLanguages() => (super.noSuchMethod(
        Invocation.method(
          #getSupportedLanguages,
          [],
        ),
        returnValue: <_i9.Language>[],
      ) as List<_i9.Language>);
  @override
  String translate(String? key) => (super.noSuchMethod(
        Invocation.method(
          #translate,
          [key],
        ),
        returnValue: '',
      ) as String);
  @override
  String toCMSLanguageCode(String? languageCode) => (super.noSuchMethod(
        Invocation.method(
          #toCMSLanguageCode,
          [languageCode],
        ),
        returnValue: '',
      ) as String);
  @override
  _i4.Dio dioInstanceForUrl(String? url) => (super.noSuchMethod(
        Invocation.method(
          #dioInstanceForUrl,
          [url],
        ),
        returnValue: _FakeDio_2(
          this,
          Invocation.method(
            #dioInstanceForUrl,
            [url],
          ),
        ),
      ) as _i4.Dio);
}

/// A class which mocks [AppReviewService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppReviewService extends _i1.Mock implements _i34.AppReviewService {
  MockAppReviewService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i19.Future<bool> startAppReview() => (super.noSuchMethod(
        Invocation.method(
          #startAppReview,
          [],
        ),
        returnValue: _i19.Future<bool>.value(false),
      ) as _i19.Future<bool>);
}

/// A class which mocks [LoopModeService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoopModeService extends _i1.Mock implements _i35.LoopModeService {
  MockLoopModeService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i11.LoopModeDetails get loopModeDetails => (super.noSuchMethod(
        Invocation.getter(#loopModeDetails),
        returnValue: _FakeLoopModeDetails_15(
          this,
          Invocation.getter(#loopModeDetails),
        ),
      ) as _i11.LoopModeDetails);
  @override
  set loopModeDetails(_i11.LoopModeDetails? _loopModeDetails) =>
      super.noSuchMethod(
        Invocation.setter(
          #loopModeDetails,
          _loopModeDetails,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set nextTestTimer(_i19.Timer? _nextTestTimer) => super.noSuchMethod(
        Invocation.setter(
          #nextTestTimer,
          _nextTestTimer,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i19.Future<dynamic> initializeNewLoopMode(
          _i24.LocationModel? currentLocation) =>
      (super.noSuchMethod(
        Invocation.method(
          #initializeNewLoopMode,
          [currentLocation],
        ),
        returnValue: _i19.Future<dynamic>.value(),
      ) as _i19.Future<dynamic>);
  @override
  bool checkLoopEndingConditions() => (super.noSuchMethod(
        Invocation.method(
          #checkLoopEndingConditions,
          [],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i19.Future<dynamic> setLoopUuid(String? value) => (super.noSuchMethod(
        Invocation.method(
          #setLoopUuid,
          [value],
        ),
        returnValue: _i19.Future<dynamic>.value(),
      ) as _i19.Future<dynamic>);
  @override
  dynamic stopLoopTest(bool? notifyAboutChange) =>
      super.noSuchMethod(Invocation.method(
        #stopLoopTest,
        [notifyAboutChange],
      ));
  @override
  void setShouldLoopModeStart(bool? shouldStart) => super.noSuchMethod(
        Invocation.method(
          #setShouldLoopModeStart,
          [shouldStart],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [WakelockWrapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockWakelockWrapper extends _i1.Mock implements _i36.WakelockWrapper {
  MockWakelockWrapper() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [NetworkService].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkService extends _i1.Mock implements _i37.NetworkService {
  @override
  _i12.IPInfoService get ipInfoService => (super.noSuchMethod(
        Invocation.getter(#ipInfoService),
        returnValue: _FakeIPInfoService_16(
          this,
          Invocation.getter(#ipInfoService),
        ),
        returnValueForMissingStub: _FakeIPInfoService_16(
          this,
          Invocation.getter(#ipInfoService),
        ),
      ) as _i12.IPInfoService);
  @override
  _i13.WifiForIoTPluginWrapper get wifiPlugin => (super.noSuchMethod(
        Invocation.getter(#wifiPlugin),
        returnValue: _FakeWifiForIoTPluginWrapper_17(
          this,
          Invocation.getter(#wifiPlugin),
        ),
        returnValueForMissingStub: _FakeWifiForIoTPluginWrapper_17(
          this,
          Invocation.getter(#wifiPlugin),
        ),
      ) as _i13.WifiForIoTPluginWrapper);
  @override
  _i14.CarrierInfoWrapper get carrierPlugin => (super.noSuchMethod(
        Invocation.getter(#carrierPlugin),
        returnValue: _FakeCarrierInfoWrapper_18(
          this,
          Invocation.getter(#carrierPlugin),
        ),
        returnValueForMissingStub: _FakeCarrierInfoWrapper_18(
          this,
          Invocation.getter(#carrierPlugin),
        ),
      ) as _i14.CarrierInfoWrapper);
  @override
  _i15.CellInfoWrapper get cellPlugin => (super.noSuchMethod(
        Invocation.getter(#cellPlugin),
        returnValue: _FakeCellInfoWrapper_19(
          this,
          Invocation.getter(#cellPlugin),
        ),
        returnValueForMissingStub: _FakeCellInfoWrapper_19(
          this,
          Invocation.getter(#cellPlugin),
        ),
      ) as _i15.CellInfoWrapper);
  @override
  _i16.PlatformWrapper get platform => (super.noSuchMethod(
        Invocation.getter(#platform),
        returnValue: _FakePlatformWrapper_20(
          this,
          Invocation.getter(#platform),
        ),
        returnValueForMissingStub: _FakePlatformWrapper_20(
          this,
          Invocation.getter(#platform),
        ),
      ) as _i16.PlatformWrapper);
  @override
  _i17.SignalService get signalService => (super.noSuchMethod(
        Invocation.getter(#signalService),
        returnValue: _FakeSignalService_21(
          this,
          Invocation.getter(#signalService),
        ),
        returnValueForMissingStub: _FakeSignalService_21(
          this,
          Invocation.getter(#signalService),
        ),
      ) as _i17.SignalService);
  @override
  _i18.Connectivity get connectivity => (super.noSuchMethod(
        Invocation.getter(#connectivity),
        returnValue: _FakeConnectivity_22(
          this,
          Invocation.getter(#connectivity),
        ),
        returnValueForMissingStub: _FakeConnectivity_22(
          this,
          Invocation.getter(#connectivity),
        ),
      ) as _i18.Connectivity);
  @override
  _i19.Future<_i19.StreamSubscription<dynamic>> subscribeToNetworkChanges(
          {_i37.ConnectivityChangesHandler? changesHandler}) =>
      (super.noSuchMethod(
        Invocation.method(
          #subscribeToNetworkChanges,
          [],
          {#changesHandler: changesHandler},
        ),
        returnValue: _i19.Future<_i19.StreamSubscription<dynamic>>.value(
            _FakeStreamSubscription_23<dynamic>(
          this,
          Invocation.method(
            #subscribeToNetworkChanges,
            [],
            {#changesHandler: changesHandler},
          ),
        )),
        returnValueForMissingStub:
            _i19.Future<_i19.StreamSubscription<dynamic>>.value(
                _FakeStreamSubscription_23<dynamic>(
          this,
          Invocation.method(
            #subscribeToNetworkChanges,
            [],
            {#changesHandler: changesHandler},
          ),
        )),
      ) as _i19.Future<_i19.StreamSubscription<dynamic>>);
  @override
  _i19.Future<_i20.NetworkInfoDetails> getBasicNetworkDetails() =>
      (super.noSuchMethod(
        Invocation.method(
          #getBasicNetworkDetails,
          [],
        ),
        returnValue: _i19.Future<_i20.NetworkInfoDetails>.value(
            _FakeNetworkInfoDetails_24(
          this,
          Invocation.method(
            #getBasicNetworkDetails,
            [],
          ),
        )),
        returnValueForMissingStub: _i19.Future<_i20.NetworkInfoDetails>.value(
            _FakeNetworkInfoDetails_24(
          this,
          Invocation.method(
            #getBasicNetworkDetails,
            [],
          ),
        )),
      ) as _i19.Future<_i20.NetworkInfoDetails>);
  @override
  _i19.Future<_i20.NetworkInfoDetails> getAllNetworkDetails() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllNetworkDetails,
          [],
        ),
        returnValue: _i19.Future<_i20.NetworkInfoDetails>.value(
            _FakeNetworkInfoDetails_24(
          this,
          Invocation.method(
            #getAllNetworkDetails,
            [],
          ),
        )),
        returnValueForMissingStub: _i19.Future<_i20.NetworkInfoDetails>.value(
            _FakeNetworkInfoDetails_24(
          this,
          Invocation.method(
            #getAllNetworkDetails,
            [],
          ),
        )),
      ) as _i19.Future<_i20.NetworkInfoDetails>);
}

/// A class which mocks [CMSService].
///
/// See the documentation for Mockito's code generation for more information.
class MockCMSService extends _i1.Mock implements _i38.CMSService {
  @override
  _i4.Dio get dio => (super.noSuchMethod(
        Invocation.getter(#dio),
        returnValue: _FakeDio_2(
          this,
          Invocation.getter(#dio),
        ),
        returnValueForMissingStub: _FakeDio_2(
          this,
          Invocation.getter(#dio),
        ),
      ) as _i4.Dio);
  @override
  bool get testing => (super.noSuchMethod(
        Invocation.getter(#testing),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  set testing(bool? _testing) => super.noSuchMethod(
        Invocation.setter(
          #testing,
          _testing,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i19.Future<_i39.NTProject?> getProject({_i28.ErrorHandler? errorHandler}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getProject,
          [],
          {#errorHandler: errorHandler},
        ),
        returnValue: _i19.Future<_i39.NTProject?>.value(),
        returnValueForMissingStub: _i19.Future<_i39.NTProject?>.value(),
      ) as _i19.Future<_i39.NTProject?>);
  @override
  _i19.Future<String?>? getPage(
    String? route, {
    _i28.ErrorHandler? errorHandler,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPage,
          [route],
          {#errorHandler: errorHandler},
        ),
        returnValueForMissingStub: null,
      ) as _i19.Future<String?>?);
  @override
  _i19.Future<String?>? getDescription(
    String? route, {
    _i28.ErrorHandler? errorHandler,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getDescription,
          [route],
          {#errorHandler: errorHandler},
        ),
        returnValueForMissingStub: null,
      ) as _i19.Future<String?>?);
  @override
  dynamic getPageUrl(String? page) => super.noSuchMethod(
        Invocation.method(
          #getPageUrl,
          [page],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.Dio dioInstanceForUrl(String? url) => (super.noSuchMethod(
        Invocation.method(
          #dioInstanceForUrl,
          [url],
        ),
        returnValue: _FakeDio_2(
          this,
          Invocation.method(
            #dioInstanceForUrl,
            [url],
          ),
        ),
        returnValueForMissingStub: _FakeDio_2(
          this,
          Invocation.method(
            #dioInstanceForUrl,
            [url],
          ),
        ),
      ) as _i4.Dio);
}
