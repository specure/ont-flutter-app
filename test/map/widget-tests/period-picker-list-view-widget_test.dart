import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nt_flutter_standalone/core/di/service-locator.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/period-picker.list-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ServiceLocator.registerInstances();
  });

  testWidgets('Test period picker list view widget', (tester) async {
    final widget = PeriodPickerListView(
      items: ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    ));
    final aprFinder = find.text('Apr');
    await tester.scrollUntilVisible(aprFinder, 40);
    expect(aprFinder, findsOneWidget);
  });
}
