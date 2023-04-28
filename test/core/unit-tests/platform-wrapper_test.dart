import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';

void main() {
  test("PlatformWrapper test", () {
    final platformWrapper = PlatformWrapper();
    expect(platformWrapper.isIOS, Platform.isIOS);
    expect(platformWrapper.isAndroid, Platform.isAndroid);
    expect(platformWrapper.localeName, Platform.localeName);
  });
}
