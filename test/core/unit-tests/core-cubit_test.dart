import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/settings.screen.dart';

import '../../di/service-locator.dart';
import '../../measurements/widgets-tests/home-screen.widget_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<SharedPreferencesWrapper>(
    as: #MockSharedPreferencesWrapperCalls,
    onMissingStub: OnMissingStub.returnDefault,
  )
])
void main() {
  group('Test core cubit', () {
    final int defaultIndex = 0;
    TestingServiceLocator.registerInstances();
    SharedPreferencesWrapper _prefsEnabled =
        MockSharedPreferencesWrapperCalls();
    TestingServiceLocator.swapLazySingleton<SharedPreferencesWrapper>(
        () => _prefsEnabled);

    test('Test core cubit default', () {
      final cubit = CoreCubit();
      expect(cubit.state.currentScreen, defaultIndex);
    });

    test('Test core cubit changed index to higher than screen count', () {
      final cubit = CoreCubit();
      cubit.onItemTap(100);
      expect(cubit.state.currentScreen, 2);
    });

    test('Test core cubit changed index to lower than 0', () {
      final cubit = CoreCubit();
      cubit.onItemTap(-1);
      expect(cubit.state.currentScreen, 0);
    });

    test('Test core cubit changed index in the range of screen count', () {
      final cubit = CoreCubit();
      final index = Random().nextInt(3);
      cubit.onItemTap(index);
      expect(cubit.state.currentScreen, index);
    });

    test('Test core cubit go to screen default', () {
      final cubit = CoreCubit();
      cubit.goToScreen();
      expect(cubit.state.currentScreen, 0);
    });

    test('Test core cubit go to Settings screen', () {
      final cubit = CoreCubit();
      cubit.goToScreen<SettingsScreen>();
      expect(cubit.state.currentScreen, 2);
    });
  });
}
