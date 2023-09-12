import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-body/measurement-body.config.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-box.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-chart.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-progress-bar.widget.dart';

import '../../../constants/measurement-phase.dart';
import '../../measurement-loop-next-test-info.widget.dart';
import '../../measurement-median-box.widget.dart';

class MeasurementBodyLandscapeConfig extends MeasurementBodyConfig {
  MeasurementBodyLandscapeConfig(MeasurementsState state) : super(state: state);

  @override
  final Axis measurementServerMainAxis = Axis.vertical;

  Widget getContent() => Padding(
        padding: EdgeInsets.fromLTRB(36, 0, 36, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MeasurementProgressBar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        ConditionalContent(
                          conditional: state.loopModeDetails.isLoopModeActive,
                          truthyBuilder: () => Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 24),
                            child: MeasurementLoopNextTestInfo(),
                          ),
                        ),
                        buildResults(),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MeasurementBox(),
                            ConditionalContent(
                              conditional:
                                  state.loopModeDetails.isLoopModeActive &&
                                      state.loopModeDetails
                                              .currentNumberOfTestsStarted >
                                          1 &&
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
                            margin:
                                EdgeInsets.only(left: 32, top: 8, right: 16),
                            child: MeasurementChart())
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
}
