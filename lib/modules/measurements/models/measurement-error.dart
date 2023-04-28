import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class MeasurementError implements Exception {
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
