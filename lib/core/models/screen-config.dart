import 'package:flutter/widgets.dart';

abstract class ScreenConfig {
  List<Widget> get bottomBarScreens => [];
  List<BottomNavigationBarItem> getBottomBarItems(int currentIndex);
}
