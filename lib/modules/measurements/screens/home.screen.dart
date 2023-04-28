import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/services/screen-config.service.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/store/core.state.dart';
import 'package:nt_flutter_standalone/core/widgets/bottom-navigation.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';

class HomeScreen extends StatelessWidget {
  static const route = 'measurements/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _initializeAnalytics();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      body: BlocBuilder<CoreCubit, CoreState>(
        builder: (context, state) =>
            ScreenConfigService().getScreenByIndex(state.currentScreen),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  void _initializeAnalytics() {
    GetIt.I.get<SettingsCubit>().init();
  }
}
