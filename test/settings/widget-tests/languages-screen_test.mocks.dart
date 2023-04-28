// Mocks generated by Mockito 5.3.2 from annotations
// in nt_flutter_standalone/test/settings/widget-tests/languages-screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i9;

import 'package:flutter_bloc/flutter_bloc.dart' as _i11;
import 'package:mockito/mockito.dart' as _i1;
import 'package:nt_flutter_standalone/core/services/cms.service.dart' as _i6;
import 'package:nt_flutter_standalone/core/services/localization.service.dart'
    as _i5;
import 'package:nt_flutter_standalone/core/store/core.cubit.dart' as _i2;
import 'package:nt_flutter_standalone/modules/measurements/services/loop.mode.service.dart'
    as _i4;
import 'package:nt_flutter_standalone/modules/settings/models/language.dart'
    as _i10;
import 'package:nt_flutter_standalone/modules/settings/services/settings.service.dart'
    as _i3;
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart'
    as _i8;
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart'
    as _i7;

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

class _FakeCoreCubit_0 extends _i1.SmartFake implements _i2.CoreCubit {
  _FakeCoreCubit_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSettingsService_1 extends _i1.SmartFake
    implements _i3.SettingsService {
  _FakeSettingsService_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLoopModeService_2 extends _i1.SmartFake
    implements _i4.LoopModeService {
  _FakeLoopModeService_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLocalizationService_3 extends _i1.SmartFake
    implements _i5.LocalizationService {
  _FakeLocalizationService_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCMSService_4 extends _i1.SmartFake implements _i6.CMSService {
  _FakeCMSService_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSettingsState_5 extends _i1.SmartFake implements _i7.SettingsState {
  _FakeSettingsState_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SettingsCubit].
///
/// See the documentation for Mockito's code generation for more information.
class MockSettingsCubitCalls extends _i1.Mock implements _i8.SettingsCubit {
  @override
  _i2.CoreCubit get bottomNavigationCubit => (super.noSuchMethod(
        Invocation.getter(#bottomNavigationCubit),
        returnValue: _FakeCoreCubit_0(
          this,
          Invocation.getter(#bottomNavigationCubit),
        ),
        returnValueForMissingStub: _FakeCoreCubit_0(
          this,
          Invocation.getter(#bottomNavigationCubit),
        ),
      ) as _i2.CoreCubit);
  @override
  _i3.SettingsService get settingsService => (super.noSuchMethod(
        Invocation.getter(#settingsService),
        returnValue: _FakeSettingsService_1(
          this,
          Invocation.getter(#settingsService),
        ),
        returnValueForMissingStub: _FakeSettingsService_1(
          this,
          Invocation.getter(#settingsService),
        ),
      ) as _i3.SettingsService);
  @override
  _i4.LoopModeService get loopModeService => (super.noSuchMethod(
        Invocation.getter(#loopModeService),
        returnValue: _FakeLoopModeService_2(
          this,
          Invocation.getter(#loopModeService),
        ),
        returnValueForMissingStub: _FakeLoopModeService_2(
          this,
          Invocation.getter(#loopModeService),
        ),
      ) as _i4.LoopModeService);
  @override
  _i5.LocalizationService get localizationService => (super.noSuchMethod(
        Invocation.getter(#localizationService),
        returnValue: _FakeLocalizationService_3(
          this,
          Invocation.getter(#localizationService),
        ),
        returnValueForMissingStub: _FakeLocalizationService_3(
          this,
          Invocation.getter(#localizationService),
        ),
      ) as _i5.LocalizationService);
  @override
  _i6.CMSService get cmsService => (super.noSuchMethod(
        Invocation.getter(#cmsService),
        returnValue: _FakeCMSService_4(
          this,
          Invocation.getter(#cmsService),
        ),
        returnValueForMissingStub: _FakeCMSService_4(
          this,
          Invocation.getter(#cmsService),
        ),
      ) as _i6.CMSService);
  @override
  _i7.SettingsState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _FakeSettingsState_5(
          this,
          Invocation.getter(#state),
        ),
        returnValueForMissingStub: _FakeSettingsState_5(
          this,
          Invocation.getter(#state),
        ),
      ) as _i7.SettingsState);
  @override
  _i9.Stream<_i7.SettingsState> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i9.Stream<_i7.SettingsState>.empty(),
        returnValueForMissingStub: _i9.Stream<_i7.SettingsState>.empty(),
      ) as _i9.Stream<_i7.SettingsState>);
  @override
  bool get isClosed => (super.noSuchMethod(
        Invocation.getter(#isClosed),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  dynamic getPage(
    String? route,
    String? pageTitle,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #getPage,
          [
            route,
            pageTitle,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  dynamic onLoopModeEnabledChange(bool? value) => super.noSuchMethod(
        Invocation.method(
          #onLoopModeEnabledChange,
          [value],
        ),
        returnValueForMissingStub: null,
      );
  @override
  dynamic onLoopModeNetNeutralityChange(bool? value) => super.noSuchMethod(
        Invocation.method(
          #onLoopModeNetNeutralityChange,
          [value],
        ),
        returnValueForMissingStub: null,
      );
  @override
  dynamic onPersistentClientUuidChange(bool? value) => super.noSuchMethod(
        Invocation.method(
          #onPersistentClientUuidChange,
          [value],
        ),
        returnValueForMissingStub: null,
      );
  @override
  dynamic onAnalyticsChange(bool? value) => super.noSuchMethod(
        Invocation.method(
          #onAnalyticsChange,
          [value],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onLoopModeDistanceMetersChange(int? meters) => super.noSuchMethod(
        Invocation.method(
          #onLoopModeDistanceMetersChange,
          [meters],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onLoopModeMeasurementCountChange(int? count) => super.noSuchMethod(
        Invocation.method(
          #onLoopModeMeasurementCountChange,
          [count],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void setLanguage(_i10.Language? language) => super.noSuchMethod(
        Invocation.method(
          #setLanguage,
          [language],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void clearUiErrors() => super.noSuchMethod(
        Invocation.method(
          #clearUiErrors,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  dynamic onValidationSucceeded(
    _i7.LoopModeCheckedFieldType? fieldType,
    int? value,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #onValidationSucceeded,
          [
            fieldType,
            value,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onValidationFailed(_i7.LoopModeCheckedFieldType? fieldType) =>
      super.noSuchMethod(
        Invocation.method(
          #onValidationFailed,
          [fieldType],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void emit(_i7.SettingsState? state) => super.noSuchMethod(
        Invocation.method(
          #emit,
          [state],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onChange(_i11.Change<_i7.SettingsState>? change) => super.noSuchMethod(
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
  @override
  _i9.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
}
