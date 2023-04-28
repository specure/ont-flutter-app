import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NetworkSpeedSection extends StatelessWidget {
  final String title;
  final List<double>? speedList;
  final String speed;

  NetworkSpeedSection({
    required this.title,
    this.speedList,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title),
        SizedBox(height: 14),
        RichText(
          text: TextSpan(
            text: speed.toString(),
            style: TextStyle(
              fontSize: NTDimensions.title,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' Mbps',
                style: TextStyle(fontSize: NTDimensions.textS),
              ),
            ],
          ),
        ),
        ConditionalContent(
          conditional: speedList != null && speedList!.isNotEmpty,
          truthyBuilder: () => Container(
            height: 56,
            child: SfCartesianChart(
              key: Key(title),
              margin: EdgeInsets.zero,
              plotAreaBorderWidth: 0,
              primaryXAxis: NumericAxis(isVisible: false),
              primaryYAxis: NumericAxis(isVisible: false),
              series: <ChartSeries>[
                AreaSeries<double, int>(
                  dataSource: speedList!,
                  xValueMapper: (value, x) => x,
                  yValueMapper: (value, x) => value,
                  borderWidth: 1,
                  borderColor: NTColors.primary,
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
