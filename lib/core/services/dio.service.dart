import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/api-errors.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/wrappers/internet-address.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';

abstract class DioService {
  final Dio dio = GetIt.I.get<Dio>();
  late final bool testing;

  DioService({
    bool testing = false,
    bool enableLogging = true,
    String baseUrl = '',
    Map<String, dynamic>? headers,
  }) {
    this.testing = testing;
    if (!testing) {
      if (enableLogging) {
        dio.interceptors.add(LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ));
        dio.interceptors.add(ErrorInterceptor());
        dio.interceptors.add(StopwatchInterceptor());
      }
      dio.options.baseUrl = baseUrl.isNotEmpty
          ? baseUrl
          : "https://${Environment.controlServerUrl}";
      dio.options.headers = headers != null
          ? headers
          : {'X-Nettest-Client': Environment.appSuffix.replaceAll('.', '')};
      dio.options.validateStatus = (int? status) {
        return status != null;
      };
    }
  }

  Dio dioInstanceForUrl(String url) {
    if (testing) {
      return GetIt.I.get<Dio>();
    }
    final Dio localDio = Dio(dio.options);
    localDio.options.baseUrl = url;
    return localDio;
  }
}

class StopwatchInterceptor extends Interceptor {
  DateTime? requestSentAt;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    requestSentAt = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (requestSentAt != null) {
      final networkTime = (DateTime.now().millisecondsSinceEpoch -
              requestSentAt!.millisecondsSinceEpoch) /
          1000;
      print("*** Request to ${response.realUri} took ${networkTime}s ***");
    }
    super.onResponse(response, handler);
  }
}

class ErrorInterceptor extends Interceptor {
  static const lookupHost = 'example.com';
  final bool testing;

  ErrorInterceptor({this.testing = false});

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    DioException newErr = err;
    if (err.type != DioExceptionType.badResponse) {
      try {
        await GetIt.I
            .get<InternetAddressWrapper>()
            .lookup(ErrorInterceptor.lookupHost);
      } on SocketException catch (_) {
        newErr = err.copyWith(message: ApiErrors.noInternetConnection);
        GetIt.I.get<MeasurementsBloc>().add(
              GetNetworkInfo(connectivity: ConnectivityResult.none),
            );
      }
    }
    if (!testing) super.onError(newErr, handler);
  }
}
