import 'package:intl/intl.dart';

extension SpeedRounding on double {
  String roundSpeed() {
    double speedTmpMbps = this / 1000;
    final formatter = NumberFormat();
    formatter.minimumFractionDigits = 0;
    if (speedTmpMbps >= 100) {
      formatter.maximumFractionDigits = 0;
    } else if (speedTmpMbps >= 10) {
      formatter.maximumFractionDigits = 1;
    } else if ((speedTmpMbps >= 1) && (this > 999)) {
      formatter.maximumFractionDigits = 2;
    } else {
      formatter.maximumFractionDigits = 3;
    }
    return formatter.format(speedTmpMbps);
  }
}
