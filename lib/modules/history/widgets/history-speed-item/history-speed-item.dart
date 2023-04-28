import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/measurement-result/measurement-result.screen.dart';

import '../../../../core/widgets/history-item.widget.dart';
import '../../../measurement-result/models/measurement-history-results.dart';
import '../../../measurement-result/screens/loop-measurement-result/loop-measurement-result.screen.dart';
import 'history-speed-item-config.dart';
import 'impl/history-speed-item-landscape-config.dart';
import 'impl/history-speed-item-portrait-config.dart';

class HistorySpeedItemWidget extends StatelessWidget {
  final MeasurementHistoryResults item;

  HistorySpeedItemWidget({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return NTOrientationBuilder<HistorySpeedItemConfig>(
      portraitConfig: HistorySpeedItemPortraitConfig(),
      landscapeConfig: HistorySpeedItemLandscapeConfig(),
      builder: (config) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (item.tests.isNotEmpty) {
            if (item.isLoopMeasurement) {
              Navigator.pushNamed(
                context,
                LoopMeasurementResultScreen.route,
                arguments: {
                  MeasurementResultScreen.argumentResult: item,
                  MeasurementResultScreen.argumentTestUuid: item.tests.first
                      .loopModeUuid,
                },
              );
            } else {
              Navigator.pushNamed(
                context,
                MeasurementResultScreen.route,
                arguments: {
                  MeasurementResultScreen.argumentResult: item,
                  MeasurementResultScreen.argumentTestUuid: item.tests.first
                      .testUuid,
                },
              );
            }
          }
        },
        child: HistoryItemWidget(item: item, flexFit: config.flexFit)
      ),
    );
  }
}
