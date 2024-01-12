import 'package:wakelock_plus/wakelock_plus.dart';

class WakelockWrapper {
  enable() => WakelockPlus.enable();
  disable() => WakelockPlus.disable();
}
