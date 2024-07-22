import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/widgets/gradient-button.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/onboarding/screens/wizard.screen.dart';
import 'package:nt_flutter_standalone/modules/onboarding/store/wizard.cubit.dart';
import 'package:nt_flutter_standalone/modules/onboarding/store/wizard.state.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/welcome-message.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/wizard-accuracy-item.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/wizard-accuracy/wizard-accuracy.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/wizard-rotated-gradient-box.widget.dart';

import '../../di/service-locator.dart';

class MockWizardCubit extends MockCubit<WizardState> implements WizardCubit {}

class MockWizardCubitStubbed extends Mock implements WizardCubit {}

late WizardCubit _cubit;
late WizardState _initState;
final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() {
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
    when(GetIt.I.get<PlatformWrapper>().isAndroid).thenReturn(true);
    when(GetIt.I.get<PlatformWrapper>().isIOS).thenReturn(false);

    _cubit = MockWizardCubit();
    _initState = WizardState();
    GetIt.I.registerLazySingleton<WizardCubit>(() => _cubit);
    whenListen(
      _cubit,
      Stream.fromIterable([_initState, _initState]),
      initialState: _initState,
    );
  });

  callTester(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const WizardScreen(),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(WizardRoratedGradientBox), findsOneWidget);
    expect(find.byType(WizardAccuracy), findsOneWidget);
    expect(find.byType(WelcomeMessage), findsOneWidget);
    expect(find.text("Open Nettest Accuracy"), findsOneWidget);
    expect(
      find.text("Phone Permissions", skipOffstage: false),
      findsOneWidget,
    );
    expect(
      find.text("Location Permissions", skipOffstage: false),
      findsOneWidget,
    );
    await tester.dragUntilVisible(find.byKey(ValueKey('clientUuid')),
        find.byType(ListView), Offset(0, -100));
    await tester.pumpAndSettle();
    expect(
      find.text("Persistent Client UUID", skipOffstage: false),
      findsOneWidget,
    );
    expect(
      find.text("Notification Permissions", skipOffstage: false),
      findsOneWidget,
    );
    await tester.dragUntilVisible(find.byKey(ValueKey('analytics')),
        find.byType(ListView), Offset(0, -100));
    await tester.pumpAndSettle();
    expect(
      find.text(
          "Help us improve #appName"
              .replaceAll('#appName', Environment.appName),
          skipOffstage: false),
      findsOneWidget,
    );
    final button = find.byType(GradientButton);
    expect(button, findsOneWidget);
    expect(
      (tester.widget<GradientButton>(button).child as Text).data,
      "Continue",
    );
    GetIt.I.unregister<WizardCubit>();
    GetIt.I
        .registerLazySingleton<WizardCubit>((() => MockWizardCubitStubbed()));
    when(GetIt.I.get<WizardCubit>().handlePermissions())
        .thenAnswer((realInvocation) async => null);
    await tester.tap(button);
    await tester.pumpAndSettle();
    verify(GetIt.I.get<WizardCubit>().handlePermissions()).called(1);
  }

  group("Wizard Accuracy screen", () {
    testWidgets(
      "shows accuracy widget on Android in the landscape mode",
      (tester) async {
        tester.binding.window.physicalSizeTestValue = Size(2650, 1200);
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
        callTester(tester);
      },
    );
    testWidgets(
      "shows accuracy widget on Android in the portrait mode",
      (tester) async {
        tester.binding.window.physicalSizeTestValue = Size(1200, 2560);
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
        callTester(tester);
      },
    );
  });
}
