// Mocks generated by Mockito 5.4.5 from annotations
// in nt_flutter_standalone/test/history/widget-tests/history-screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:connectivity_plus/connectivity_plus.dart' as _i7;
import 'package:flutter_bloc/flutter_bloc.dart' as _i10;
import 'package:mockito/mockito.dart' as _i1;
import 'package:nt_flutter_standalone/core/models/error-handler.dart' as _i4;
import 'package:nt_flutter_standalone/modules/measurements/services/network.service.dart'
    as _i5;
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-details.dart'
    as _i8;
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-item.dart'
    as _i9;
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart'
    as _i3;
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeNetNeutralityState_0 extends _i1.SmartFake
    implements _i2.NetNeutralityState {
  _FakeNetNeutralityState_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [NetNeutralityCubit].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetNeutralityCubit extends _i1.Mock
    implements _i3.NetNeutralityCubit {
  MockNetNeutralityCubit() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set errorHandler(_i4.ErrorHandler? _errorHandler) => super.noSuchMethod(
    Invocation.setter(#errorHandler, _errorHandler),
    returnValueForMissingStub: null,
  );

  @override
  set connectivityChangesHandler(
    _i5.ConnectivityChangesHandler? _connectivityChangesHandler,
  ) => super.noSuchMethod(
    Invocation.setter(#connectivityChangesHandler, _connectivityChangesHandler),
    returnValueForMissingStub: null,
  );

  @override
  _i2.NetNeutralityState get state =>
      (super.noSuchMethod(
            Invocation.getter(#state),
            returnValue: _FakeNetNeutralityState_0(
              this,
              Invocation.getter(#state),
            ),
          )
          as _i2.NetNeutralityState);

  @override
  _i6.Stream<_i2.NetNeutralityState> get stream =>
      (super.noSuchMethod(
            Invocation.getter(#stream),
            returnValue: _i6.Stream<_i2.NetNeutralityState>.empty(),
          )
          as _i6.Stream<_i2.NetNeutralityState>);

  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);

  @override
  _i6.Future<dynamic> init() =>
      (super.noSuchMethod(
            Invocation.method(#init, []),
            returnValue: _i6.Future<dynamic>.value(),
          )
          as _i6.Future<dynamic>);

  @override
  _i6.Future<void> close() =>
      (super.noSuchMethod(
            Invocation.method(#close, []),
            returnValue: _i6.Future<void>.value(),
            returnValueForMissingStub: _i6.Future<void>.value(),
          )
          as _i6.Future<void>);

  @override
  dynamic updateConnectivity(_i7.ConnectivityResult? connectivity) => super
      .noSuchMethod(Invocation.method(#updateConnectivity, [connectivity]));

  @override
  dynamic openResultDetails(
    _i8.NetNeutralityDetailsConfig? detailsConfig,
    List<_i9.NetNeutralityHistoryItem>? results,
  ) => super.noSuchMethod(
    Invocation.method(#openResultDetails, [detailsConfig, results]),
  );

  @override
  _i6.Future<void> loadResults(String? openTestUuid) =>
      (super.noSuchMethod(
            Invocation.method(#loadResults, [openTestUuid]),
            returnValue: _i6.Future<void>.value(),
            returnValueForMissingStub: _i6.Future<void>.value(),
          )
          as _i6.Future<void>);

  @override
  void emit(_i2.NetNeutralityState? state) => super.noSuchMethod(
    Invocation.method(#emit, [state]),
    returnValueForMissingStub: null,
  );

  @override
  void onChange(_i10.Change<_i2.NetNeutralityState>? change) =>
      super.noSuchMethod(
        Invocation.method(#onChange, [change]),
        returnValueForMissingStub: null,
      );

  @override
  void addError(Object? error, [StackTrace? stackTrace]) => super.noSuchMethod(
    Invocation.method(#addError, [error, stackTrace]),
    returnValueForMissingStub: null,
  );

  @override
  void onError(Object? error, StackTrace? stackTrace) => super.noSuchMethod(
    Invocation.method(#onError, [error, stackTrace]),
    returnValueForMissingStub: null,
  );
}
