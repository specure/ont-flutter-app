import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.item.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/search.bar.dart';

import '../../di/service-locator.dart';

final _searchResultItem = MapSearchItem(
  title: 'Infinite Loop, Cupertino, CA 95014-2083, USA',
  address: 'Infinite Loop, Cupertino, CA 95014-2083, USA',
  latitude: 37.331830,
  longitude: -122.030835,
  bounds: LatLngBounds(
    southwest: LatLng(37.331830, -122.030835),
    northeast: LatLng(37.331830, -122.030835),
  ),
);
final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init()).thenAnswer((_) async => null);
    when(GetIt.I.get<SharedPreferencesWrapper>().getString(StorageKeys.selectedLocaleTag)).thenReturn(_selectedLocaleTag);
  });

  group('Test search bar widget', () {
    testWidgets('Test inactive bar without results', (tester) async {
      await _testInactiveWithoutResults(tester);
    });
    testWidgets('Test active bar without results', (tester) async {
      await _testActiveWithoutResults(tester);
    });
    testWidgets('Test active bar with results', (tester) async {
      await _testActiveWithResults(tester);
    });
    testWidgets('Test on search tap callback', (tester) async {
      await _testOnSearchTapCallback(tester);
    });
    testWidgets('Test search bar callbacks', (tester) async {
      await _testSearchBarCallbacks(tester);
    });
  });
}

Future _testInactiveWithoutResults(WidgetTester tester) async {
  final widget = MapSearchBar(
    isSearchActive: false,
    textFieldFocusNode: FocusNode(),
  );
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: widget,
    ),
  ));
  final searchLabelFinder = find.text('Search by address, municipality…');
  final searchIconFinder = find.byIcon(Icons.search);
  final resultsFinder = find.byKey(Key('search results'));
  expect(searchLabelFinder, findsOneWidget);
  expect(searchIconFinder, findsOneWidget);
  expect(resultsFinder, findsNothing);
}

Future _testActiveWithoutResults(WidgetTester tester) async {
  final widget = MapSearchBar(
    isSearchActive: true,
    textFieldFocusNode: FocusNode(),
  );
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: widget,
    ),
  ));
  final textFieldFinder = find.byType(TextField);
  final closeIconFinder = find.byIcon(Icons.close);
  final resultsFinder = find.byKey(Key('search results'));
  expect(textFieldFinder, findsOneWidget);
  expect(closeIconFinder, findsOneWidget);
  expect(resultsFinder, findsNothing);
}

Future _testActiveWithResults(WidgetTester tester) async {
  final widget = MapSearchBar(
    isSearchActive: true,
    searchResults: [_searchResultItem],
    textFieldFocusNode: FocusNode(),
  );
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: widget,
    ),
  ));
  final resultsFinder = find.byKey(Key('search results'));
  expect(resultsFinder, findsOneWidget);
}

Future _testOnSearchTapCallback(WidgetTester tester) async {
  bool searchTapped = false;
  final widget = MapSearchBar(
    isSearchActive: false,
    textFieldFocusNode: FocusNode(),
    onSearchTap: () => searchTapped = true,
  );
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: widget,
    ),
  ));
  await tester.tap(find.byIcon(Icons.search));
  await tester.pump();
  expect(searchTapped, true);
}

Future _testSearchBarCallbacks(WidgetTester tester) async {
  bool cancelTapped = false;
  MapSearchItem? searchResult;
  String? searchEdit;
  final widget = MapSearchBar(
    isSearchActive: true,
    textFieldFocusNode: FocusNode(),
    searchResults: [_searchResultItem],
    onCancelSearchTap: () => cancelTapped = true,
    onSearchResultTap: (result) => searchResult = result,
    onSearchEdit: (value) => searchEdit = value,
  );
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: widget,
    ),
  ));
  await tester.tap(find.byIcon(Icons.close));
  await tester.tap(find.text(_searchResultItem.address));
  await tester.enterText(find.byType(TextField), 'query');
  await tester.pump();
  expect(cancelTapped, true);
  expect(searchResult, isNotNull);
  expect(searchEdit, 'query');
}
