import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/di/service-locator.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/store/core.state.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/core/widgets/bottom-navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../di/service-locator.dart';
import 'bottom-navigation-widget_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<SharedPreferencesWrapper>(
    as: #MockSharedPreferencesWrapperCalls,
    onMissingStub: OnMissingStub.returnDefault,
  )
])
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    ServiceLocator.registerInstances();
  });

  group('BottomNavigation with net neutrality enabled', () {
    testWidgets('basic state of the bottom navigation widget', (tester) async {
      ServiceLocator.registerInstances();
      SharedPreferencesWrapper _prefsEnabled =
          MockSharedPreferencesWrapperCalls();
      TestingServiceLocator.swapLazySingleton<SharedPreferencesWrapper>(
          () => _prefsEnabled);
      when(_prefsEnabled.getBool(StorageKeys.netNeutralityTestsEnabled))
          .thenReturn(true);
      await _setUpStateAndPumpWidget(tester);
      final testLabelFinder = find.text('Speed');
      final netNeutralityLabelFinder = find.text('Neutrality');
      final historyLabelFinder = find.text('Results');
      final settingsLabelFinder = find.text('Settings');
      expect(testLabelFinder, findsOneWidget);
      expect(netNeutralityLabelFinder, findsOneWidget);
      expect(historyLabelFinder, findsOneWidget);
      expect(settingsLabelFinder, findsOneWidget);
    });
  });

  group('BottomNavigation', () {
    testWidgets('basic state of the bottom navigation widget', (tester) async {
      ServiceLocator.registerInstances();
      SharedPreferencesWrapper _prefs = MockSharedPreferencesWrapperCalls();
      TestingServiceLocator.swapLazySingleton<SharedPreferencesWrapper>(
          () => _prefs);
      when(_prefs.getBool(StorageKeys.netNeutralityTestsEnabled))
          .thenReturn(false);
      await _setUpStateAndPumpWidget(tester);
      final testLabelFinder = find.text('Speed');
      final historyLabelFinder = find.text('Results');
      final settingsLabelFinder = find.text('Settings');
      expect(testLabelFinder, findsOneWidget);
      expect(historyLabelFinder, findsOneWidget);
      expect(settingsLabelFinder, findsOneWidget);
    });
  });
}

Future _setUpStateAndPumpWidget(WidgetTester tester) async {
  final state = CoreState();
  final cubit = setUpCoreCubit(state);
  await tester.pumpWidget(
    BlocProvider<CoreCubit>(
      create: (cntx) => cubit,
      child: MaterialApp(
        home: BottomNavigation(),
      ),
    ),
  );
}

class MockCoreCubit extends MockCubit<CoreState> implements CoreCubit {}

class CoreStateFake extends Fake implements CoreState {}

CoreCubit setUpCoreCubit(CoreState state) {
  final cubit = MockCoreCubit();
  whenListen(
    cubit,
    Stream.fromIterable([state]),
    initialState: state,
  );
  return cubit;
}
