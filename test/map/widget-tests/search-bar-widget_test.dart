import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.item.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/search.bar.dart';

import '../../di/service-locator.dart';
import '../unit-tests/map-cubit_test.dart';

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
final _initialState =
    MapState(providers: ["All"], technologies: mnoTechnologies);
final _focusNode = FocusNode();

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

  group('Test search bar widget', () {
    testWidgets('Test inactive bar without results', (tester) async {
      await _buildWidget(tester, _initialState.copyWith(isSearchActive: false));
      final searchLabelFinder = find.text('Search by address, municipality…');
      final searchIconFinder = find.byIcon(Icons.search);
      final resultsFinder = find.byKey(Key('search results'));
      expect(searchLabelFinder, findsOneWidget);
      expect(searchIconFinder, findsOneWidget);
      expect(resultsFinder, findsNothing);
    });

    testWidgets('Test active bar without results', (tester) async {
      await _buildWidget(tester, _initialState.copyWith(isSearchActive: true));
      final textFieldFinder = find.byType(TextField);
      final closeIconFinder = find.byIcon(Icons.close);
      final resultsFinder = find.byKey(Key('search results'));
      expect(textFieldFinder, findsOneWidget);
      expect(closeIconFinder, findsOneWidget);
      expect(resultsFinder, findsNothing);
    });

    testWidgets('Test active bar with results', (tester) async {
      await _buildWidget(
        tester,
        _initialState.copyWith(
          isSearchActive: true,
          searchResults: [_searchResultItem],
        ),
      );
      final resultsFinder = find.byKey(Key('search results'));
      expect(resultsFinder, findsOneWidget);
    });

    testWidgets('Test on search tap callback', (tester) async {
      await _buildWidget(
        tester,
        _initialState.copyWith(isSearchActive: false),
      );
      TestingServiceLocator.swapLazySingleton<MapCubit>(
          () => MockMapCubitCalls());
      when(GetIt.I.get<MapCubit>().onSearchTap(_focusNode))
          .thenAnswer((realInvocation) {});
      await tester.tap(find.byIcon(Icons.search));
      verify(GetIt.I.get<MapCubit>().onSearchTap(_focusNode)).called(1);
    });

    testWidgets('Test search cancelling', (tester) async {
      await _buildWidget(
        tester,
        _initialState.copyWith(
          isSearchActive: true,
          searchResults: [_searchResultItem],
        ),
      );
      TestingServiceLocator.swapLazySingleton<MapCubit>(
          () => MockMapCubitCalls());
      when(GetIt.I.get<MapCubit>().onCancelSearchTap())
          .thenAnswer((realInvocation) {});
      await tester.tap(find.byIcon(Icons.close));
      verify(GetIt.I.get<MapCubit>().onCancelSearchTap()).called(1);
    });
  });

  testWidgets('Test search result tap', (tester) async {
    await _buildWidget(
      tester,
      _initialState.copyWith(
        isSearchActive: true,
        searchResults: [_searchResultItem],
      ),
    );
    TestingServiceLocator.swapLazySingleton<MapCubit>(
        () => MockMapCubitCalls());
    when(GetIt.I.get<MapCubit>().onSearchResultTap(_searchResultItem))
        .thenAnswer((realInvocation) {});
    final resultSelector = find.text(_searchResultItem.address);
    expect(resultSelector, findsOneWidget);
    await tester.tap(resultSelector);
    verify(GetIt.I.get<MapCubit>().onSearchResultTap(_searchResultItem))
        .called(1);
  });

  testWidgets('Test search edit', (tester) async {
    await _buildWidget(
      tester,
      _initialState.copyWith(
        isSearchActive: true,
        searchResults: [_searchResultItem],
      ),
    );
    TestingServiceLocator.swapLazySingleton<MapCubit>(
        () => MockMapCubitCalls());
    final query = 'query';
    when(GetIt.I.get<MapCubit>().onSearchEdit(query))
        .thenAnswer((realInvocation) async {});
    await tester.enterText(find.byType(TextField), query);
    verify(GetIt.I.get<MapCubit>().onSearchEdit(query)).called(1);
  });
}

Future<void> _buildWidget(WidgetTester tester, MapState state) async {
  TestingServiceLocator.swapLazySingleton<MapCubit>(() => MockMapCubit());
  final mapCubit = GetIt.I.get<MapCubit>();
  whenListen(mapCubit, Stream.fromIterable([state]), initialState: state);
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: BlocProvider<MapCubit>(
        create: (context) => mapCubit,
        child: MapSearchBar(
          focusNode: _focusNode,
        ),
      ),
    ),
  ));
  await tester.pumpAndSettle();
}
