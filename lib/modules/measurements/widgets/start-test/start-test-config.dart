import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/loop-mode.button.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/loop-mode-agreement.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';

abstract class StartTestConfig {
  StartTestConfig({required this.state});

  late final MeasurementsState state;
  final Axis measurementServerMainAxis = Axis.vertical;

  Widget get loopModeButton {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: GetIt.I.get<SettingsCubit>(),
      builder: (context, state) => ConditionalContent(
          conditional: (state.loopModeFeatureEnabled),
          truthyBuilder: () {
            return LoopModeButton(
                title: "Loop mode",
                enabled: state.loopModeEnabled,
                onPressed: () {
                  if (!state.loopModeEnabled) {
                    GetIt.I
                        .get<NavigationService>()
                        .pushNamed(LoopModeAgreementScreen.route);
                  } else {
                    GetIt.I.get<SettingsCubit>().onLoopModeEnabledChange(false);
                  }
                });
          }),
    );
  }

  Widget get content;
}
