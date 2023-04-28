import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/loop-mode.button.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';

class LoopModeBadge extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
        bloc: GetIt.I.get<SettingsCubit>(),
        builder: (context, state) => ConditionalContent(
            conditional: state.isLoopModeActivated(),
            truthyBuilder: () {
              return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: LoopModeButton(enabled: true, width: 24, iconSize: 16)
              );
            },
            falsyBuilder: () {
              return Padding(
                padding: EdgeInsets.only(right: 12),
              );
            }),
    );
  }
}
