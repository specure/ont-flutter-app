import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/net-neutrality-view.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-category.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-measurement.dart';
import 'package:pie_chart/pie_chart.dart';

class HistoryNetNeutralityItemWidget extends StatelessWidget {
  final NetNeutralityHistoryMeasurement item;
  final FlexFit flexFit;

  HistoryNetNeutralityItemWidget({
    required this.item,
    required this.flexFit,
  });

  @override
  Widget build(BuildContext context) {
    var networkTypeIcon;
    if (item.networkType == 'WLAN' || item.networkType == wifi) {
      networkTypeIcon = Icons.signal_wifi_4_bar;
    } else if (item.networkType.isEmpty ||
        item.networkType.toLowerCase() == 'unknown') {
      networkTypeIcon = Icons.cell_wifi_outlined;
    } else {
      networkTypeIcon = Icons.signal_cellular_alt_outlined;
    }
    var networkName = _resolveNetworkTypeText(item);
    return Column(
      children: [
        Container(
          height: netNeutalityHistoryItemHeight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 46,
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
                                    DateTime.parse(item.measurementDate)
                                        .toLocal()),
                                style: TextStyle(
                                  fontSize: NTDimensions.textXS,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                item.deviceName,
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
                _Graph(category: item.tests[NetNeutralityType.DNS]),
                _Graph(category: item.tests[NetNeutralityType.WEB]),
                // TODO: uncomment when another NN test will be done and lover flex by 4 for each test in flexible above
                // _Graph(
                //   category: item.tests[NetNeutralityType.UDP]),
                // _Graph(
                //     category: item.tests[NetNeutralityType.TCP]),
                // _Graph(
                //     category: item.tests[NetNeutralityType.VOP]),
                // _Graph(
                //     category: item.tests[NetNeutralityType.UNM]),
                // _Graph(
                //     category: item.tests[NetNeutralityType.TSP]),
                // _Graph(
                //     category: item.tests[NetNeutralityType.TCR]),
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

  _resolveNetworkTypeText(NetNeutralityHistoryMeasurement item) {
    if (item.networkType == wifi || item.networkType == 'WLAN') {
      return null;
    } else if (item.networkType.isEmpty ||
        item.networkType.toLowerCase() == "unknown") {
      return "?";
    } else {
      return (item.networkType.toLowerCase() != "cellular_any" &&
              item.networkType.toLowerCase() != "mobile")
          ? item.networkType.formatMobileNetworkTypes
          : '';
    }
  }
}

class _Graph extends StatelessWidget {
  final NetNeutralityHistoryCategory? category;

  _Graph({required this.category});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 4,
      fit: FlexFit.tight,
      child: ConditionalContent(
        conditional: category != null && (category?.totalResults ?? 0) != 0,
        truthyBuilder: () => PieChart(
          chartLegendSpacing: 0,
          ringStrokeWidth: 3,
          chartRadius: 24,
          dataMap: HashMap<String, double>.fromEntries([
            MapEntry<String, double>(
                "succeeded", (category?.successfulResults ?? 0).toDouble()),
            MapEntry<String, double>(
                "failed",
                ((category?.totalResults ?? 0) -
                        (category?.successfulResults ?? 0))
                    .toDouble()),
          ]),
          chartType: ChartType.ring,
          initialAngleInDegree: -90,
          legendOptions: LegendOptions(
            showLegends: false,
          ),
          colorList: [Colors.lightGreen, Colors.grey],
          chartValuesOptions: ChartValuesOptions(
            showChartValues: false,
            showChartValuesInPercentage: false,
          ),
        ),
        falsyBuilder: () => Text(
          "-",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
