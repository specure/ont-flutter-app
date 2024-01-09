import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

mixin ErrorState {
  ConnectivityResult connectivity = ConnectivityResult.none;
  Exception? error;
  String? get errorMessage {
    if (error == null) {
      return null;
    }
    if (error is DioException) {
      final dioError = error as DioException;
      try {
        final String? message = dioError.response?.data?['message'];
        if (message != null && message.isNotEmpty) {
          return message;
        }
        throw dioError;
      } catch (_) {
        if (dioError.message != null && dioError.message!.isNotEmpty) {
          return dioError.message;
        }
        return dioError.toString();
      }
    }
    return error.toString();
  }
}
