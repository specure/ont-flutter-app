import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/store/core.state.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/core/widgets/bottom-navigation.dart';
import 'package:nt_flutter_standalone/modules/history/screens/history.screen.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/screens/home.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';

import '../../di/service-locator.dart';
import '../../settings/widget-tests/settings-screen_test.dart';
import 'home-screen.widget_test.mocks.dart';
import 'start-test.widget_test.dart';

class MockCoreCubit extends MockCubit<CoreState> implements CoreCubit {}

final _initNavState = CoreState();
final _navCubit = MockCoreCubit();
final _settingsCubit = MockSettingsCubit();
final _initMeasurementsState = MeasurementsState.init();
final _measurementsBloc = MockMeasurementsBloc();
final _initHistoryState = HistoryState(speedHistory: []);
final _initialSettingsState = SettingsState();
final _uuid = 'uuid';
final String _selectedLocaleTag = 'sr-Latn-rs';

@GenerateMocks([], customMocks: [
  MockSpec<SharedPreferencesWrapper>(
    as: #MockSharedPreferencesWrapperCalls,
    onMissingStub: OnMissingStub.returnDefault,
  )
])
void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    SharedPreferencesWrapper _prefsEnabled =
        MockSharedPreferencesWrapperCalls();
    TestingServiceLocator.swapLazySingleton<SharedPreferencesWrapper>(
        () => _prefsEnabled);
    when(_prefsEnabled.getBool(StorageKeys.netNeutralityTestsEnabled))
        .thenReturn(true);
    whenListen(
      _navCubit,
      Stream.fromIterable([_initNavState, CoreState(currentScreen: 2)]),
      initialState: _initNavState,
    );
    TestingServiceLocator.swapLazySingleton<CoreCubit>(() => _navCubit);
    TestingServiceLocator.swapLazySingleton<SettingsCubit>(
        () => _settingsCubit);
    whenListen(
      _measurementsBloc,
      Stream.fromIterable([_initMeasurementsState]),
      initialState: _initMeasurementsState,
    );
    whenListen(
        _settingsCubit,
        Stream.fromIterable([
          _initialSettingsState,
          _initialSettingsState.copyWith(clientUuid: _uuid)
        ]),
        initialState: _initialSettingsState);
    TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(
        () => _measurementsBloc);
    whenListen(
      GetIt.I.get<HistoryCubit>(),
      Stream.fromIterable([_initHistoryState]),
      initialState: _initHistoryState,
    );
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
  });

  testWidgets('shows bottom bar and current selected screen',
      (widgetTester) async {
    await widgetTester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider<CoreCubit>(create: (context) => _navCubit),
        BlocProvider<MeasurementsBloc>(create: (context) => _measurementsBloc),
        BlocProvider<HistoryCubit>(create: (context) => HistoryCubit())
      ],
      child: MaterialApp(home: HomeScreen()),
    ));
    await widgetTester.pumpAndSettle();
    expect(find.byType(BottomNavigation), findsOneWidget);
    expect(find.byType(HistoryScreen), findsOneWidget);
  });
}
