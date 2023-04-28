import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';

import '../../modules/measurement-result/models/measurement-history-results.dart';

class HistoryItemWidget extends StatelessWidget {
  final MeasurementHistoryResults item;
  final FlexFit flexFit;

  HistoryItemWidget({
    required this.item,
    required this.flexFit,
  });

  @override
  Widget build(BuildContext context) {
    var networkTypeIcon;
    var firstTest = item.tests[0];
    if (item.isLoopMeasurement) {
      networkTypeIcon = Icons.sync;
    } else if (firstTest.networkType == 'WLAN' ||
        firstTest.networkType == wifi) {
      networkTypeIcon = Icons.signal_wifi_4_bar;
    } else if (firstTest.networkType?.toLowerCase() == 'unknown') {
      networkTypeIcon = Icons.cell_wifi_outlined;
    } else {
      networkTypeIcon = Icons.signal_cellular_alt_outlined;
    }
    var networkName = _resolveNetworkTypeText(firstTest);
    return Column(
      children: [
        Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 5,
                  child: Container(
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ConditionalContent(
                              conditional: networkName != null,
                              truthyBuilder: () => Text(
                                networkName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: NTDimensions.textXS,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(networkTypeIcon),
                          ],
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('dd.MM.yyyy HH:mm').format(
                                    DateTime.parse(firstTest.measurementDate)
                                        .toLocal()),
                                style: TextStyle(
                                  fontSize: NTDimensions.textXS,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                firstTest.device ?? '',
                                style: TextStyle(
                                  fontSize: NTDimensions.textXS,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _Section(firstTest.downloadSpeedMbpsFormatted,
                    flexFit: flexFit),
                _Section(firstTest.uploadSpeedMbpsFormatted, flexFit: flexFit),
                _Section(firstTest.pingMsFormatted, flexFit: flexFit),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.black12,
          height: 1,
        ),
      ],
    );
  }

  _resolveNetworkTypeText(MeasurementHistoryResult item) {
    if (item.loopModeUuid != null ||
        item.networkType == wifi ||
        item.networkType == 'WLAN') {
      return null;
    } else if (item.networkType?.toLowerCase() == "unknown") {
      return "?";
    } else {
      return (item.networkType?.toLowerCase() != "cellular_any" &&
              item.networkType?.toLowerCase() != "mobile")
          ? item.networkType?.formatMobileNetworkTypes ?? ''
          : '';
    }
  }
}

class _Section extends StatelessWidget {
  final String text;
  final FlexFit flexFit;

  _Section(this.text, {required this.flexFit});

  @override
  Widget build(BuildContext context) {
    var paramWidth = 50.0;
    return Flexible(
      flex: 2,
      fit: flexFit,
      child: Container(
        width: paramWidth,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: NTDimensions.textXL,
            color: NTColors.primary,
          ),
        ),
      ),
    );
  }
}
