import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/screens/history.screen.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-home/net-neutrality-home.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/start-test/start-test.widget.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/settings.screen.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/models/screen-config.dart';

class ScreenConfigImpl implements ScreenConfig {
  @override
  List<Widget> get bottomBarScreens {
    var isNetNeutralityTestsEnabled = GetIt.I
            .get<SharedPreferencesWrapper>()
            .getBool(StorageKeys.netNeutralityTestsEnabled) ??
        false;
    if (isNetNeutralityTestsEnabled) {
      return [
        StartTestWidget(),
        NetNeutralityHomeScreen(),
        HistoryScreen(),
        SettingsScreen(),
      ];
    } else {
      return [
        StartTestWidget(),
        HistoryScreen(),
        SettingsScreen(),
      ];
    }
  }

  @override
  List<BottomNavigationBarItem> getBottomBarItems(int currentIndex) {
    var isNetNeutralityTestsEnabled = GetIt.I
            .get<SharedPreferencesWrapper>()
            .getBool(StorageKeys.netNeutralityTestsEnabled) ??
        false;
    var bottomNavigationItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: currentIndex == 0
            ? SvgPicture.asset('config/${Environment.appSuffix}/icons/test.svg')
            : SvgPicture.asset('assets/icons/test.svg'),
        label: 'Speed'.translated,
      ),
    ];

    if (isNetNeutralityTestsEnabled) {
      bottomNavigationItems.add(
        BottomNavigationBarItem(
          icon: currentIndex == 1
              ? SvgPicture.asset(
                  'config/${Environment.appSuffix}/icons/test.svg')
              : SvgPicture.asset('assets/icons/test.svg'),
          label: 'Neutrality'.translated,
        ),
      );
    }

    bottomNavigationItems.addAll([
      BottomNavigationBarItem(
        icon: Icon(Icons.format_list_bulleted),
        label: 'Results'.translated,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings'.translated,
      ),
    ]);
    return bottomNavigationItems;
  }
}
