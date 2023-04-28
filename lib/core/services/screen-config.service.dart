import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/models/impl/screen-config-impl.dart';
import 'package:nt_flutter_standalone/core/models/screen-config.dart';

class ScreenConfigService {
  static ScreenConfigService? _instance;
  late final ScreenConfig config;

  factory ScreenConfigService() {
    if (_instance == null) {
      _instance = ScreenConfigService._internal(ScreenConfigImpl());
    }
    return _instance!;
  }

  ScreenConfigService._internal(ScreenConfig config) {
    this.config = config;
  }

  Widget getScreenByIndex(int index) {
    if (index > (this.config.bottomBarScreens.length - 1)) {
      return this.config.bottomBarScreens.last;
    } else if (index < 0) {
      return this.config.bottomBarScreens.first;
    } else {
      return this.config.bottomBarScreens[index];
    }
  }

  int getScreenIndexByType<T extends Widget>() => this
      .config
      .bottomBarScreens
      .indexWhere((element) => element.runtimeType == T);
}
