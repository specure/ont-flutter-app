import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/map/models/technology.item.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/providers.button.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/technology.bar.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/technology.button.dart';

import '../../di/service-locator.dart';

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init()).thenAnswer((_) async => null);
    when(GetIt.I.get<SharedPreferencesWrapper>().getString(StorageKeys.selectedLocaleTag)).thenReturn(_selectedLocaleTag);
  });

  group('Test technology bar widget', () {
    testWidgets('Test collapsed technology bar', (tester) async {
      await _testCollapsedBar(tester);
    });
    testWidgets('Test expanded technology bar', (tester) async {
      await _testExpandedTechnologyBar(tester);
    });
  });
}

Future _testCollapsedBar(WidgetTester tester) async {
  final widget = TechnologyBar(
    expanded: false,
    allTechnologies: [
      TechnologyItem(color: Colors.grey, title: 'All'),
      TechnologyItem(color: Colors.blue, title: 'Wifi'),
    ],
    operators: ['All'],
    currentOperatorIndex: 0,
    currentTechnologyIndex: 0,
  );
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: widget,
    ),
  ));
  final technologyFinder = find.byType(TechnologyButton);
  final providerFinder = find.text('All Mobile Network Operators');
  expect(technologyFinder, findsOneWidget);
  expect(providerFinder, findsOneWidget);
}

Future _testExpandedTechnologyBar(WidgetTester tester) async {
  bool providersButtonTapped = false;
  final widget = TechnologyBar(
    expanded: true,
    allTechnologies: [
      TechnologyItem(color: Colors.grey, title: 'All'),
      TechnologyItem(color: Colors.blue, title: 'Wifi'),
    ],
    operators: ['All'],
    currentOperatorIndex: 0,
    currentTechnologyIndex: 0,
    onProvidersTap: () => providersButtonTapped = true,
  );
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: widget,
    ),
  ));
  final technologyFinder = find.byType(TechnologyButton);
  final providersButtonFinder = find.byWidgetPredicate((widget) =>
      widget is ProvidersButton &&
      widget.operators == widget.operators &&
      widget.currentOperatorIndex == widget.currentOperatorIndex);
  expect(technologyFinder, findsNWidgets(2));
  expect(providersButtonFinder, findsOneWidget);
  await tester.tap(providersButtonFinder);
  await tester.pump();
  expect(providersButtonTapped, true);
}
