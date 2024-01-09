import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurements.api.service.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

final _measurementResult = MeasurementResult(
  bytesDownload: 1000,
  bytesUpload: 1000,
  clientName: 'RMBT',
  localIpAddress: '192.168.0.0',
  nsecDownload: 1,
  nsecUpload: 1,
  pingShortest: 10,
  serverIpAddress: '',
  speedDownload: 1000,
  speedUpload: 1000,
  testNumThreads: 3,
  testPortRemote: 443,
  testToken: 'token',
  totalDownloadBytes: 1000,
  totalUploadBytes: 1000,
  uuid: 'uuid',
);
final _emptyMeasurementResult =
    MeasurementResult.fromPlatformChannelArguments({});
final DioException _dioError = MockDioError();
final ErrorHandler _errorHandler = MockErrorHandler();
late final Dio _dio;

@GenerateMocks([Dio])
void main() {
  setUpAll(() {
    TestingServiceLocator.registerInstances();
    _setUpStubs();
  });

  group('Test measurements API', () {
    test('sends results successfully', () async {
      final result = await MeasurementsApiService(testing: true)
          .sendMeasurementResults(_measurementResult);
      expect(result, isA<Response>());
      expect((result as Response).statusCode, 200);
    });
    test('handles error if result was not sent successfully', () async {
      final result = await MeasurementsApiService(testing: true)
          .sendMeasurementResults(_emptyMeasurementResult,
              errorHandler: _errorHandler);
      expect(result, isNull);
      verify(_errorHandler.process(_dioError)).called(1);
    });
    test('returns list of servers if the request was successful', () async {
      final result = await MeasurementsApiService(testing: true)
          .getMeasurementServersForCurrentFlavor();
      expect(result, isA<List<MeasurementServer>>());
      expect(result.length, 2);
      expect(result.first.id, 3);
    });
    test('returns an empty list if the request was not successful', () async {
      when(_dio.get(NTUrls.csMeasurementServerRoute))
          .thenAnswer((_) async => throw _dioError);
      final result = await MeasurementsApiService(testing: true)
          .getMeasurementServersForCurrentFlavor(errorHandler: _errorHandler);
      expect(result, isA<List<MeasurementServer>>());
      expect(result, isEmpty);
      verify(_errorHandler.process(_dioError)).called(1);
    });
  });
}

_setUpStubs() {
  _dio = GetIt.I.get<Dio>();
  when(_dio.post(
    NTUrls.csResultRoute,
    data: _measurementResult.toJson(),
  )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: NTUrls.csResultRoute),
        statusCode: 200,
      ));
  when(_dio.post(
    NTUrls.csResultRoute,
    data: _emptyMeasurementResult.toJson(),
  )).thenAnswer((_) async => throw _dioError);
  when(_dio.options).thenReturn(BaseOptions());
  when(_dio.get(NTUrls.csMeasurementServerRoute))
      .thenAnswer((_) async => Response(
            requestOptions:
                RequestOptions(path: NTUrls.csMeasurementServerRoute),
            statusCode: 200,
            data: [
              {
                'id': 1,
                'uuid': 'uuid',
                'name': 'SERV',
                'webAddress': 'server1.example.net',
                'distance': 456789,
                'serverTypeDetails': [
                  {'serverType': 'RMBTws'}
                ]
              },
              {
                'id': 2,
                'uuid': 'uuid',
                'name': 'SERV2',
                'webAddress': 'server2.example.net',
                'distance': 123456,
                'serverTypeDetails': [
                  {'serverType': 'RMBT'}
                ]
              },
              {
                'id': 3,
                'uuid': 'uuid',
                'name': 'SERV3',
                'webAddress': 'server3.example.net',
                'distance': 1000,
                'serverTypeDetails': [
                  {'serverType': 'RMBT'}
                ]
              },
            ],
          ));

  when(_dio.post(NTUrls.csIpRoute)).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: NTUrls.csIpRoute),
        statusCode: 200,
        data: {'ip': '192.168.0.0'},
      ));
  when(_errorHandler.process(_dioError)).thenReturn(null);
}
