import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/store/core.state.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/providers.button.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/technology.bar.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/technology.button.dart';

import '../../di/service-locator.dart';
import '../../measurements/widgets-tests/home-screen.widget_test.dart';
import '../unit-tests/map-cubit_test.dart';

final String _selectedLocaleTag = 'sr-Latn-rs';
final _initialState =
    MapState(providers: ["All"], technologies: mnoTechnologies);

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

  group('Test technology bar widget', () {
    testWidgets('Test collapsed technology bar', (tester) async {
      await _buildWidget(tester, _initialState);
      final technologyFinder = find.byType(TechnologyButton);
      final providerFinder = find.text('All Mobile Network Operators');
      expect(technologyFinder, findsOneWidget);
      expect(providerFinder, findsOneWidget);
    });

    testWidgets('Test expanded technology bar', (tester) async {
      await _buildWidget(
        tester,
        _initialState.copyWith(isTechnologyBarExpanded: true),
      );
      final technologyFinder = find.byType(TechnologyButton);
      final providersButtonFinder = find.byType(ProvidersButton);
      final radioFinder = find.byType(Radio<bool>);
      expect(technologyFinder, findsNWidgets(5));
      expect(providersButtonFinder, findsOneWidget);
      expect(radioFinder, findsNWidgets(2));

      TestingServiceLocator.swapLazySingleton<MapCubit>(
          () => MockMapCubitCalls());
      when(GetIt.I.get<MapCubit>().onProvidersTap())
          .thenAnswer((realInvocation) {});
      await tester.tap(providersButtonFinder);
      verify(GetIt.I.get<MapCubit>().onProvidersTap()).called(1);

      when(GetIt.I.get<MapCubit>().onIspMnoSwitch(true))
          .thenAnswer((realInvocation) {});
      await tester.tap(find.byWidgetPredicate(
        (widget) => widget is Radio<bool> && widget.value == true,
      ));
      verify(GetIt.I.get<MapCubit>().onIspMnoSwitch(true)).called(1);
      await tester.tap(find.text('Fixed-Line Providers'));
      verify(GetIt.I.get<MapCubit>().onIspMnoSwitch(true)).called(1);
    });
  });

  testWidgets('Expanded technology bar with active ISPs', (tester) async {
    await _buildWidget(
      tester,
      _initialState.copyWith(isTechnologyBarExpanded: true, isIspActive: true),
    );
    TestingServiceLocator.swapLazySingleton<MapCubit>(
        () => MockMapCubitCalls());
    when(GetIt.I.get<MapCubit>().onIspMnoSwitch(false))
        .thenAnswer((realInvocation) {});
    await tester.tap(find.byWidgetPredicate(
      (widget) => widget is Radio<bool> && widget.value == false,
    ));
    verify(GetIt.I.get<MapCubit>().onIspMnoSwitch(false)).called(1);
    await tester.tap(find.text('Mobile Network Operators'));
    verify(GetIt.I.get<MapCubit>().onIspMnoSwitch(false)).called(1);
  });
}

Future<void> _buildWidget(WidgetTester tester, MapState state) async {
  TestingServiceLocator.swapLazySingleton<MapCubit>(() => MockMapCubit());
  TestingServiceLocator.swapLazySingleton<CoreCubit>(() => MockCoreCubit());
  final mapCubit = GetIt.I.get<MapCubit>();
  final coreCubit = GetIt.I.get<CoreCubit>();
  final coreState = CoreState(project: NTProject(enableMapMnoIspSwitch: true));
  whenListen(mapCubit, Stream.fromIterable([state]), initialState: state);
  whenListen(
    coreCubit,
    Stream.fromIterable([coreState]),
    initialState: coreState,
  );
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: MultiBlocProvider(
        child: TechnologyBar(),
        providers: [
          BlocProvider<MapCubit>(
            create: (context) => mapCubit,
          ),
          BlocProvider<CoreCubit>(
            create: (context) => coreCubit,
          )
        ],
      ),
    ),
  ));
  await tester.pumpAndSettle();
}
