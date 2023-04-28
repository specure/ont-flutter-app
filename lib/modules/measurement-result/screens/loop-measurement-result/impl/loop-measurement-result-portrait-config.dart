import 'package:flutter/material.dart';

import '../../../models/measurement-history-results.dart';
import '../loop-measurement-result-config.dart';

class LoopMeasurementResultPortraitConfig extends LoopMeasurementResultConfig {
  LoopMeasurementResultPortraitConfig(MeasurementHistoryResults? result, bool enableJitterAndPacketLoss)
      : super(result: result, enabledJitterAndPacketLoss: enableJitterAndPacketLoss);

  @override
  Widget getContent() {
    return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              getMedianResults(28),
              getResults()
            ],
          ),
        ));
  }
}
