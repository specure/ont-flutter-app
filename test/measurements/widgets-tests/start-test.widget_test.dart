import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/bloc-event.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/store/core.state.dart';
import 'package:nt_flutter_standalone/core/widgets/loop-mode.button.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/error.snackbar.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-error.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/home-info-box.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/start-test/start-test.widget.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/loop-mode-agreement.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';

import '../../core/unit-tests/dio-service_test.mocks.dart';
import '../../di/service-locator.dart';
import '../../settings/unit-tests/settings-cubit_test.mocks.dart';
import 'bottom-box-widget_test.dart';

final _servers = [
  MeasurementServer(
    id: 1,
    uuid: 'uuid',
    city: 'Cupertino',
    name: 'Name',
  )
];

class MockMeasurementsBloc extends MockBloc<BlocEvent, MeasurementsState>
    implements MeasurementsBloc {}

class MockSettingsCubitStart extends MockCubit<SettingsState>
    implements SettingsCubit {}

class MeasurementsStateFake extends Fake implements MeasurementsState {}

final _initialSettingsState = SettingsState();

late MeasurementsState _state;
late MeasurementsBloc _bloc;
final _settingsCubit = MockSettingsCubitStart();
final _uuid = 'uuid';
final String _selectedLocaleTag = 'sr-Latn-rs';

