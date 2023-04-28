import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/mixins/error-handling-state.mixin.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-home/impl/net-neutrality-home-landscape.config.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-home/impl/net-neutrality-home-portrait.config.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-home/net-neutrality-home.config.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';

class NetNeutralityHomeScreen extends StatefulWidget {
  @override
  State<NetNeutralityHomeScreen> createState() =>
      _NetNeutralityHomeScreenState();
}

class _NetNeutralityHomeScreenState extends State<NetNeutralityHomeScreen>
    with ErrorHandlingState {
  @override
  void initState() {
    GetIt.I.get<NetNeutralityCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NetNeutralityCubit, NetNeutralityState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          current.errorMessage!.isNotEmpty &&
          previous.errorMessage != current.errorMessage,
      listener: (context, state) => handleError(
        context,
        state,
        setState: setState,
        onRetry: () {
          GetIt.I.get<NetNeutralityCubit>().restartMeasurement();
        },
        onFinish: () {
          GetIt.I.get<NetNeutralityCubit>().stopMeasurement();
        },
      ),
      builder: (context, state) =>
          NTOrientationBuilder<NetNeutralityHomeConfig>(
        portraitConfig: NetNeutralityHomePortraitConfig(state: state),
        landscapeConfig: NetNeutralityHomeLandscapeConfig(state: state),
        builder: (config) => Scaffold(
          appBar: NTAppBar(height: 0),
          body: config.content,
        ),
      ),
    );
  }
}
