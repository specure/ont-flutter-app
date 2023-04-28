import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/services/screen-config.service.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/store/core.state.dart';

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoreCubit, CoreState>(
      builder: (context, state) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black,
        iconSize: 24,
        backgroundColor: Colors.white,
        selectedItemColor: NTColors.primary,
        items:
            ScreenConfigService().config.getBottomBarItems(state.currentScreen),
        currentIndex: (state.currentScreen + 1) > ScreenConfigService().config.getBottomBarItems(state.currentScreen).length ? ScreenConfigService().config.getBottomBarItems(state.currentScreen).length - 1 : state.currentScreen,
        onTap: context.read<CoreCubit>().onItemTap,
      ),
    );
  }
}
