import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/text-section.dart';

import '../../di/service-locator.dart';

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init()).thenAnswer((_) async => null);
    when(GetIt.I.get<SharedPreferencesWrapper>().getString(StorageKeys.selectedLocaleTag)).thenReturn(_selectedLocaleTag);
  });

  group('Test text section widget', () {
    testWidgets('Test without unit and icon', (tester) async {
      await _testWithoutUnitAndIcon(tester);
    });
    testWidgets('Test with unit and icon', (tester) async {
      await _testWithUnitAndIcon(tester);
    });
  });
}

Future _testWithoutUnitAndIcon(WidgetTester tester) async {
  final widget = TextSection(
    title: 'Title',
    value: '100',
  );
  await tester.pumpWidget(MaterialApp(home: widget));
  final titleFinder = find.byWidgetPredicate(
      (widget) => widget is SectionTitle && widget.text == 'Title');
  final valueFinder = find.byWidgetPredicate(
      (widget) => widget is RichText && widget.text.toPlainText() == '100 ');
  expect(titleFinder, findsOneWidget);
  expect(valueFinder, findsOneWidget);
}

Future _testWithUnitAndIcon(WidgetTester tester) async {
  final widget = TextSection(
    title: 'Title',
    value: '100',
    valueUnit: 'm',
    icon: Icons.smartphone,
  );
  await tester.pumpWidget(MaterialApp(home: widget));
  final titleFinder = find.byWidgetPredicate(
      (widget) => widget is SectionTitle && widget.text == 'Title');
  final valueFinder = find.byWidgetPredicate(
      (widget) => widget is RichText && widget.text.toPlainText() == '100 m');
  final iconFinder = find.byIcon(Icons.smartphone);
  expect(titleFinder, findsOneWidget);
  expect(valueFinder, findsOneWidget);
  expect(iconFinder, findsOneWidget);
}
