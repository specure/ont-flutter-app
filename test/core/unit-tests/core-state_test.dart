import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nt_flutter_standalone/core/store/core.state.dart';

void main() {
  test("CoreState test", () {
    final int defaultIndex = 0;
    final int intMaxValue = 4294967296;
    final int index = Random().nextInt(intMaxValue);

    expect(CoreState().currentScreen, defaultIndex);
    expect(CoreState(currentScreen: index).currentScreen, index);
  });
}
