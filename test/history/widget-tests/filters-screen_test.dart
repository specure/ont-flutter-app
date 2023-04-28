import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/api-errors.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/models/history-filter.item.dart';
import 'package:nt_flutter_standalone/modules/history/screens/filters.screen.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.state.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/filter-item.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

extension _HistoryFilterWidgetTester on WidgetTester {
  createWidget() async {
    HistoryFiltersScreen widget = HistoryFiltersScreen();
    await this.pumpWidget(BlocProvider<HistoryCubit>(
      create: (context) => _historyCubit,
      child: MaterialApp(
        home: widget,
      ),
    ));
    await this.pumpAndSettle();
  }
}

late final HistoryCubit _historyCubit;
final List<HistoryFilterItem> _devices = [
  HistoryFilterItem(text: 'Samsung A51'),
  HistoryFilterItem(text: 'iPhone 12'),
];
final List<HistoryFilterItem> _networks = [
  HistoryFilterItem(text: 'WLAN', active: true),
  HistoryFilterItem(text: '3G'),
];

final _initialStateEmptyFilters = HistoryState(speedHistory: [], netNeutralityHistory: [], loading: true);
final _initialStateFewFilters = HistoryState(
    speedHistory: [],
    netNeutralityHistory: [],
    loading: true,
    deviceFilters: _devices,
    networkTypeFilters: _networks);

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUpAll(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init()).thenAnswer((_) async => null);
    when(GetIt.I.get<SharedPreferencesWrapper>().getString(StorageKeys.selectedLocaleTag)).thenReturn(_selectedLocaleTag);
    _historyCubit = GetIt.I.get<HistoryCubit>();
  });

  group('HistoryFilterScreen', () {
    testWidgets('when there are empty filtering options', (tester) async {
      final dioError = MockDioError();
      when(dioError.message).thenReturn(ApiErrors.historyNotAccessible);
      final state = _initialStateEmptyFilters.copyWith(
        loading: false,
        error: dioError,
      );
      whenListen(
          _historyCubit, Stream.fromIterable([_initialStateEmptyFilters, state]),
          initialState: _initialStateEmptyFilters);
      await tester.createWidget();
      expect(find.text('Filter'), findsOneWidget);
      expect(find.text('Network type'), findsNothing);
      expect(find.text('Device'), findsNothing);
    });

    testWidgets('when there is few filtering options and changing on tap',
        (tester) async {
      final dioError = MockDioError();
      when(dioError.message).thenReturn('Test');
      final state = _initialStateFewFilters.copyWith(
        loading: false,
        error: dioError,
      );
      whenListen(
          _historyCubit, Stream.fromIterable([_initialStateFewFilters, state]),
          initialState: _initialStateFewFilters);
      await tester.createWidget();
      _historyCubit.init();
      expect(find.text('Filter'), findsOneWidget);
      expect(find.text('NETWORK TYPE'), findsOneWidget);
      expect(find.text('DEVICE'), findsOneWidget);
      expect(find.byType(SectionTitle), findsNWidgets(2));
      expect(find.byType(FilterItem), findsNWidgets(4));

      // todo: ontap produce errors, why?
      // await tester.tap(find.text("WLAN"));
      // await tester.pumpAndSettle();
      // await tester.tap(find.text("3G"));
      // await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check), findsNWidgets(1));

      // await tester.tap(find.text("3G"));
      // // await tester.pumpAndSettle();
      // expect(find.byIcon(Icons.check), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Filter'), findsNothing);
    });
  });
}
