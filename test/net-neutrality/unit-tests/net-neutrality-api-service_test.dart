import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-list-factory.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-result.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-settings-response.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-api.service.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

final String _openTestUuid = 'openTestUuid';
final String _clientUuid = 'clientUuid';
final DioError _dioError = MockDioError();
final ErrorHandler _errorHandler = MockErrorHandler();
final _settingsJson = jsonDecode(
  File('test/net-neutrality/unit-tests/data/net-neutrality-settings.json')
      .readAsStringSync(),
);
final _settings = NetNeutralitySettingsResponse.fromJson(_settingsJson);
final _historyJson = jsonDecode(
    File('test/net-neutrality/unit-tests/data/net-neutrality-history.json')
        .readAsStringSync());
final _history = NetNeutralityHistoryListFactory.parseHistoryResponse(
  _historyJson,
);
final _service = NetNeutralityApiService(testing: true);

final _results = NetNeutralityResult();

void main() {
  setUpAll(() async {
    TestingServiceLocator.registerInstances();
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.clientUuid))
        .thenReturn(_clientUuid);
  });

  group('Net neutrality API service', () {
    test('getSettings', () async {
      when(GetIt.I.get<Dio>().get('/netNeutralityTestRequest')).thenAnswer(
        (realInvocation) async => Response(
          requestOptions: RequestOptions(path: '/netNeutralityTestRequest'),
          statusCode: 200,
          data: _settingsJson,
        ),
      );
      final settings = await _service.getSettings();
      expect(settings.toString(), _settings.toString());
    });

    test('getSettings with error', () async {
      when(GetIt.I.get<Dio>().get('/netNeutralityTestRequest')).thenAnswer(
        (realInvocation) async => throw _dioError,
      );
      final settings = await _service.getSettings(errorHandler: _errorHandler);
      verify(_errorHandler.process(_dioError));
      expect(settings, null);
    });

     test('postResults', () async {
      when(GetIt.I
              .get<Dio>()
              .post('/netNeutralityResult', data: anyNamed('data')))
          .thenAnswer(
        (realInvocation) async => Response(
          requestOptions: RequestOptions(path: '/netNeutralityResult'),
          statusCode: 200,
          data: _settingsJson,
        ),
      );
      await _service.postResults(results: _results);
      verify(GetIt.I
          .get<Dio>()
          .post('/netNeutralityResult', data: anyNamed('data')));
    });

    test('postResults with error', () async {
      when(GetIt.I
              .get<Dio>()
              .post('/netNeutralityResult', data: anyNamed('data')))
          .thenAnswer(
        (realInvocation) async => throw _dioError,
      );
      await _service.postResults(results: _results, errorHandler: _errorHandler);
      verify(_errorHandler.process(_dioError));
    });

    test('getHistory', () async {
      when(GetIt.I.get<Dio>().get(
              '/reports/netNeutralityResult/history?sort=measurementDate,desc&uuid=$_clientUuid&openTestUuid=$_openTestUuid'))
          .thenAnswer(
        (realInvocation) async => Response<Map<String, dynamic>>(
          requestOptions:
              RequestOptions(path: '/reports/netNeutralityResult/history'),
          statusCode: 200,
          data: _historyJson,
        ),
      );
      final history = await _service.getHistory(_openTestUuid);
      expect(history.toString(), _history.toString());
    });

    test('getHistory with error', () async {
      when(GetIt.I.get<Dio>().get(
              '/reports/netNeutralityResult/history?sort=measurementDate,desc&uuid=$_clientUuid&openTestUuid=$_openTestUuid'))
          .thenAnswer(
        (realInvocation) async => throw _dioError,
      );
      final history =
          await _service.getHistory(_openTestUuid, errorHandler: _errorHandler);
      verify(_errorHandler.process(_dioError));
      expect(history, null);
    });
  });
}
