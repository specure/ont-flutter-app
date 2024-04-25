import 'package:nt_flutter_standalone/core/constants/api-errors.dart';

class MeasurementError implements Exception {
  static MeasurementError get pingFailed =>
      MeasurementError(ApiErrors.pingFailed);

  late final String message;

  MeasurementError([String? message]) {
    if (message != null && message.isNotEmpty) {
      this.message = message;
    } else {
      this.message = ApiErrors.noConnectionToMS;
    }
  }

  @override
  String toString() => message;
}
