import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/extensions/double.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-result-item.widget.dart';

abstract class MeasurementBodyConfig {
  MeasurementBodyConfig({required this.state});

  late final MeasurementsState state;
  late final AnimationController progressController;
  final Axis measurementServerMainAxis = Axis.vertical;

  Widget getContent();

  Widget buildResults() {
    return SingleChildScrollView(
      child: SizedBox(
          width: 300,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Measurement".translated.toUpperCase(),
                      style: TextStyle(
                        color: NTColors.pale,
                        fontSize: NTDimensions.textS,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Current".translated.toUpperCase(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: NTColors.pale,
                        fontSize: NTDimensions.textS,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ConditionalContent(
                      conditional: state.loopModeDetails.isLoopModeActive &&
                          state.loopModeDetails.currentNumberOfTestsStarted > 1,
                      truthyBuilder: () => Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Median".translated.toUpperCase(),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: NTColors.pale,
                                  fontSize: NTDimensions.textS,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
                ],
              ),
            ),
            MeasurementResultItem(
                name: MeasurementPhase.latency.name,
                unit: MeasurementPhase.latency.resultUnits,
                value: _formatNanosToMillis(
                    state.phaseFinalResults[MeasurementPhase.latency]),
                showMedianValue: state.loopModeDetails.isLoopModeActive &&
                    state.loopModeDetails.currentNumberOfTestsStarted > 1,
                medianValue: _formatNanosToMillis(state.loopModeDetails
                    .medians[MeasurementPhase.latency]?.medianValue)),
            ConditionalContent(
              conditional: state.project?.enableAppJitterAndPacketLoss == true,
              truthyBuilder: () => MeasurementResultItem(
                  name: MeasurementPhase.packLoss.name,
                  unit: MeasurementPhase.packLoss.resultUnits,
                  value: _formatPercents(
                      state.phaseFinalResults[MeasurementPhase.packLoss]),
                  showMedianValue: state.loopModeDetails.isLoopModeActive &&
                      state.loopModeDetails.currentNumberOfTestsStarted > 1,
                  medianValue: _formatPercents(state.loopModeDetails
                      .medians[MeasurementPhase.packLoss]?.medianValue)),
            ),
            ConditionalContent(
              conditional: state.project?.enableAppJitterAndPacketLoss == true,
              truthyBuilder: () => MeasurementResultItem(
                  name: MeasurementPhase.jitter.name,
                  unit: MeasurementPhase.jitter.resultUnits,
                  value: _formatNanosToMillis(
                      state.phaseFinalResults[MeasurementPhase.jitter]),
                  showMedianValue: state.loopModeDetails.isLoopModeActive &&
                      state.loopModeDetails.currentNumberOfTestsStarted > 1,
                  medianValue: _formatNanosToMillis(state.loopModeDetails
                      .medians[MeasurementPhase.jitter]?.medianValue)),
            ),
            MeasurementResultItem(
                name: MeasurementPhase.down.name,
                unit: MeasurementPhase.down.resultUnits,
                value: _formatSpeed(
                    state.phaseFinalResults[MeasurementPhase.down]),
                showMedianValue: state.loopModeDetails.isLoopModeActive &&
                    state.loopModeDetails.currentNumberOfTestsStarted > 1,
                medianValue: _formatSpeed(state.loopModeDetails
                    .medians[MeasurementPhase.down]?.medianValue)),
            MeasurementResultItem(
                name: MeasurementPhase.up.name,
                unit: MeasurementPhase.up.resultUnits,
                value:
                    _formatSpeed(state.phaseFinalResults[MeasurementPhase.up]),
                showMedianValue: state.loopModeDetails.isLoopModeActive &&
                    state.loopModeDetails.currentNumberOfTestsStarted > 1,
                medianValue: _formatSpeed(state.loopModeDetails
                    .medians[MeasurementPhase.up]?.medianValue)),
          ])),
    );
  }

  String? _formatSpeed(double? speed) {
    return speed != null ? speed.roundSpeed() : null;
  }

  String? _formatNanosToMillis(double? nanos) {
    if (nanos != null && nanos >= 0) {
      return (nanos / 1000000.0).round().toString();
    } else {
      return null;
    }
  }

  String? _formatPercents(double? percents) {
    if (percents != null && percents >= 0) {
      return percents.toString();
    } else {
      return null;
    }
  }
}
