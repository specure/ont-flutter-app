// Mocks generated by Mockito 5.4.4 from annotations
// in nt_flutter_standalone/test/map/unit-tests/map-cubit_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dio/dio.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:nt_flutter_standalone/modules/map/models/map-search.item.dart'
    as _i5;
import 'package:nt_flutter_standalone/modules/map/models/map-search.request.dart'
    as _i6;
import 'package:nt_flutter_standalone/modules/map/services/api/map-search.api.service.dart'
    as _i3;
import 'package:nt_flutter_standalone/modules/map/services/api/technology.api.service.dart'
    as _i7;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDio_0 extends _i1.SmartFake implements _i2.Dio {
  _FakeDio_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MapSearchApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockMapSearchApiService extends _i1.Mock
    implements _i3.MapSearchApiService {
  MockMapSearchApiService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Dio get dio => (super.noSuchMethod(
        Invocation.getter(#dio),
        returnValue: _FakeDio_0(
          this,
          Invocation.getter(#dio),
        ),
      ) as _i2.Dio);

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
  _i4.Future<List<_i5.MapSearchItem>> search(_i6.MapSearchRequest? request) =>
      (super.noSuchMethod(
        Invocation.method(
          #search,
          [request],
        ),
        returnValue:
            _i4.Future<List<_i5.MapSearchItem>>.value(<_i5.MapSearchItem>[]),
      ) as _i4.Future<List<_i5.MapSearchItem>>);

  @override
  _i2.Dio dioInstanceForUrl(String? url) => (super.noSuchMethod(
        Invocation.method(
          #dioInstanceForUrl,
          [url],
        ),
        returnValue: _FakeDio_0(
          this,
          Invocation.method(
            #dioInstanceForUrl,
            [url],
          ),
        ),
      ) as _i2.Dio);
}

/// A class which mocks [TechnologyApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTechnologyApiService extends _i1.Mock
    implements _i7.TechnologyApiService {
  @override
  _i2.Dio get dio => (super.noSuchMethod(
        Invocation.getter(#dio),
        returnValue: _FakeDio_0(
          this,
          Invocation.getter(#dio),
        ),
        returnValueForMissingStub: _FakeDio_0(
          this,
          Invocation.getter(#dio),
        ),
      ) as _i2.Dio);

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
  _i4.Future<List<String>> getMnoProviders() => (super.noSuchMethod(
        Invocation.method(
          #getMnoProviders,
          [],
        ),
        returnValue: _i4.Future<List<String>>.value(<String>[]),
        returnValueForMissingStub: _i4.Future<List<String>>.value(<String>[]),
      ) as _i4.Future<List<String>>);

  @override
  _i4.Future<List<String>> getIspProviders() => (super.noSuchMethod(
        Invocation.method(
          #getIspProviders,
          [],
        ),
        returnValue: _i4.Future<List<String>>.value(<String>[]),
        returnValueForMissingStub: _i4.Future<List<String>>.value(<String>[]),
      ) as _i4.Future<List<String>>);

  @override
  _i2.Dio dioInstanceForUrl(String? url) => (super.noSuchMethod(
        Invocation.method(
          #dioInstanceForUrl,
          [url],
        ),
        returnValue: _FakeDio_0(
          this,
          Invocation.method(
            #dioInstanceForUrl,
            [url],
          ),
        ),
        returnValueForMissingStub: _FakeDio_0(
          this,
          Invocation.method(
            #dioInstanceForUrl,
            [url],
          ),
        ),
      ) as _i2.Dio);
}
