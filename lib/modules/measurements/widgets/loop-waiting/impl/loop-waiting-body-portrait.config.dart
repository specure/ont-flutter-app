import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/loop-mode-execution-warning.dart';

import '../loop-waiting-body.config.dart';

class LoopWaitingBodyPortraitConfig extends LoopWaitingBodyConfig {
  LoopWaitingBodyPortraitConfig(MeasurementsState state) : super(state: state);

  static const double horizontalPadding = 28;

  @override
  Widget getContent() {
    return SafeArea(
        child: Column(children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [getMedianResults(horizontalPadding), getResults()],
          ),
        ),
      ),
      LoopModeExecutionWarning(),
    ]));
  }
}
