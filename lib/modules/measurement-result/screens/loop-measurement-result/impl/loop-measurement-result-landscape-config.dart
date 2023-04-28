import 'package:flutter/material.dart';

import '../../../models/measurement-history-results.dart';
import '../loop-measurement-result-config.dart';

class LoopMeasurementResultLandscapeConfig extends LoopMeasurementResultConfig {
  LoopMeasurementResultLandscapeConfig(MeasurementHistoryResults? result, bool enabledJitterAndPacketLoss)
      : super(result: result, enabledJitterAndPacketLoss: enabledJitterAndPacketLoss);

  @override
  Widget getContent() {
    return SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: getMedianResults(28),
              ),
            ),
            Expanded(child: SingleChildScrollView(child: getResults()))
          ],
        ));
  }
}
