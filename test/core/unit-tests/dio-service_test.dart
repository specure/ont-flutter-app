import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/api-errors.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/internet-address.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';

import '../../di/service-locator.dart';
import 'dio-service_test.mocks.dart';

final _bloc = MockMeasurementsBlocCalls();

@GenerateMocks([
  InternetAddressWrapper
], customMocks: [
  MockSpec<MeasurementsBloc>(
    as: #MockMeasurementsBlocCalls,
    onMissingStub: OnMissingStub.returnDefault,
  ),
])
void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    GetIt.I.registerLazySingleton<MeasurementsBloc>(() => _bloc);
  });

  group('DioService', () {
    test('error interceptor', () async {
      final interceptor = ErrorInterceptor(testing: true);
      final err = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
        error: SocketException.closed(),
      );
      final handler = ErrorInterceptorHandler();
      when(GetIt.I
              .get<InternetAddressWrapper>()
              .lookup(ErrorInterceptor.lookupHost))
          .thenAnswer((realInvocation) async => throw SocketException.closed());
      await interceptor.onError(err, handler);
      expect(interceptor.newErr!.message, ApiErrors.noInternetConnection);
      verify(_bloc.add(any)).called(1);
    });
  });
}
