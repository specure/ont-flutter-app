import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/speed-curve.item.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/services/measurement-result.service.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

const String _correctUuid = 'uuid';
const String _incorrectUuid = 'incorrectUuid';
const double _speedUpload = 100;
const double _speedDownload = 100;
const double _ping = 10;
const String _date = '2020-01-01T15:00:00.000Z';
const int _bytes = 1000;
const int _time = 1000;

final Map<String, dynamic> _historyResultJSON = {
  'test_uuid': _correctUuid,
  'speed_upload': _speedUpload,
  'speed_download': _speedDownload,
  'ping': _ping,
  'measurement_date': _date,
  'userExperienceMetrics': [],
};
final Map<String, dynamic> _graphsResultJSON = {
  'speed_curve': {
    'download': [
      {'bytes_total': _bytes, 'time_elapsed': _time},
      {'bytes_total': _bytes * 2, 'time_elapsed': _time + 500},
      {'bytes_total': _bytes * 3, 'time_elapsed': _time + 1000}
    ],
    'upload': [
      {'bytes_total': _bytes, 'time_elapsed': _time},
      {'bytes_total': _bytes * 2, 'time_elapsed': _time + 100},
      {'bytes_total': _bytes * 3, 'time_elapsed': _time + 200}
    ],
  }
};

final MeasurementResultService service =
    MeasurementResultService(testing: true);

final ErrorHandler _errorHandler = MockErrorHandler();
final DioException _dioError = MockDioError();
final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUpAll(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    _setUpStubs();
  });

  group('Test measurement result service', () {
    test('returns history when history request is successful', () async {
      final result = await service.getMeasurementHistoryResult(_correctUuid);
      expect(result, isA<MeasurementHistoryResult>());
      expect(result, MeasurementHistoryResult.fromJson(_historyResultJSON));
    });
    test('returns null and calls error handler when history request fails',
        () async {
      final result = await service.getMeasurementHistoryResult(_incorrectUuid,
          errorHandler: _errorHandler);
      expect(result, isNull);
      verify(_errorHandler.process(_dioError)).called(1);
    });
    test('returns graphs when graphs request is successful', () async {
      final result = await service.getMeasurementSpeedGraphs(_correctUuid);
      expect(result, isA<Map<String, List<SpeedCurveItem>>>());
      expect(result!['download'], [
        SpeedCurveItem(bytes: _bytes, time: _time),
        SpeedCurveItem(bytes: _bytes * 2, time: _time + 500),
        SpeedCurveItem(bytes: _bytes * 3, time: _time + 1000),
      ]);
      expect(result['upload'], [
        SpeedCurveItem(bytes: _bytes, time: _time),
        SpeedCurveItem(bytes: _bytes * 2, time: _time + 100),
        SpeedCurveItem(bytes: _bytes * 3, time: _time + 200),
      ]);
    });
    test('returns null and calls error handler when graphs request fails',
        () async {
      final result = await service.getMeasurementSpeedGraphs(_incorrectUuid,
          errorHandler: _errorHandler);
      expect(result, isNull);
      verify(_errorHandler.process(_dioError)).called(1);
    });
    test('returns history with speed curves', () async {
      final result = await service.getResultWithSpeedCurves(_correctUuid);
      expect(result, isA<MeasurementHistoryResult>());
      expect(result!.downloadSpeedDetails, [1]);
      expect(result.uploadSpeedDetails, [1]);
    });
  });
}

void _setUpStubs() {
  final dio = GetIt.I.get<Dio>();
  when(dio.get('${NTUrls.csResultsRoute}/$_incorrectUuid'))
      .thenAnswer((_) async => throw _dioError);
  when(dio.get('${NTUrls.csResultsRoute}/$_correctUuid'))
      .thenAnswer((_) async => Response(
            requestOptions:
                RequestOptions(path: '${NTUrls.csResultsRoute}/$_correctUuid'),
            statusCode: 200,
            data: _historyResultJSON,
          ));

  when(dio.get('${NTUrls.csGraphsRoute}/$_incorrectUuid'))
      .thenAnswer((_) async => throw _dioError);
  when(dio.get('${NTUrls.csGraphsRoute}/$_correctUuid'))
      .thenAnswer((_) async => Response(
            requestOptions:
                RequestOptions(path: '${NTUrls.csGraphsRoute}/$_correctUuid'),
            statusCode: 200,
            data: _graphsResultJSON,
          ));

  when(_errorHandler.process(_dioError)).thenReturn(null);
  when(GetIt.I.get<SharedPreferencesWrapper>().init())
      .thenAnswer((_) async => null);
  when(GetIt.I
          .get<SharedPreferencesWrapper>()
          .getString(StorageKeys.selectedLocaleTag))
      .thenReturn(_selectedLocaleTag);
}
