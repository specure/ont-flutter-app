import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nt_flutter_standalone/core/di/service-locator.dart';
import 'package:nt_flutter_standalone/modules/map/models/measurements.data.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/measurements.popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    ServiceLocator.registerInstances();
  });

  testWidgets('Test measurements popup widget', (tester) async {
    final widget = MeasurementsPopup(MeasurementsData(
      regionType: 'County',
      regionName: 'Cupertino',
      total: 30,
      averageDown: 20.0,
      averageUp: 10.0,
      averageLatency: 50.0,
    ));
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    ));
    final regionTypeFinder = find.text('County');
    final regionNameFinder = find.text('Cupertino');
    final totalMeasurementsFinder = find.text('30');
    final averageDownFinder = find.text('20 Mbps');
    final averageUpFinder = find.text('10 Mbps');
    final averageLatencyFinder = find.text('50 ms');
    await tester.pumpAndSettle();
    expect(regionTypeFinder, findsOneWidget);
    expect(regionNameFinder, findsOneWidget);
    expect(totalMeasurementsFinder, findsOneWidget);
    expect(averageDownFinder, findsOneWidget);
    expect(averageUpFinder, findsOneWidget);
    expect(averageLatencyFinder, findsOneWidget);
  });
}
