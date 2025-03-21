// Mocks generated by Mockito 5.4.5 from annotations
// in nt_flutter_standalone/test/measurements/widgets-tests/start-test.widget_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/src/widgets/navigator.dart' as _i1;
import 'package:flutter/src/widgets/routes.dart' as _i3;
import 'package:mockito/mockito.dart' as _i2;

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

/// A class which mocks [RouteObserver].
///
/// See the documentation for Mockito's code generation for more information.
class MockRouteObserver<R extends _i1.Route<dynamic>> extends _i2.Mock
    implements _i3.RouteObserver<R> {
  @override
  bool debugObservingRoute(R? route) =>
      (super.noSuchMethod(
            Invocation.method(#debugObservingRoute, [route]),
            returnValue: false,
            returnValueForMissingStub: false,
          )
          as bool);

  @override
  void subscribe(_i3.RouteAware? routeAware, R? route) => super.noSuchMethod(
    Invocation.method(#subscribe, [routeAware, route]),
    returnValueForMissingStub: null,
  );

  @override
  void unsubscribe(_i3.RouteAware? routeAware) => super.noSuchMethod(
    Invocation.method(#unsubscribe, [routeAware]),
    returnValueForMissingStub: null,
  );

  @override
  void didPop(_i1.Route<dynamic>? route, _i1.Route<dynamic>? previousRoute) =>
      super.noSuchMethod(
        Invocation.method(#didPop, [route, previousRoute]),
        returnValueForMissingStub: null,
      );

  @override
  void didPush(_i1.Route<dynamic>? route, _i1.Route<dynamic>? previousRoute) =>
      super.noSuchMethod(
        Invocation.method(#didPush, [route, previousRoute]),
        returnValueForMissingStub: null,
      );

  @override
  void didRemove(
    _i1.Route<dynamic>? route,
    _i1.Route<dynamic>? previousRoute,
  ) => super.noSuchMethod(
    Invocation.method(#didRemove, [route, previousRoute]),
    returnValueForMissingStub: null,
  );

  @override
  void didReplace({
    _i1.Route<dynamic>? newRoute,
    _i1.Route<dynamic>? oldRoute,
  }) => super.noSuchMethod(
    Invocation.method(#didReplace, [], {
      #newRoute: newRoute,
      #oldRoute: oldRoute,
    }),
    returnValueForMissingStub: null,
  );

  @override
  void didChangeTop(
    _i1.Route<dynamic>? topRoute,
    _i1.Route<dynamic>? previousTopRoute,
  ) => super.noSuchMethod(
    Invocation.method(#didChangeTop, [topRoute, previousTopRoute]),
    returnValueForMissingStub: null,
  );

  @override
  void didStartUserGesture(
    _i1.Route<dynamic>? route,
    _i1.Route<dynamic>? previousRoute,
  ) => super.noSuchMethod(
    Invocation.method(#didStartUserGesture, [route, previousRoute]),
    returnValueForMissingStub: null,
  );

  @override
  void didStopUserGesture() => super.noSuchMethod(
    Invocation.method(#didStopUserGesture, []),
    returnValueForMissingStub: null,
  );
}
