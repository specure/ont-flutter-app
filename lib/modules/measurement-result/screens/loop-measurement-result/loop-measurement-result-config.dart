import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/extensions/double.ext.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

import '../../../../core/constants/dimensions.dart';
import '../../../../core/widgets/conditional-content.dart';
import '../../../../core/widgets/history-item.widget.dart';
import '../../../history/widgets/speed-view/speed.view.dart';
import '../../models/measurement-history-results.dart';
import '../../widgets/network-speed-section.dart';
import '../../widgets/text-section.dart';
import '../measurement-result/measurement-result.screen.dart';

abstract class LoopMeasurementResultConfig {
  LoopMeasurementResultConfig({required this.result, required this.enabledJitterAndPacketLoss});

  late final MeasurementHistoryResults? result;
  late final bool enabledJitterAndPacketLoss;

  Widget getContent();

  Widget getMedianResults(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "Median values".translated,
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
                      speed: formatSpeed(result?.downloadKbps) ??
                          "-",
                      speedList: null,
                    ),
                  ),
                  Flexible(
                    child: NetworkSpeedSection(
                      title: 'Upload',
                      speed: formatSpeed(result?.uploadKbps) ??
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
                      value: result?.pingMs?.toInt().toString() ??
                          "-",
                      valueUnit: 'ms',
                    ),
                  ),
                  ConditionalContent(
                    conditional:
                    (result?.jitterMs != null && result?.jitterMs != 0 && enabledJitterAndPacketLoss),
                    truthyBuilder: () {
                      return Flexible(
                        child: TextSection(
                          title: 'Jitter',
                          value: result?.jitterMs.toInt().toString() ??
                              "-",
                          valueUnit: 'ms',
                        ),
                      );
                    },
                  ),
                  ConditionalContent(
                      conditional: (result?.packetLossPercents != null && result?.jitterMs != 0 && enabledJitterAndPacketLoss),
                      truthyBuilder: () {
                        return Flexible(
                          flex: 2,
                          child: TextSection(
                            title: 'Packet loss',
                            value: formatPercents(
                               result?.packetLossPercents) ??
                                '-',
                            valueUnit: '%',
                          ),
                        );
                      }),
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
        conditional: true,
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
                itemCount: result?.tests.length,
                itemBuilder: (context, index) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                        var singleResult = result?.tests[(result?.tests.length ?? 1) - 1 - index];
                        if (singleResult != null) {
                          Navigator.pushNamed(
                            context,
                            MeasurementResultScreen.route,
                            arguments: {
                              MeasurementResultScreen
                                  .argumentResult: MeasurementHistoryResults([
                                singleResult
                              ]),
                              MeasurementResultScreen.argumentTestUuid: singleResult.testUuid
                            },
                          );
                        }
                      },
                    child: HistoryItemWidget(
                      item: (result?.tests.map((e) => MeasurementHistoryResults([e])).whereType<MeasurementHistoryResults>().toList() as List<MeasurementHistoryResults>)[(result?.tests.length ?? 1) - 1 - index],
                      flexFit: FlexFit.loose,
                    ),
                ),
              ),
            ),
          ],
        ));
  }

  String? formatSpeed(double? speed) {
    return speed != null ? speed.roundSpeed() : null;
  }

  String? formatPercents(double? percents) {
    if (percents != null && percents >= 0) {
      return percents.toString();
    } else {
      return null;
    }
  }
}
