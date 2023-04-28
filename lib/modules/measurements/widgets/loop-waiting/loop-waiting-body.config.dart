import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/extensions/double.ext.dart';
import 'package:nt_flutter_standalone/core/extensions/int.ext.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-results.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../core/constants/dimensions.dart';
import '../../../../core/widgets/conditional-content.dart';
import '../../../../core/widgets/history-item.widget.dart';
import '../../../history/widgets/speed-view/speed.view.dart';
import '../../../measurement-result/widgets/network-speed-section.dart';
import '../../../measurement-result/widgets/text-section.dart';
import '../../constants/measurement-phase.dart';

abstract class LoopWaitingBodyConfig {
  LoopWaitingBodyConfig({required this.state});

  late final MeasurementsState state;

  Widget getContent();

  Widget getMedianResults(double horizontalPadding) {
    final medianResults = state.loopModeDetails.medians;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "Interim results (Median values)".translated,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
                fontSize: NTDimensions.textM,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                color: Colors.black12,
                width: 1,
              )),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Flexible(
                    child: NetworkSpeedSection(
                      title: 'Download',
                      speed: formatSpeed(medianResults[MeasurementPhase.down]
                              ?.medianValue) ??
                          "-",
                      speedList: null,
                    ),
                  ),
                  Flexible(
                    child: NetworkSpeedSection(
                      title: 'Upload',
                      speed: formatSpeed(medianResults[MeasurementPhase.up]
                              ?.medianValue) ??
                          "-",
                      speedList: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                color: Colors.black12,
                width: 1,
              )),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextSection(
                      title: 'Ping',
                      value: formatNanosToMillis(
                              medianResults[MeasurementPhase.latency]
                                  ?.medianValue) ??
                          "-",
                      valueUnit: 'ms',
                    ),
                  ),
                  ConditionalContent(
                    conditional:
                        state.project?.enableAppJitterAndPacketLoss == true,
                    truthyBuilder: () {
                      return Flexible(
                        child: TextSection(
                          title: 'Jitter',
                          value: formatNanosToMillis(
                                  medianResults[MeasurementPhase.jitter]
                                      ?.medianValue) ??
                              "-",
                          valueUnit: 'ms',
                        ),
                      );
                    },
                  ),
                  ConditionalContent(
                      conditional:
                          state.project?.enableAppJitterAndPacketLoss == true,
                      truthyBuilder: () {
                        return Flexible(
                          flex: 2,
                          child: TextSection(
                            title: 'Packet loss',
                            value: formatPercents(
                                    medianResults[MeasurementPhase.packLoss]
                                        ?.medianValue) ??
                                '-',
                            valueUnit: '%',
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                color: Colors.black12,
                width: 1,
              )),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Flexible(
                    child: TextSection(
                      title: 'Time to next test'.toUpperCase(),
                      value: sprintf("%s min", [
                        (state.loopModeDetails.currentTimeToNextTestSeconds
                            .formatSecondsToMinutesAndSeconds())
                      ]),
                    ),
                  ),
                  Flexible(
                    child: TextSection(
                      title: 'Movement',
                      value: sprintf("%d/%dm", [
                        state.loopModeDetails
                            .currentDistanceMetersPassedFromLastTest,
                        state.loopModeDetails.targetDistanceMetersToNextTest
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getResults() {
    return ConditionalContent(
        conditional: state.loopModeDetails.historyResults != null,
        truthyBuilder: () => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: HistoryHeader(flexFit: FlexFit.loose),
                ),
                Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.loopModeDetails.historyResults?.length,
                    itemBuilder: (context, index) => HistoryItemWidget(
                      item: MeasurementHistoryResults([state.loopModeDetails.historyResults![
                          (state.loopModeDetails.historyResults!.length -
                              1 -
                              index)]]),
                      flexFit: FlexFit.loose,
                    ),
                  ),
                ),
              ],
            ));
  }

  String? formatSpeed(double? speed) {
    return speed != null ? speed.roundSpeed() : null;
  }

  String? formatNanosToMillis(double? nanos) {
    if (nanos != null && nanos >= 0) {
      return (nanos / 1000000.0).round().toString();
    } else {
      return null;
    }
  }

  String? formatPercents(double? percents) {
    if (percents != null && percents >= 0) {
      return percents.toString();
    } else {
      return null;
    }
  }
}
