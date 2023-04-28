import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-list-factory.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-result/net-neutrality-result.screen.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../di/service-locator.dart';

class MockNetNeutralityCubit extends MockCubit<NetNeutralityState>
    implements NetNeutralityCubit {}

final _historyJson = jsonDecode(
    File('test/net-neutrality/unit-tests/data/net-neutrality-history.json')
        .readAsStringSync());
final _history = NetNeutralityHistoryListFactory.parseHistoryResponse(
  _historyJson,
);
final NetNeutralityCubit _cubit = MockNetNeutralityCubit();
final NetNeutralityState _state =
    NetNeutralityState(interimResults: [], historyResults: _history);
final Widget _screen = BlocProvider<NetNeutralityCubit>(
  create: (context) => _cubit,
  child: MaterialApp(home: const NetNeutralityResultScreen()),
);

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    whenListen(_cubit, Stream.fromIterable([_state]), initialState: _state);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn('en-US');
    when(GetIt.I.get<NavigationService>().goBack())
        .thenAnswer((realInvocation) => null);
  });

  group('Net neutrality result screen', () {
    testWidgets("shows results", (tester) async {
      await tester.pumpWidget(_screen);
      await tester.pumpAndSettle();
      final tabs = find.byType(DefaultTabController);
      expect(tabs, findsOneWidget);
      final tabbar = find.byType(TabBar);
      expect(tabbar, findsOneWidget);
      final tabsInTabBar = find.byType(Tab);
      expect(tabsInTabBar, findsNWidgets(2));
      expect(find.text("Net neutrality results"), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byType(SectionTitle), findsNWidgets(3));
      expect(find.text("PERFORMED"), findsOneWidget);
      expect(find.text("FAILED"), findsOneWidget);
      expect(find.text("PASSED"), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(PieChart), findsNWidgets(_state.categories.length));
      for (final category in _state.categories) {
        expect(find.text(category.name), findsOneWidget);
      }
    });
  });
}
