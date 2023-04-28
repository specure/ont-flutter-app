// Mocks generated by Mockito 5.3.2 from annotations
// in nt_flutter_standalone/test/core/unit-tests/dio-service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i17;
import 'dart:io' as _i18;

import 'package:device_info_plus/device_info_plus.dart' as _i12;
import 'package:flutter_bloc/flutter_bloc.dart' as _i23;
import 'package:mockito/mockito.dart' as _i1;
import 'package:nt_flutter_standalone/core/models/bloc-event.dart' as _i22;
import 'package:nt_flutter_standalone/core/models/error-handler.dart' as _i20;
import 'package:nt_flutter_standalone/core/services/navigation.service.dart'
    as _i10;
import 'package:nt_flutter_standalone/core/wrappers/internet-address.wrapper.dart'
    as _i16;
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart'
    as _i11;
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart'
    as _i13;
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart'
    as _i21;
import 'package:nt_flutter_standalone/modules/measurements/models/permissions-map.dart'
    as _i15;
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart'
    as _i7;
import 'package:nt_flutter_standalone/modules/measurements/services/loop.mode.service.dart'
    as _i3;
import 'package:nt_flutter_standalone/modules/measurements/services/measurement.service.dart'
    as _i2;
import 'package:nt_flutter_standalone/modules/measurements/services/measurements.api.service.dart'
    as _i5;
import 'package:nt_flutter_standalone/modules/measurements/services/network.service.dart'
    as _i8;
import 'package:nt_flutter_standalone/modules/measurements/services/permissions.service.dart'
    as _i4;
import 'package:nt_flutter_standalone/modules/measurements/services/signal.service.dart'
    as _i9;
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart'
    as _i19;
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart'
    as _i14;
import 'package:nt_flutter_standalone/modules/settings/services/settings.service.dart'
    as _i6;

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

