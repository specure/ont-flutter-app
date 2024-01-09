// Mocks generated by Mockito 5.4.4 from annotations
// in nt_flutter_standalone/test/net-neutrality/unit-tests/net-neutrality-cubit_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:dio/dio.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:nt_flutter_standalone/core/models/error-handler.dart' as _i10;
import 'package:nt_flutter_standalone/modules/history/models/net-neutrality-history.dart'
    as _i13;
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-net-neutrality-settings-item.dart'
    as _i8;
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-item.dart'
    as _i12;
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-result-item.dart'
    as _i3;
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-result.dart'
    as _i11;
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-settings-response.dart'
    as _i5;
import 'package:nt_flutter_standalone/modules/net-neutrality/models/web-net-neutrality-settings-item.dart'
    as _i7;
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-api.service.dart'
    as _i9;
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-measurement.service.dart'
    as _i4;

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

class _FakeNetNeutralityResultItem_1 extends _i1.SmartFake
    implements _i3.NetNeutralityResultItem {
  _FakeNetNeutralityResultItem_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [NetNeutralityMeasurementService].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetNeutralityMeasurementService extends _i1.Mock
    implements _i4.NetNeutralityMeasurementService {
  @override
  set settings(_i5.NetNeutralitySettingsResponse? _settings) =>
      super.noSuchMethod(
        Invocation.setter(
          #settings,
          _settings,
        ),
        returnValueForMissingStub: null,
      );

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
  dynamic initWithSettings(_i5.NetNeutralitySettingsResponse? settings) =>
      super.noSuchMethod(
        Invocation.method(
          #initWithSettings,
          [settings],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i6.Future<_i3.NetNeutralityResultItem> runOneWebPageTest(
          _i7.WebNetNeutralitySettingsItem? test) =>
      (super.noSuchMethod(
        Invocation.method(
          #runOneWebPageTest,
          [test],
        ),
        returnValue: _i6.Future<_i3.NetNeutralityResultItem>.value(
            _FakeNetNeutralityResultItem_1(
          this,
          Invocation.method(
            #runOneWebPageTest,
            [test],
          ),
        )),
        returnValueForMissingStub:
            _i6.Future<_i3.NetNeutralityResultItem>.value(
                _FakeNetNeutralityResultItem_1(
          this,
          Invocation.method(
            #runOneWebPageTest,
            [test],
          ),
        )),
      ) as _i6.Future<_i3.NetNeutralityResultItem>);

  @override
  _i6.Future<_i3.NetNeutralityResultItem> runOneDnsTest(
          _i8.DnsNetNeutralitySettingsItem? test) =>
      (super.noSuchMethod(
        Invocation.method(
          #runOneDnsTest,
          [test],
        ),
        returnValue: _i6.Future<_i3.NetNeutralityResultItem>.value(
            _FakeNetNeutralityResultItem_1(
          this,
          Invocation.method(
            #runOneDnsTest,
            [test],
          ),
        )),
        returnValueForMissingStub:
            _i6.Future<_i3.NetNeutralityResultItem>.value(
                _FakeNetNeutralityResultItem_1(
          this,
          Invocation.method(
            #runOneDnsTest,
            [test],
          ),
        )),
      ) as _i6.Future<_i3.NetNeutralityResultItem>);

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

/// A class which mocks [NetNeutralityApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetNeutralityApiService extends _i1.Mock
    implements _i9.NetNeutralityApiService {
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
  _i6.Future<_i5.NetNeutralitySettingsResponse?> getSettings(
          {_i10.ErrorHandler? errorHandler}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSettings,
          [],
          {#errorHandler: errorHandler},
        ),
        returnValue: _i6.Future<_i5.NetNeutralitySettingsResponse?>.value(),
        returnValueForMissingStub:
            _i6.Future<_i5.NetNeutralitySettingsResponse?>.value(),
      ) as _i6.Future<_i5.NetNeutralitySettingsResponse?>);

  @override
  _i6.Future<void> postResults({
    _i11.NetNeutralityResult? results,
    _i10.ErrorHandler? errorHandler,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #postResults,
          [],
          {
            #results: results,
            #errorHandler: errorHandler,
          },
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<List<_i12.NetNeutralityHistoryItem>?> getHistory(
    String? openTestUuid, {
    _i10.ErrorHandler? errorHandler,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getHistory,
          [openTestUuid],
          {#errorHandler: errorHandler},
        ),
        returnValue: _i6.Future<List<_i12.NetNeutralityHistoryItem>?>.value(),
        returnValueForMissingStub:
            _i6.Future<List<_i12.NetNeutralityHistoryItem>?>.value(),
      ) as _i6.Future<List<_i12.NetNeutralityHistoryItem>?>);

  @override
  _i6.Future<_i13.NetNeutralityHistory?> getWholeHistory(
    int? page, {
    _i10.ErrorHandler? errorHandler,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getWholeHistory,
          [page],
          {#errorHandler: errorHandler},
        ),
        returnValue: _i6.Future<_i13.NetNeutralityHistory?>.value(),
        returnValueForMissingStub:
            _i6.Future<_i13.NetNeutralityHistory?>.value(),
      ) as _i6.Future<_i13.NetNeutralityHistory?>);

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
