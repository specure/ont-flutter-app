import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/network-speed-section.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../di/service-locator.dart';

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
  });

  group('Test Network speed section widget', () {
    testWidgets('Test with chart', (tester) async {
      await _testNetworkSpeedSection(tester, true);
    });
    testWidgets('Test without chart', (tester) async {
      _testNetworkSpeedSection(tester, false);
    });
  });
}

Future _testNetworkSpeedSection(WidgetTester tester, bool withChart) async {
  final widget = NetworkSpeedSection(
    title: 'Download',
    speed: '2.5',
    speedList: withChart ? [1.6, 2.0, 2.5, 3.0] : null,
  );
  await tester.pumpWidget(MaterialApp(home: widget));
  await tester.pumpAndSettle();
  final speedFinder = find.byWidgetPredicate((widget) =>
      widget is RichText && widget.text.toPlainText() == '2.5 Mbps');
  final chartFinder = find.byType(SfCartesianChart);
  expect(speedFinder, findsOneWidget);
  expect(chartFinder, withChart ? findsOneWidget : findsNothing);
}
