import 'package:flutter/widgets.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-body/measurement-body.config.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-box.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-chart.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-loop-next-test-info.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-median-box.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-progress-bar.widget.dart';

class MeasurementBodyPortraitConfig extends MeasurementBodyConfig {
  MeasurementBodyPortraitConfig(MeasurementsState state) : super(state: state);

  @override
  final Axis measurementServerMainAxis = Axis.vertical;

  Widget getContent() => Padding(
        padding: EdgeInsets.fromLTRB(36, 16, 36, 52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MeasurementProgressBar(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(),
                MeasurementBox(),
                ConditionalContent(
                  conditional: state.loopModeDetails.isLoopModeActive &&
                      state.loopModeDetails.currentNumberOfTestsStarted > 1 &&
                      [
                        MeasurementPhase.packLoss,
                        MeasurementPhase.up,
                        MeasurementPhase.down,
                        MeasurementPhase.initUp,
                        MeasurementPhase.latency,
                        MeasurementPhase.jitter
                      ].contains(state.phase),
                  truthyBuilder: () => Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: MeasurementMedianBox(),
                  ),
                )
              ],
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 40),
                child: MeasurementChart()),
            ConditionalContent(
              conditional: state.loopModeDetails.isLoopModeActive,
              truthyBuilder: () => Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 24),
                child: MeasurementLoopNextTestInfo(),
              ),
            ),
            Expanded(child: buildResults()),
          ],
        ),
      );
}
