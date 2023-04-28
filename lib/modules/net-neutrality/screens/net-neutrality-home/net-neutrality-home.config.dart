import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/gradient-button.widget.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-phase.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';

abstract class NetNeutralityHomeConfig {
  NetNeutralityHomeConfig({required this.state});

  late final NetNeutralityState state;

  Widget get content;

  Widget get runButton {
    return GradientButton(
      child: Text(
        "Net Neutrality Measurement".translated,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: NTDimensions.textM,
        ),
      ),
      onPressed: () {
        if (state.phase == NetNeutralityPhase.none) {
          GetIt.I.get<NetNeutralityCubit>().startMeasurement();
        }
      },
    );
  }
}
