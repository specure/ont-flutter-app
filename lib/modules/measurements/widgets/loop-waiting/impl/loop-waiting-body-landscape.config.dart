import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/loop-mode-execution-warning.dart';

import '../loop-waiting-body.config.dart';

class LoopWaitingBodyLandscapeConfig extends LoopWaitingBodyConfig {
  LoopWaitingBodyLandscapeConfig(MeasurementsState state) : super(state: state);

  static const double horizontalPadding = 28;

  @override
  Widget getContent() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: getMedianResults(horizontalPadding),
                  ),
                ),
                Expanded(child: SingleChildScrollView(child: getResults()))
              ],
            ),
          ),
          LoopModeExecutionWarning(),
        ],
      ),
    );
  }
}
