import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/services/api/history.api.service.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-results.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

final String _selectedLocaleTag = 'sr-Latn-rs';

final _errorHandler = MockErrorHandler();
final _dioError = MockDioError();
final _historyJson = {
  'measurements': {
    'content': [
      {
        'tests': [
          {
            'test_uuid': 'uuid',
            'speed_upload': 100,
            'speed_download': 100,
            'ping': 10,
            'measurement_date': '2020-01-01T15:00:00.000Z',
            'userExperienceMetrics': [],
          }
        ]
      }
    ],
    'totalElements': 1,
    'totalPages': 1,
    'last': true,
  }
};

final _historyToJson = {
  'content': [
    MeasurementHistoryResults([
      MeasurementHistoryResult(
          testUuid: 'uuid',
          uploadKbps: 100,
          downloadKbps: 100,
          pingMs: 10,
          measurementDate: '2020-01-01T15:00:00.000Z',
          userExperienceMetrics: [])
    ]),
  ],
  'totalElements': 1,
  'totalPages': 1,
  'last': true,
};

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    _setUpStubs();
  });

  group('HistoryApiService', () {
    test('returns a list when the request is successfull', () async {
      final history =
          await HistoryApiService(testing: true).getSpeedHistory(1, null, null);
      expect(history?.content, [
        MeasurementHistoryResults([
          MeasurementHistoryResult(
            testUuid: 'uuid',
            uploadKbps: 100,
            downloadKbps: 100,
            pingMs: 10,
            measurementDate: '2020-01-01T15:00:00.000Z',
            userExperienceMetrics: [],
          ),
        ])
      ]);
      var json = history?.toJson();
      expect(json, _historyToJson);
    });

    test('returns null and calls error handler on DioException', () async {
      final history = await HistoryApiService(testing: true)
          .getSpeedHistory(2, null, null, errorHandler: _errorHandler);
      expect(history?.content, null);
      verify(_errorHandler.process(_dioError));
    });
  });
}

_setUpStubs() {
  final sharedPreferences = GetIt.I.get<SharedPreferencesWrapper>();
  final dio = GetIt.I.get<Dio>();
  when(sharedPreferences.clientUuid).thenAnswer((_) async => 'uuid');
  when(dio.post(
    '${NTUrls.csSpeedHistoryRoute}?page=1&size=100&sort=measurementDate,desc',
    data: {'uuid': 'uuid', 'devices': null, 'network_types': null},
  )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: NTUrls.csSpeedHistoryRoute),
        statusCode: 200,
        data: _historyJson,
      ));
  when(_errorHandler.process(_dioError)).thenReturn(null);
  when(dio.post(
    '${NTUrls.csSpeedHistoryRoute}?page=2&size=100&sort=measurementDate,desc',
    data: {'uuid': 'uuid', 'devices': null, 'network_types': null},
  )).thenThrow(_dioError);
  when(GetIt.I.get<SharedPreferencesWrapper>().init())
      .thenAnswer((_) async => null);
  when(GetIt.I
          .get<SharedPreferencesWrapper>()
          .getString(StorageKeys.selectedLocaleTag))
      .thenReturn(_selectedLocaleTag);
}
