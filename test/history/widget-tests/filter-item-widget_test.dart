import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nt_flutter_standalone/core/widgets/divider.dart';
import 'package:nt_flutter_standalone/modules/history/models/history-filter.item.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/filter-item.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';

void main() {
  group('Test filter item widget', () {
    testWidgets('Test not last and active item', (tester) async {
      await _testItem(tester, active: true);
    });
    testWidgets('Test last and not active item', (tester) async {
      await _testItem(tester, last: true);
    });
  });
}

Future _testItem(
  WidgetTester tester, {
  bool last = false,
  bool active = false,
}) async {
  final historyItem = HistoryFilterItem(text: wifi, active: active);
  late HistoryFilterItem tappedItem;
  final widget = FilterItem(
    item: historyItem,
    isLast: last,
    onTap: (item) => tappedItem = item,
  );
  await tester.pumpWidget(MaterialApp(home: widget));
  final textFinder = find.text(historyItem.text);
  final activeIconFinder = find.byIcon(Icons.check);
  final dividerFinder = find.byType(ThinDivider);
  expect(textFinder, findsOneWidget);
  expect(activeIconFinder, active ? findsOneWidget : findsNothing);
  expect(dividerFinder, last ? findsNothing : findsOneWidget);
  await tester.tap(textFinder);
  expect(tappedItem, isNotNull);
}