class _FakeMeasurementService_0 extends _i1.SmartFake
    implements _i2.MeasurementService {
  _FakeMeasurementService_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLoopModeService_1 extends _i1.SmartFake
    implements _i3.LoopModeService {
  _FakeLoopModeService_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePermissionsService_2 extends _i1.SmartFake
    implements _i4.PermissionsService {
  _FakePermissionsService_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeMeasurementsApiService_3 extends _i1.SmartFake
    implements _i5.MeasurementsApiService {
  _FakeMeasurementsApiService_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSettingsService_4 extends _i1.SmartFake
    implements _i6.SettingsService {
  _FakeSettingsService_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLocationService_5 extends _i1.SmartFake
    implements _i7.LocationService {
  _FakeLocationService_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeNetworkService_6 extends _i1.SmartFake
    implements _i8.NetworkService {
  _FakeNetworkService_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSignalService_7 extends _i1.SmartFake implements _i9.SignalService {
  _FakeSignalService_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeNavigationService_8 extends _i1.SmartFake
    implements _i10.NavigationService {
  _FakeNavigationService_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePlatformWrapper_9 extends _i1.SmartFake
    implements _i11.PlatformWrapper {
  _FakePlatformWrapper_9(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDeviceInfoPlugin_10 extends _i1.SmartFake
    implements _i12.DeviceInfoPlugin {
  _FakeDeviceInfoPlugin_10(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSharedPreferencesWrapper_11 extends _i1.SmartFake
    implements _i13.SharedPreferencesWrapper {
  _FakeSharedPreferencesWrapper_11(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeMeasurementsState_12 extends _i1.SmartFake
    implements _i14.MeasurementsState {
  _FakeMeasurementsState_12(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePermissionsMap_13 extends _i1.SmartFake
    implements _i15.PermissionsMap {
  _FakePermissionsMap_13(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [InternetAddressWrapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockInternetAddressWrapper extends _i1.Mock
    implements _i16.InternetAddressWrapper {
  MockInternetAddressWrapper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i17.Future<List<_i18.InternetAddress>> lookup(
    String? host, {
    _i18.InternetAddressType? type = _i18.InternetAddressType.any,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #lookup,
          [host],
          {#type: type},
        ),
        returnValue: _i17.Future<List<_i18.InternetAddress>>.value(
            <_i18.InternetAddress>[]),
      ) as _i17.Future<List<_i18.InternetAddress>>);
}

/// A class which mocks [MeasurementsBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockMeasurementsBlocCalls extends _i1.Mock
    implements _i19.MeasurementsBloc {
  @override
  _i2.MeasurementService get measurementService => (super.noSuchMethod(
        Invocation.getter(#measurementService),
        returnValue: _FakeMeasurementService_0(
          this,
          Invocation.getter(#measurementService),
        ),
        returnValueForMissingStub: _FakeMeasurementService_0(
          this,
          Invocation.getter(#measurementService),
        ),
      ) as _i2.MeasurementService);
  @override
  _i3.LoopModeService get loopModeService => (super.noSuchMethod(
        Invocation.getter(#loopModeService),
        returnValue: _FakeLoopModeService_1(
          this,
          Invocation.getter(#loopModeService),
        ),
        returnValueForMissingStub: _FakeLoopModeService_1(
          this,
          Invocation.getter(#loopModeService),
        ),
      ) as _i3.LoopModeService);
  @override
  _i4.PermissionsService get permissionsService => (super.noSuchMethod(
        Invocation.getter(#permissionsService),
        returnValue: _FakePermissionsService_2(
          this,
          Invocation.getter(#permissionsService),
        ),
        returnValueForMissingStub: _FakePermissionsService_2(
          this,
          Invocation.getter(#permissionsService),
        ),
      ) as _i4.PermissionsService);
  @override
  _i5.MeasurementsApiService get measurementsApiService => (super.noSuchMethod(
        Invocation.getter(#measurementsApiService),
        returnValue: _FakeMeasurementsApiService_3(
          this,
          Invocation.getter(#measurementsApiService),
        ),
        returnValueForMissingStub: _FakeMeasurementsApiService_3(
          this,
          Invocation.getter(#measurementsApiService),
        ),
      ) as _i5.MeasurementsApiService);
  @override
  _i6.SettingsService get settingsService => (super.noSuchMethod(
        Invocation.getter(#settingsService),
        returnValue: _FakeSettingsService_4(
          this,
          Invocation.getter(#settingsService),
        ),
        returnValueForMissingStub: _FakeSettingsService_4(
          this,
          Invocation.getter(#settingsService),
        ),
      ) as _i6.SettingsService);
  @override
  _i7.LocationService get locationService => (super.noSuchMethod(
        Invocation.getter(#locationService),
        returnValue: _FakeLocationService_5(
          this,
          Invocation.getter(#locationService),
        ),
        returnValueForMissingStub: _FakeLocationService_5(
          this,
          Invocation.getter(#locationService),
        ),
      ) as _i7.LocationService);
  @override
  _i8.NetworkService get networkService => (super.noSuchMethod(
        Invocation.getter(#networkService),
        returnValue: _FakeNetworkService_6(
          this,
          Invocation.getter(#networkService),
        ),
        returnValueForMissingStub: _FakeNetworkService_6(
          this,
          Invocation.getter(#networkService),
        ),
      ) as _i8.NetworkService);
  @override
  _i9.SignalService get signalService => (super.noSuchMethod(
        Invocation.getter(#signalService),
        returnValue: _FakeSignalService_7(
          this,
          Invocation.getter(#signalService),
        ),
        returnValueForMissingStub: _FakeSignalService_7(
          this,
          Invocation.getter(#signalService),
        ),
      ) as _i9.SignalService);
  @override
  _i10.NavigationService get navigationService => (super.noSuchMethod(
        Invocation.getter(#navigationService),
        returnValue: _FakeNavigationService_8(
          this,
          Invocation.getter(#navigationService),
        ),
        returnValueForMissingStub: _FakeNavigationService_8(
          this,
          Invocation.getter(#navigationService),
        ),
      ) as _i10.NavigationService);
  @override
  _i11.PlatformWrapper get platform => (super.noSuchMethod(
        Invocation.getter(#platform),
        returnValue: _FakePlatformWrapper_9(
          this,
          Invocation.getter(#platform),
        ),
        returnValueForMissingStub: _FakePlatformWrapper_9(
          this,
          Invocation.getter(#platform),
        ),
      ) as _i11.PlatformWrapper);
  @override
  _i12.DeviceInfoPlugin get deviceInfoPlugin => (super.noSuchMethod(
        Invocation.getter(#deviceInfoPlugin),
        returnValue: _FakeDeviceInfoPlugin_10(
          this,
          Invocation.getter(#deviceInfoPlugin),
        ),
        returnValueForMissingStub: _FakeDeviceInfoPlugin_10(
          this,
          Invocation.getter(#deviceInfoPlugin),
        ),
      ) as _i12.DeviceInfoPlugin);
  @override
  _i13.SharedPreferencesWrapper get preferences => (super.noSuchMethod(
        Invocation.getter(#preferences),
        returnValue: _FakeSharedPreferencesWrapper_11(
          this,
          Invocation.getter(#preferences),
        ),
        returnValueForMissingStub: _FakeSharedPreferencesWrapper_11(
          this,
          Invocation.getter(#preferences),
        ),
      ) as _i13.SharedPreferencesWrapper);
  @override
  set errorHandler(_i20.ErrorHandler? _errorHandler) => super.noSuchMethod(
        Invocation.setter(
          #errorHandler,
          _errorHandler,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set connectivityChangesHandler(
          _i8.ConnectivityChangesHandler? _connectivityChangesHandler) =>
      super.noSuchMethod(
        Invocation.setter(
          #connectivityChangesHandler,
          _connectivityChangesHandler,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set loopModeChangesHandler(
          _i3.LoopModeChangesHandler? _loopModeChangesHandler) =>
      super.noSuchMethod(
        Invocation.setter(
          #loopModeChangesHandler,
          _loopModeChangesHandler,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i14.MeasurementsState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _FakeMeasurementsState_12(
          this,
          Invocation.getter(#state),
        ),
        returnValueForMissingStub: _FakeMeasurementsState_12(
          this,
          Invocation.getter(#state),
        ),
      ) as _i14.MeasurementsState);
  @override
  _i17.Stream<_i14.MeasurementsState> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i17.Stream<_i14.MeasurementsState>.empty(),
        returnValueForMissingStub: _i17.Stream<_i14.MeasurementsState>.empty(),
      ) as _i17.Stream<_i14.MeasurementsState>);
  @override
  bool get isClosed => (super.noSuchMethod(
        Invocation.getter(#isClosed),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i17.Future<dynamic> showMeasurementResult(String? measurementUuid) =>
      (super.noSuchMethod(
        Invocation.method(
          #showMeasurementResult,
          [measurementUuid],
        ),
        returnValue: _i17.Future<dynamic>.value(),
        returnValueForMissingStub: _i17.Future<dynamic>.value(),
      ) as _i17.Future<dynamic>);
  @override
  _i17.Future<_i21.NetworkInfoDetails?> getNetworkInfo() => (super.noSuchMethod(
        Invocation.method(
          #getNetworkInfo,
          [],
        ),
        returnValue: _i17.Future<_i21.NetworkInfoDetails?>.value(),
        returnValueForMissingStub:
            _i17.Future<_i21.NetworkInfoDetails?>.value(),
      ) as _i17.Future<_i21.NetworkInfoDetails?>);
  @override
  _i17.Future<_i14.MeasurementsState> startMeasurement() => (super.noSuchMethod(
        Invocation.method(
          #startMeasurement,
          [],
        ),
        returnValue:
            _i17.Future<_i14.MeasurementsState>.value(_FakeMeasurementsState_12(
          this,
          Invocation.method(
            #startMeasurement,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i17.Future<_i14.MeasurementsState>.value(_FakeMeasurementsState_12(
          this,
          Invocation.method(
            #startMeasurement,
            [],
          ),
        )),
      ) as _i17.Future<_i14.MeasurementsState>);
  @override
  _i17.Future<_i14.MeasurementsState> stopMeasurement() => (super.noSuchMethod(
        Invocation.method(
          #stopMeasurement,
          [],
        ),
        returnValue:
            _i17.Future<_i14.MeasurementsState>.value(_FakeMeasurementsState_12(
          this,
          Invocation.method(
            #stopMeasurement,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i17.Future<_i14.MeasurementsState>.value(_FakeMeasurementsState_12(
          this,
          Invocation.method(
            #stopMeasurement,
            [],
          ),
        )),
      ) as _i17.Future<_i14.MeasurementsState>);
  @override
  _i17.Future<_i15.PermissionsMap> checkPermissions() => (super.noSuchMethod(
        Invocation.method(
          #checkPermissions,
          [],
        ),
        returnValue:
            _i17.Future<_i15.PermissionsMap>.value(_FakePermissionsMap_13(
          this,
          Invocation.method(
            #checkPermissions,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i17.Future<_i15.PermissionsMap>.value(_FakePermissionsMap_13(
          this,
          Invocation.method(
            #checkPermissions,
            [],
          ),
        )),
      ) as _i17.Future<_i15.PermissionsMap>);
  @override
  dynamic setCloseDialogVisible(bool? visible) => super.noSuchMethod(
        Invocation.method(
          #setCloseDialogVisible,
          [visible],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i17.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i17.Future<void>.value(),
        returnValueForMissingStub: _i17.Future<void>.value(),
      ) as _i17.Future<void>);
  @override
  void add(_i22.BlocEvent<dynamic>? event) => super.noSuchMethod(
        Invocation.method(
          #add,
          [event],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onEvent(_i22.BlocEvent<dynamic>? event) => super.noSuchMethod(
        Invocation.method(
          #onEvent,
          [event],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void emit(_i14.MeasurementsState? state) => super.noSuchMethod(
        Invocation.method(
          #emit,
          [state],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void on<E extends _i22.BlocEvent<dynamic>>(
    _i23.EventHandler<E, _i14.MeasurementsState>? handler, {
    _i23.EventTransformer<E>? transformer,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #on,
          [handler],
          {#transformer: transformer},
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onTransition(
          _i23.Transition<_i22.BlocEvent<dynamic>, _i14.MeasurementsState>?
              transition) =>
      super.noSuchMethod(
        Invocation.method(
          #onTransition,
          [transition],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onChange(_i23.Change<_i14.MeasurementsState>? change) =>
      super.noSuchMethod(
        Invocation.method(
          #onChange,
          [change],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addError(
    Object? error, [
    StackTrace? stackTrace,
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #addError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onError(
    Object? error,
    StackTrace? stackTrace,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #onError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );
}