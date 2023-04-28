import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/loop-mode.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/loop-mode-settings.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';
import 'package:nt_flutter_standalone/modules/settings/widgets/settings-editable-item.dart';
import 'package:sprintf/sprintf.dart';

import '../../di/service-locator.dart';
import 'loop-mode-agreement_test.mocks.dart';

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

final _cubit = MockSettingsCubit();
final _initialState = SettingsState();
final _uuid = 'uuid';
final _mockObserver = MockNavigatorObserver();

final _widgetTree = BlocProvider<SettingsCubit>(
  create: (context) => GetIt.I.get<SettingsCubit>(),
  child: MaterialApp(
      home: LoopModeSettingsScreen(), navigatorObservers: [_mockObserver]),
);
final String _selectedLocaleTag = 'sr-Latn-rs';

@GenerateMocks([], customMocks: [
  MockSpec<RouteObserver>(
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<NavigatorObserver>(
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<SettingsCubit>(
    as: #MockSettingsCubitCalls,
    onMissingStub: OnMissingStub.returnDefault,
  )
])
void main() {
  setUp(() async {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    TestingServiceLocator.swapLazySingleton<SettingsCubit>(() => _cubit);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
    when(GetIt.I
            .get<NavigationService>()
            .pushNamed(LoopModeSettingsScreen.route))
        .thenAnswer((realInvocation) async => null);
    whenListen(
        _cubit,
        Stream.fromIterable(
            [_initialState, _initialState.copyWith(clientUuid: _uuid)]),
        initialState: _initialState);
    await dotenv.load(fileName: '.env');
  });

  group('Loop mode settings screen', () {
    testWidgets('shows correct title in the app bar', (tester) async {
      await tester.pumpWidget(_widgetTree);
      expect(find.byType(NTAppBar), findsOneWidget);
      expect(find.text('Loop mode'), findsOneWidget);
    });

    testWidgets('shows correct body section', (tester) async {
      await tester.pumpWidget(_widgetTree);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('Number of measurements'), findsOneWidget);
      expect(find.text('Waiting time (minutes)'), findsOneWidget);
      expect(
          find.text(sprintf('Between %d min - %d mins', [
            LoopMode.loopModeWaitingTimeMinutesMin,
            LoopMode.loopModeWaitingTimeMinutesMax
          ])),
          findsOneWidget);
      expect(find.text('Distance (meters)'), findsOneWidget);
      expect(
          find.text(
              'When loop mode is enabled, new tests are automatically performed after the configured waiting time or when the devices moves more than the configured distance.'),
          findsOneWidget);
      // todo: removed until we do not have implementation for net neutrality tests
      // expect(find.text('Include Net Neutrality'), findsOneWidget);
      // expect(find.byType(CupertinoSwitch), findsOneWidget);
      // expect(find.byType(SettingsItem), findsOneWidget);
      expect(find.byType(SettingsEditableItem), findsNWidgets(2));
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text("Start test"), findsOneWidget);
    });

    testWidgets('shows default values', (tester) async {
      await tester.pumpWidget(_widgetTree);
      expect(find.text(LoopMode.loopModeDefaultMeasurementCount.toString()),
          findsOneWidget);
      expect(find.text(LoopMode.loopModeDefaultWaitingTimeMinutes.toString()),
          findsOneWidget);
      expect(find.text(LoopMode.loopModeDefaultDistanceMeters.toString()),
          findsOneWidget);
    });

    testWidgets('inserting correct values', (tester) async {
      await tester.pumpWidget(_widgetTree);
      final measurementCount = find.byKey(Key('lmc'));
      final measurementWaitingTime = find.byKey(Key('lmwt'));
      final measurementDistance = find.byKey(Key('lmd'));

      final measurementCountText =
          "${LoopMode.loopModeMeasurementCountMax - 1}";
      await tester.enterText(measurementCount, measurementCountText);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(find.text(measurementCountText), findsOneWidget);

      final waitingTimeText = "${LoopMode.loopModeWaitingTimeMinutesMax - 1}";
      await tester.enterText(measurementWaitingTime, waitingTimeText);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(find.text(waitingTimeText), findsOneWidget);

      final distanceText = "${LoopMode.loopModeDistanceMetersMax - 1}";
      await tester.enterText(measurementDistance, distanceText);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(find.text(distanceText), findsOneWidget);
    });

    testWidgets('inserting incorrect values', (tester) async {
      await tester.pumpWidget(_widgetTree);
      final measurementCount = find.byKey(Key('lmc'));
      final measurementWaitingTime = find.byKey(Key('lmwt'));
      final measurementDistance = find.byKey(Key('lmd'));

      final measurementCountText =
          "${LoopMode.loopModeMeasurementCountMax + 1}";
      await tester.enterText(measurementCount, measurementCountText);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      // TODO: test if snackbar is displayed with error
      // expect(find.text(measurementCountText), findsOneWidget);
      // expect(
      //     find.text(
      //         sprintf("Exception: Please insert value between %d and %d.", [
      //           LoopMode.LOOP_MODE_MEASUREMENT_COUNT_MIN,
      //           LoopMode.LOOP_MODE_MEASUREMENT_COUNT_MAX
      //         ])),
      //     findsOneWidget);

      final waitingTimeText = "${LoopMode.loopModeWaitingTimeMinutesMax + 1}";
      await tester.enterText(measurementWaitingTime, waitingTimeText);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(find.text(waitingTimeText), findsOneWidget);
      // TODO: test if snackbar is displayed with error
      // expect(
      //     find.text(
      //         sprintf("Exception: Please insert value between %d and %d.", [
      //           LoopMode.LOOP_MODE_WAITING_TIME_MINUTES_MIN,
      //           LoopMode.LOOP_MODE_WAITING_TIME_MINUTES_MAX
      //         ])),
      //     findsOneWidget);

      final distanceText = "${LoopMode.loopModeDistanceMetersMax + 1}";
      await tester.enterText(measurementDistance, distanceText);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(find.text(distanceText), findsOneWidget);
      // TODO: test if snackbar is displayed with error
      // expect(
      //     find.text(
      //         sprintf("Exception: Please insert value between %d and %d.", [
      //           LoopMode.LOOP_MODE_DISTANCE_METERS_MIN,
      //           LoopMode.LOOP_MODE_DISTANCE_METERS_MAX
      //         ])),
      //     findsOneWidget);
    });
  });
}
