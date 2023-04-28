import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/models/settings.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/settings/services/settings.service.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

final _service = SettingsService(testing: true);
final DioError _dioError = MockDioError();
final ErrorHandler _errorHandler = MockErrorHandler();
final _uuid = 'uuid';
final _path = '***REMOVED***';

void main() {
  setUpAll(() {
    TestingServiceLocator.registerInstances();
    _setUpStubs();
  });

  group('Settings service', () {
    test('saves and returns client uuid if it is persisted', () async {
      when(GetIt.I
              .get<SharedPreferencesWrapper>()
              .getBool(StorageKeys.persistentClientUuidEnabled))
          .thenReturn(true);
      when(GetIt.I.get<Dio>().post(_path, data: _getSettings(_uuid)))
          .thenAnswer((realInvocation) async => Response(
                requestOptions: RequestOptions(path: _path),
                statusCode: 200,
                data: {
                  'settings': [
                    {'uuid': _uuid}
                  ]
                },
              ));
      final uuid = await _service.saveClientUuidAndSettings();
      expect(uuid, _uuid);
      verify(GetIt.I.get<Dio>().post(_path, data: _getSettings(_uuid)));
      verify(GetIt.I
          .get<SharedPreferencesWrapper>()
          .setString(StorageKeys.clientUuid, _uuid));
    });
    test('does not save client uuid if it is not persisted', () async {
      when(GetIt.I
              .get<SharedPreferencesWrapper>()
              .getBool(StorageKeys.persistentClientUuidEnabled))
          .thenReturn(false);
      when(GetIt.I.get<Dio>().post(_path, data: _getSettings(null)))
          .thenAnswer((realInvocation) async => Response(
                requestOptions: RequestOptions(path: _path),
                statusCode: 200,
                data: {
                  'settings': [
                    {'uuid': _uuid}
                  ]
                },
              ));
      final uuid = await _service.saveClientUuidAndSettings();
      expect(uuid, _uuid);
      verify(GetIt.I.get<Dio>().post(_path, data: _getSettings(null)));
      verifyNever(GetIt.I
          .get<SharedPreferencesWrapper>()
          .setString(StorageKeys.clientUuid, _uuid));
    });
    test('does not save client uuid and returns null if the request throws',
        () async {
      when(GetIt.I
              .get<SharedPreferencesWrapper>()
              .getBool(StorageKeys.persistentClientUuidEnabled))
          .thenReturn(true);
      when(GetIt.I.get<Dio>().post(_path, data: _getSettings(_uuid)))
          .thenAnswer((realInvocation) async => throw _dioError);
      final uuid =
          await _service.saveClientUuidAndSettings(errorHandler: _errorHandler);
      expect(uuid, isNull);
      verify(_errorHandler.process(_dioError));
      verifyNever(GetIt.I
          .get<SharedPreferencesWrapper>()
          .setString(StorageKeys.clientUuid, _uuid));
    });
    test('does not save client uuid if it is null', () async {
      when(GetIt.I
              .get<SharedPreferencesWrapper>()
              .getBool(StorageKeys.persistentClientUuidEnabled))
          .thenReturn(true);
      when(GetIt.I.get<Dio>().post(_path, data: _getSettings(_uuid)))
          .thenAnswer((realInvocation) async => Response(
                requestOptions: RequestOptions(path: _path),
                statusCode: 200,
                data: {
                  'settings': [
                    {'uuid': null}
                  ]
                },
              ));
      final uuid = await _service.saveClientUuidAndSettings();
      expect(uuid, isNull);
      verify(GetIt.I.get<Dio>().post(_path, data: _getSettings(_uuid)));
      verifyNever(GetIt.I
          .get<SharedPreferencesWrapper>()
          .setString(StorageKeys.clientUuid, _uuid));
    });
  });
}

_getSettings(String? uuid) =>
    Settings(uuid: uuid, termsAndConditionsAccepted: true).toJson()
      ..removeWhere((key, value) => value == null);

_setUpStubs() {
  when(GetIt.I
      .get<SharedPreferencesWrapper>()
      .getBool(StorageKeys.analyticsEnabled))
      .thenReturn(true);
  when(GetIt.I.get<SharedPreferencesWrapper>().clientUuid)
      .thenAnswer((_) async => _uuid);
  when(GetIt.I
          .get<SharedPreferencesWrapper>()
          .setString(StorageKeys.clientUuid, _uuid))
      .thenAnswer((realInvocation) async => null);
  when(_errorHandler.process(_dioError)).thenReturn(null);
}
