import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nt_flutter_standalone/core/di/service-locator.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/technology-signal.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/technology-over-time.chart.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ServiceLocator.registerInstances();
  });

  testWidgets('Test chart and labels are present', (tester) async {
    final widget = TechnologyOverTimeChart(
      chartWidth: 200,
      signals: [
        TechnologySignal(signal: -70, technology: '4G', timeNs: 500),
        TechnologySignal(signal: -50, technology: wifi, timeNs: 1000),
        TechnologySignal(signal: -75, technology: '4G', timeNs: 500),
      ],
    );
    await tester.pumpWidget(MaterialApp(home: widget));
    final chartFinder = find.byType(SfCartesianChart);
    final label4GFinder = find.text('4G');
    final labelWifiFinder = find.text('WI-FI');
    expect(chartFinder, findsOneWidget);
    expect(label4GFinder, findsNWidgets(2));
    expect(labelWifiFinder, findsOneWidget);
  });
}