@GenerateMocks([], customMocks: [
  MockSpec<RouteObserver>(
    onMissingStub: OnMissingStub.returnDefault,
  ),
])
void main() {
  setUp(() {
    TestingServiceLocator.swapLazySingleton<SettingsCubit>(
        () => _settingsCubit);
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    TestingServiceLocator.swapLazySingleton<CoreCubit>(() => MockCoreCubit());
    when(GetIt.I.get<CoreCubit>().state)
        .thenReturn(CoreState(project: NTProject()));
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
    whenListen(
        _settingsCubit,
        Stream.fromIterable([
          _initialSettingsState,
          _initialSettingsState.copyWith(clientUuid: _uuid)
        ]),
        initialState: _initialSettingsState);
  });

  group('Test start test widget with connection', () {
    setUp(() {
      _state = MeasurementsState.init().copyWith(
        connectivity: ConnectivityResult.wifi,
        servers: _servers,
        currentServer: _servers.first,
      );
      _bloc = setUpMeasurementsBloc(_state);
      TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => _bloc);
      when(GetIt.I.get<SharedPreferencesWrapper>().init())
          .thenAnswer((_) async => null);
      when(GetIt.I
              .get<SharedPreferencesWrapper>()
              .getString(StorageKeys.selectedLocaleTag))
          .thenReturn(_selectedLocaleTag);
    });

    testWidgets(
        'measurement server, start button and network info box are shown',
        (tester) async {
      await tester.pumpWidget(getNecessaryParentWidgets<MeasurementsBloc>(
          _bloc, StartTestWidget()));
      expect(find.text('Name (Cupertino)'), findsOneWidget);
      expect(find.byType(HomeInfoBox), findsOneWidget);
      expect(find.text('Run speed measurements'), findsOneWidget);
    });

    testWidgets('hero image is correctly shown', (tester) async {
      await tester.pumpWidget(getNecessaryParentWidgets<MeasurementsBloc>(
          _bloc, StartTestWidget()));
      final heroImageFinder = find.byKey(Key('home-screen-hero'));
      expect(heroImageFinder, findsOneWidget);
    });

    testWidgets('start button works', (tester) async {
      await tester.pumpWidget(getNecessaryParentWidgets<MeasurementsBloc>(
          _bloc, StartTestWidget()));
      if (GetIt.I.isRegistered<MeasurementsBloc>()) {
        GetIt.I.unregister<MeasurementsBloc>();
      }
      final bloc = MockMeasurementsBlocCalls();
      when(bloc.add(any)).thenReturn(null);
      GetIt.I.registerLazySingleton<MeasurementsBloc>(() => bloc);
      await tester.tap(find.text('Run speed measurements'));
      verify(bloc.add(any)).called(1);
    });
  });

  group('Test start test widget without connection', () {
    setUp(() {
      _state = MeasurementsState.init().copyWith(
        servers: _servers,
        currentServer: _servers.first,
        connectivity: ConnectivityResult.none,
      );
      _bloc = setUpMeasurementsBloc(_state);
      TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => _bloc);
    });

    testWidgets(
        'measurement server, start button and network info box are NOT shown',
        (tester) async {
      await tester.pumpWidget(getNecessaryParentWidgets<MeasurementsBloc>(
          _bloc, StartTestWidget()));
      expect(find.text('Name (Cupertino)'), findsNothing);
      expect(find.byType(HomeInfoBox), findsNothing);
      expect(find.text('Run speed measurements'), findsNothing);
    });
    testWidgets('hero image is correctly shown', (tester) async {
      await tester.pumpWidget(getNecessaryParentWidgets<MeasurementsBloc>(
          _bloc, StartTestWidget()));
      final heroImageFinder = find.byKey(Key('home-screen-hero'));
      expect(heroImageFinder, findsOneWidget);
    });
  });

  group('Test start test widget with connection in the portrait mode', () {
    setUp(() {
      _state = MeasurementsState.init().copyWith(
        connectivity: ConnectivityResult.wifi,
        servers: _servers,
        currentServer: _servers.first,
      );
      _bloc = setUpMeasurementsBloc(_state);
    });

    testWidgets(
        'measurement server, start button and network info box are shown',
        (tester) async {
      tester.view.physicalSize = Size(1200, 1920);
      await tester.pumpWidget(getNecessaryParentWidgets<MeasurementsBloc>(
          _bloc, StartTestWidget()));
      expect(find.text('Name (Cupertino)'), findsOneWidget);
      expect(find.byType(HomeInfoBox), findsOneWidget);
      expect(find.text('Run speed measurements'), findsOneWidget);
    });
    testWidgets('hero image is correctly shown', (tester) async {
      tester.view.physicalSize = Size(1200, 1920);
      await tester.pumpWidget(getNecessaryParentWidgets<MeasurementsBloc>(
          _bloc, StartTestWidget()));
      final heroImageFinder = find.byKey(Key('home-screen-hero'));
      expect(heroImageFinder, findsOneWidget);
    });
  });

  group('Test start test widget without connection in the portrait mode', () {
    setUp(() {
      _state = MeasurementsState.init().copyWith(
        servers: _servers,
        currentServer: _servers.first,
        connectivity: ConnectivityResult.none,
      );
      _bloc = setUpMeasurementsBloc(_state);
      TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => _bloc);
    });

    testWidgets(
        'measurement server, start button and network info box are not shown',
        (tester) async {
      tester.view.physicalSize = Size(1200, 1920);
      await tester.pumpWidget(getNecessaryParentWidgets<MeasurementsBloc>(
          _bloc, StartTestWidget()));
      expect(find.text('Name (Cupertino)'), findsNothing);
      expect(find.byType(HomeInfoBox), findsNothing);
      expect(find.text('Run speed measurements'), findsNothing);
    });
    testWidgets('hero image is correctly shown', (tester) async {
      tester.view.physicalSize = Size(1200, 1920);
      await tester.pumpWidget(getNecessaryParentWidgets<MeasurementsBloc>(
          _bloc, StartTestWidget()));
      final heroImageFinder = find.byKey(Key('home-screen-hero'));
      expect(heroImageFinder, findsOneWidget);
    });
  });

  group('Test start test widget with error', () {
    testWidgets('AlertDialog is shown for a measurement error', (tester) async {
      final error = MeasurementError();
      _setUpError(error);
      await tester.pumpWidget(getNecessaryParentWidgets<MeasurementsBloc>(
          _bloc, StartTestWidget()));
      expect(find.text('Name (Cupertino)'), findsOneWidget);
      expect(find.byType(HomeInfoBox), findsOneWidget);
      expect(find.text('Run speed measurements'), findsOneWidget);
      expect(find.byType(NTErrorSnackbar), findsNothing);
      expect(find.byType(AlertDialog), findsNothing);
      await tester.pump();
      expect(find.text('Name (Cupertino)'), findsOneWidget);
      expect(find.byType(HomeInfoBox), findsOneWidget);
      expect(find.text('Run speed measurements'), findsOneWidget);
      expect(find.byType(NTErrorSnackbar), findsNothing);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(SectionTitle), findsNWidgets(2));
      expect(find.text(error.toString()), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      expect(find.text('Finish'), findsOneWidget);
      if (GetIt.I.isRegistered<MeasurementsBloc>()) {
        GetIt.I.unregister<MeasurementsBloc>();
      }
      final blocCalls = MockMeasurementsBlocCalls();
      GetIt.I.registerLazySingleton<MeasurementsBloc>(() => blocCalls);
      when(GetIt.I.get<NavigationService>().goBack()).thenReturn(null);
      await tester.tap(find.text('Try again'));
      verify(blocCalls.add(any)).called(1);
      verify(GetIt.I.get<NavigationService>().goBack()).called(1);
      await tester.tap(find.text('Finish'));
      verify(blocCalls.add(any)).called(1);
      verify(GetIt.I.get<NavigationService>().goBack()).called(1);
      GetIt.I.unregister<MeasurementsBloc>();
    });

    testWidgets('AlertDialog is not shown for a non-measurement error',
        (tester) async {
      final error = Exception('Test error');
      _setUpError(error);
      await tester.pumpWidget(getNecessaryParentWidgets<MeasurementsBloc>(
          _bloc, StartTestWidget()));
      expect(find.text('Name (Cupertino)'), findsOneWidget);
      expect(find.byType(HomeInfoBox), findsOneWidget);
      expect(find.text('Run speed measurements'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
      await tester.pump();
      expect(find.text('Name (Cupertino)'), findsOneWidget);
      expect(find.byType(HomeInfoBox), findsOneWidget);
      expect(find.text('Run speed measurements'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  testWidgets('Test start test widget init on pop', (tester) async {
    if (GetIt.I.isRegistered<MeasurementsBloc>()) {
      GetIt.I.unregister<MeasurementsBloc>();
    }
    final blocCalls = MockMeasurementsBlocCalls();
    when(blocCalls.state)
        .thenReturn(MeasurementsState.init().copyWith(isContinuing: true));
    GetIt.I.registerLazySingleton<MeasurementsBloc>(() => blocCalls);
    final widget = StartTestWidget();
    widget.didPop();
    verify(blocCalls.state).called(1);
    when(blocCalls.state).thenReturn(MeasurementsState.init());
    widget.didPop();
    verify(blocCalls.state).called(1);
    verify(blocCalls.add(any));
    GetIt.I.unregister<MeasurementsBloc>();
  });

  group('Test loop mode', () {
    setUp(() {
      TestingServiceLocator.swapLazySingleton<SettingsCubit>(
          () => _settingsCubit);
      var _settingsState = _initialSettingsState.copyWith(
          clientUuid: _uuid, loopModeFeatureEnabled: true);
      TestingServiceLocator.registerInstances(withRealLocalization: true);
      whenListen(_settingsCubit, Stream.fromIterable([_settingsState]),
          initialState: _settingsState);

      _state = MeasurementsState.init().copyWith(
        connectivity: ConnectivityResult.wifi,
        servers: _servers,
        currentServer: _servers.first,
      );
      _bloc = setUpMeasurementsBloc(_state);
      TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => _bloc);
      when(GetIt.I
              .get<NavigationService>()
              .pushNamed(LoopModeAgreementScreen.route))
          .thenAnswer((realInvocation) async => null);
    });

    testWidgets('enabling', (tester) async {
      tester.view.physicalSize = Size(1920, 1200);
      await tester.pumpWidget(getNecessaryParentWidgets<MeasurementsBloc>(
          _bloc, StartTestWidget()));
      expect(find.text('Name (Cupertino)'), findsOneWidget);
      expect(find.byType(HomeInfoBox), findsOneWidget);
      expect(find.text('Run speed measurements'), findsOneWidget);
      expect(find.text('Loop mode'), findsOneWidget);
      final loopModeButton = find.byType(LoopModeButton);
      expect(loopModeButton, findsOneWidget);
      await tester.ensureVisible(loopModeButton);
      await tester.tap(loopModeButton);
      await tester.pumpAndSettle();
      verify(GetIt.I
              .get<NavigationService>()
              .pushNamed(LoopModeAgreementScreen.route))
          .called(1);
    });

    testWidgets('disabling', (tester) async {
      tester.view.physicalSize = Size(1920, 1200);
      final _settingsState = _initialSettingsState.copyWith(
          clientUuid: _uuid,
          loopModeFeatureEnabled: true,
          loopModeEnabled: true);
      whenListen(
          _settingsCubit,
          Stream.fromIterable([
            _settingsState,
            _settingsState.copyWith(
                clientUuid: _settingsState.clientUuid, loopModeEnabled: false)
          ]),
          initialState: _settingsState);

      await tester.pumpWidget(getNecessaryParentWidgets<MeasurementsBloc>(
          _bloc, StartTestWidget()));
      expect(find.text('Name (Cupertino)'), findsOneWidget);
      expect(find.byType(HomeInfoBox), findsOneWidget);
      expect(find.text('Run speed measurements'), findsOneWidget);
      expect(find.byType(LoopModeButton), findsNWidgets(2));
      final loopModeButton = find.text('Loop mode');
      expect(loopModeButton, findsOneWidget);
      await tester.ensureVisible(loopModeButton);
      await tester.tap(loopModeButton);
      await tester.pumpAndSettle();
      verifyNever(GetIt.I
          .get<NavigationService>()
          .pushNamed(LoopModeAgreementScreen.route));
    });
  });
}

_setUpError(Exception error) {
  final initState = MeasurementsState.init().copyWith(
    connectivity: ConnectivityResult.wifi,
    servers: _servers,
    currentServer: _servers.first,
  );
  final errorState = initState.copyWith(error: error);
  _bloc = setUpMeasurementsBloc(initState, [errorState]);
  TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => _bloc);
  when(GetIt.I.get<PlatformWrapper>().isAndroid).thenReturn(false);
}

Widget getNecessaryParentWidgets<T extends Bloc>(T bloc, Widget child) {
  return BlocProvider.value(
    value: bloc,
    child: MediaQuery(
      data: MediaQueryData(size: Size(800, 1200)),
      child: MaterialApp(
        home: child,
      ),
    ),
  );
}
