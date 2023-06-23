import 'package:wakelock/wakelock.dart';

class WakelockWrapper {
  enable() => Wakelock.enable();
  disable() => Wakelock.disable();
}