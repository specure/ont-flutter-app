import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/widgets/loop-mode.button.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/widgets/gradient-button.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/header-with-logo.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/onboarding/screens/welcome/welcome.screen.dart';
import 'package:nt_flutter_standalone/modules/onboarding/screens/wizard.screen.dart';
import 'package:nt_flutter_standalone/modules/onboarding/store/wizard.cubit.dart';
import 'package:nt_flutter_standalone/modules/onboarding/store/wizard.state.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/welcome-button.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/welcome-image.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/welcome-message.widget.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';

import '../../di/service-locator.dart';

class MockWizardCubit extends MockCubit<WizardState> implements WizardCubit {}

class MockSettingsCubitWelcome extends MockCubit<SettingsState>
    implements SettingsCubit {}

final _initialSettingsState = SettingsState();
final _settingsCubit = MockSettingsCubitWelcome();
final _uuid = 'uuid';
final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() {
    TestingServiceLocator.swapLazySingleton<SettingsCubit>(
        () => _settingsCubit);
    whenListen(
        _settingsCubit,
        Stream.fromIterable([
          _initialSettingsState,
          _initialSettingsState.copyWith(
              clientUuid: _uuid, loopModeFeatureEnabled: true)
        ]),
        initialState: _initialSettingsState);
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
    if (GetIt.I.isRegistered<WizardCubit>()) {
      GetIt.I.unregister<WizardCubit>();
    }
    when(GetIt.I.get<PlatformWrapper>().isAndroid).thenReturn(false);
    when(GetIt.I.get<PlatformWrapper>().isIOS).thenReturn(true);
    final cubit = MockWizardCubit();
    final initState = WizardState();
    GetIt.I.registerLazySingleton<WizardCubit>(() => cubit);
    whenListen(
      cubit,
      Stream.fromIterable([initState, initState]),
      initialState: initState,
    );
  });

  group("Welcome screen", () {
    final callTester = (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: const WelcomeScreen(),
        routes: {
          WizardScreen.route: (context) => const WizardScreen(),
        },
      ));
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(HeaderWithLogo), findsOneWidget);
      expect(find.byType(LoopModeButton), findsNothing);
      expect(find.byType(WelcomeImage), findsOneWidget);
      expect(find.byKey(HeaderWithLogo.logoKey), findsOneWidget);
      final logoProvider =
          (find.byKey(HeaderWithLogo.logoKey).evaluate().single.widget as Image)
              .image as AssetImage;
      expect(logoProvider.assetName, 'config/.nt/images/logo.png');
      expect(find.byKey(WelcomeImage.imageKey), findsOneWidget);
      final picProvider = (find
              .byKey(WelcomeImage.imageKey)
              .evaluate()
              .single
              .widget as SvgPicture)
          .bytesLoader as SvgAssetLoader;
      expect(picProvider.assetName, 'config/.nt/images/splash-screen-hero.svg');
      expect(find.byType(WelcomeMessage), findsOneWidget);
      expect(find.text("Welcome to Open Nettest"), findsOneWidget);
      expect(find.text("Let's Review your Privacy Options"), findsOneWidget);
      expect(find.byType(WelcomeButton), findsOneWidget);
      expect(find.byType(GradientButton), findsOneWidget);
      expect(
          (tester.widget<GradientButton>(find.byType(GradientButton)).child
                  as Text)
              .data,
          "Next");
      await tester.tap(find.byType(GradientButton));
      await tester.pumpAndSettle();
      expect(find.text("Open Nettest Accuracy"), findsOneWidget);
    };

    testWidgets(
      "shows and interacts with all the elements correctly in the landscape mode",
      callTester,
    );

    testWidgets(
        "shows and interacts with all the elements correctly in the portrait mode",
        (tester) async {
      tester.view.physicalSize = Size(800, 1600);
      addTearDown(tester.view.resetPhysicalSize);
      callTester(tester);
    });
  });
}
