import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/technology-signal.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TechnologyOverTimeChart extends StatelessWidget {
  final List<TechnologySignal> signals;
  final double chartWidth;

  TechnologyOverTimeChart({
    required this.signals,
    required this.chartWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConditionalContent(
      conditional: signals.isNotEmpty,
      truthyBuilder: () {
        var chartStops = _generateStopsForSignalChart();
        var labelsStops = _getLabelStopsForSignalChart(chartStops);
        return Column(
          children: [
            SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: SectionTitle('Technology Over Time'),
            ),
            Stack(
              children: [
                _buildChart(chartStops),
                ..._getChartLabels(labelsStops),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0),
                      ],
                      stops: [
                        0,
                        0.7,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildChart(List<_TechnologyChartStop> stops) => SizedBox(
        height: 60,
        child: SfCartesianChart(
          margin: EdgeInsets.zero,
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(isVisible: false),
          primaryYAxis: NumericAxis(
            isVisible: false,
            isInversed: true,
          ),
          series: [
            AreaSeries<TechnologySignal?, int>(
              dataSource: signals,
              xValueMapper: (value, x) => x,
              yValueMapper: (value, x) => value?.signal,
              onCreateShader: (details) {
                return ui.Gradient.linear(
                  details.rect.bottomLeft,
                  details.rect.bottomRight,
                  List.generate(
                    signals.length,
                    (index) => NTColors.getNetworkTechnologyColor(
                        signals[index].technology),
                  ),
                  stops.map((e) => e.stop).toList(),
                );
              },
            ),
          ],
        ),
      );

  List<Widget> _getChartLabels(List<_TechnologyChartStop> stops) =>
      List.generate(
        stops.length,
        (index) => Positioned(
          bottom: 0,
          left: stops[index].stop * chartWidth,
          child: Text(
            stops[index].technology.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: NTDimensions.textXS,
              color:
                  NTColors.getNetworkTechnologyColor(stops[index].technology),
            ),
          ),
        ),
      );

  List<_TechnologyChartStop> _generateStopsForSignalChart() {
    List<_TechnologyChartStop> stops = [];
    String currentTechnology = signals[0].technology;
    int stopsCountForCurrentTechnology = 0;
    double previousStop = 0.0;
    for (var i = 0; i < signals.length; i++) {
      var lastIndex = signals.length - 1;
      if (i == lastIndex || signals[i + 1].technology != currentTechnology) {
        stops.addAll(List.generate(
          stopsCountForCurrentTechnology,
          (_) => _TechnologyChartStop(currentTechnology, previousStop),
        ));
        var stop = (1 / signals.length) * (i + 1);
        stops.add(_TechnologyChartStop(currentTechnology, stop));
        previousStop = stop;
        stopsCountForCurrentTechnology = 0;
        if (i != lastIndex) {
          currentTechnology = signals[i + 1].technology;
        }
      } else {
        stopsCountForCurrentTechnology++;
      }
    }
    return stops;
  }

  List<_TechnologyChartStop> _getLabelStopsForSignalChart(
      List<_TechnologyChartStop> stops) {
    var stopsList = List<_TechnologyChartStop>.from(stops);
    var index = 0;
    for (int i = 0; i < stops.length - 1; i++) {
      if (stopsList[index + 1].technology == stopsList[index].technology) {
        stopsList.removeAt(index + 1);
      } else {
        index++;
      }
    }
    return stopsList;
  }
}

class _TechnologyChartStop {
  final String technology;
  final double stop;

  _TechnologyChartStop(this.technology, this.stop);
}
