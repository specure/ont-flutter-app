import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class MeasurementError implements Exception {
  static MeasurementError get pingFailed => MeasurementError("Ping failed");

  late final String message;

  MeasurementError([String? message]) {
    if (message != null && message.isNotEmpty) {
      this.message = message;
    } else {
      this.message = "Unknown error".translated;
    }
  }

  @override
  String toString() => message;
}
