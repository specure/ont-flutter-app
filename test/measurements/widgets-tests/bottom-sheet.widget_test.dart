import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/store/core.state.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/bottom-sheet/bottom-sheet.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets***REMOVED***-info.widget.dart';

import '../../core/widget/bottom-navigation-widget_test.dart';
import '../../di/service-locator.dart';
import 'start-test.widget_test.dart';

final MeasurementsBloc _measurementsBloc = MockMeasurementsBloc();
final CoreCubit _coreCubit = MockCoreCubit();
final Widget _screen = MultiBlocProvider(
  providers: [
    BlocProvider.value(
      value: _measurementsBloc,
    ),
    BlocProvider.value(value: _coreCubit),
  ],
  child: MediaQuery(
    data: MediaQueryData(),
    child: MaterialApp(
      home: BlocBuilder<MeasurementsBloc, MeasurementsState>(
        builder: (context, state) => Scaffold(
          body: HomeBottomSheet(context, state),
        ),
      ),
    ),
  ),
);

void main() {
  setUpAll(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    TestingServiceLocator.swapLazySingleton<CoreCubit>(() => _coreCubit);
    when(GetIt.I.get<PlatformWrapper>().isAndroid).thenReturn(false);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn('en-US');
    final ms = MeasurementsState.init().copyWith(
      connectivity: ConnectivityResult.wifi,
      networkInfoDetails: NetworkInfoDetails(type: wifi),
      currentLocation: LocationModel(
        latitude: 0,
        longitude: 0,
      ),
      currentServer: MeasurementServer(
        id: 0,
        uuid: '0',
        name: 'Server',
        city: 'City',
      ),
    );
    whenListen(_measurementsBloc, Stream.fromIterable([ms]), initialState: ms);
  });

  group('Measurements home', () {
    setUpAll(() {
      final cs =
          CoreState(connectivity: ConnectivityResult.wifi, currentScreen: 0);
      whenListen(_coreCubit, Stream.fromIterable([cs]), initialState: cs);
    });

    testWidgets('Landscape', (tester) async {
      await tester.pumpWidget(_screen);
      expect(find.byType(HomeBottomSheet), findsOneWidget);
      expect(find.byType(IPInfo), findsNWidgets(2));
      expect(find.text('NETWORK TYPE'), findsOneWidget);
      expect(find.byIcon(Icons.signal_wifi_4_bar), findsOneWidget);
      expect(find.text('WLAN'), findsOneWidget);
      expect(find.text('SERVICE PROVIDER'), findsOneWidget);
      expect(find.text('LOCATION'), findsOneWidget);
      expect(find.text('MEASUREMENT SERVER'), findsOneWidget);
      expect(find.text('Server (City)'), findsOneWidget);
    });

    testWidgets('Portrait', (tester) async {
      tester.binding.window.physicalSizeTestValue = Size(1200, 1600);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      await tester.pumpWidget(_screen);
      expect(find.byType(HomeBottomSheet), findsOneWidget);
      expect(find.byType(IPInfo), findsNWidgets(2));
      expect(find.text('NETWORK TYPE'), findsOneWidget);
      expect(find.byIcon(Icons.signal_wifi_4_bar), findsOneWidget);
      expect(find.text('WLAN'), findsOneWidget);
      expect(find.text('SERVICE PROVIDER'), findsOneWidget);
      expect(find.text('LOCATION'), findsOneWidget);
      expect(find.text('MEASUREMENT SERVER'), findsNothing);
      expect(find.text('Server (City)'), findsNothing);
    });
  });

  group('Net neutrality home', () {
    setUpAll(() {
      final cs =
          CoreState(connectivity: ConnectivityResult.wifi, currentScreen: 1);
      whenListen(_coreCubit, Stream.fromIterable([cs]), initialState: cs);
    });

    testWidgets('Landscape', (tester) async {
      await tester.pumpWidget(_screen);
      expect(find.byType(HomeBottomSheet), findsOneWidget);
      expect(find.byType(IPInfo), findsNWidgets(2));
      expect(find.text('NETWORK TYPE'), findsOneWidget);
      expect(find.byIcon(Icons.signal_wifi_4_bar), findsOneWidget);
      expect(find.text('WLAN'), findsOneWidget);
      expect(find.text('SERVICE PROVIDER'), findsOneWidget);
      expect(find.text('LOCATION'), findsOneWidget);
      expect(find.text('MEASUREMENT SERVER'), findsNothing);
      expect(find.text('Server (City)'), findsNothing);
    });
  });
}
