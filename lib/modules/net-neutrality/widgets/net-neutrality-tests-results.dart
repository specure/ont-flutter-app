import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-details.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-category.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';
import 'package:pie_chart/pie_chart.dart';

class NetNeutralityTestsResults extends StatelessWidget {
  const NetNeutralityTestsResults();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetNeutralityCubit, NetNeutralityState>(
      builder: (context, state) => ConditionalContent(
        conditional: state.loading == false,
        truthyBuilder: () => Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: SectionTitle('Performed'),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: SectionTitle(
                              'Failed',
                              alignment: TextAlign.end,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: SectionTitle(
                              'Passed',
                              alignment: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Text(
                                "${state.historyResults.length}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: NTDimensions.textXXS * 3),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text(
                                "${state.getFailedHistoryResult().length}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: NTDimensions.textXXS * 3),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text(
                                "${state.getSuccessfulHistoryResult().length}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: NTDimensions.textXXS * 3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: state.categories
                        .where((element) => element.totalResults > 0)
                        .length,
                    itemBuilder: (context, index) {
                      final category = state.categories
                          .where((element) => element.totalResults > 0)
                          .toList()[index];
                      return _Graph(category: category);
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: getRowItemsCount(context)),
                  ),
                ),
              ],
            ),
          ),
        ),
        falsyBuilder: () => Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: NTColors.primary,
          ),
        ),
      ),
    );
  }

  getRowItemsCount(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return 4;
    } else {
      return 2;
    }
  }
}

class _Graph extends StatelessWidget {
  final NetNeutralityHistoryCategory? category;

  _Graph({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (category?.type) {
          case NetNeutralityType.WEB:
            return GetIt.I.get<NetNeutralityCubit>().openResultDetails(
                NetNeutralityDetailsConfig.webTestConfig,
                category?.items ?? []);
          case NetNeutralityType.DNS:
            return GetIt.I.get<NetNeutralityCubit>().openResultDetails(
                NetNeutralityDetailsConfig.dnsTestConfig,
                category?.items ?? []);
        }
      },
      child: Container(
        child: ConditionalContent(
          conditional: category != null,
          truthyBuilder: () => Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                PieChart(
                  chartLegendSpacing: 0,
                  ringStrokeWidth: 16,
                  chartRadius: 90,
                  dataMap: HashMap<String, double>.fromEntries([
                    MapEntry<String, double>("succeeded",
                        (category?.successfulResults ?? 0).toDouble()),
                    MapEntry<String, double>(
                        "failed", (category?.failedResults ?? 0).toDouble()),
                  ]),
                  chartType: ChartType.ring,
                  initialAngleInDegree: -90,
                  centerText: category?.successfulOfTotal,
                  centerTextStyle: TextStyle(
                    color: Colors.black,
                    backgroundColor: Colors.transparent,
                    background: null,
                    fontWeight: FontWeight.w500,
                    fontSize: NTDimensions.textL,
                  ),
                  legendOptions: LegendOptions(
                    showLegends: false,
                  ),
                  colorList: [Colors.lightGreen, Colors.grey],
                  chartValuesOptions: ChartValuesOptions(
                    showChartValues: false,
                    showChartValueBackground: false,
                    showChartValuesInPercentage: false,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category?.name ?? "",
                          style: TextStyle(color: NTColors.primary),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: NTColors.primary,
                          size: 16,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
