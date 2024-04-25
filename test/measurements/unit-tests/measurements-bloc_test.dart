import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/api-errors.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/core/services/localization.service.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/wakelock.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/measurement-result/measurement-result.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/loop-mode-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-error.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/permissions-map.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/signal-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/loop.mode.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurement.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurements.api.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/network.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/permissions.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/signal.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/handlers/connectivity-changes-handler.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/handlers/error-handler.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/app.review.service.dart';
import 'package:nt_flutter_standalone/modules/settings/services/settings.service.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

final _loopModeDetails = LoopModeDetails(medians: HashMap());
final _permissionsMap = PermissionsMap(
  locationPermissionsGranted: true,
  readPhoneStatePermissionsGranted: true,
);
final _networkInfoDetails = NetworkInfoDetails(
  type: wifi,
  mobileNetworkGeneration: unknown,
  name: 'Network name',
);

final _basicWifiNetworkInfoDetails = NetworkInfoDetails(
  type: wifi,
  mobileNetworkGeneration: unknown,
  name: unknown,
);

final _basicMobileNetworkInfoDetails = NetworkInfoDetails(
  type: mobile,
  mobileNetworkGeneration: unknown,
  name: unknown,
);

final _networkInfoDetailsChanged = NetworkInfoDetails(
    type: wifi,
    mobileNetworkGeneration: unknown,
    name: 'Home network',
    currentAllSignalInfo: [
      SignalInfo(
        signal: -63,
        band: '2.4Ghz',
        technology: wifi,
        networkTypeId: serverNetworkTypes[wifi]!,
      )
    ]);
final _lat = 10.0;
final _lng = 20.0;
final _locationModel = LocationModel(
  latitude: _lat,
  longitude: _lng,
  city: 'Cupertino',
  country: 'USA',
);
final _measurementServers = [
  MeasurementServer(id: 1, uuid: 'uuid'),
  MeasurementServer(id: 2, uuid: 'uuid2')
];
final _measurementResult = MeasurementResult(
  bytesDownload: 10000,
  bytesUpload: 10000,
  clientName: 'RMBT',
  localIpAddress: '192.168.0.1',
  nsecDownload: 1000,
  nsecUpload: 1000,
  pingShortest: 100,
  serverIpAddress: '192.168.0.2',
  speedDownload: 2000,
  speedUpload: 2000,
  testNumThreads: 3,
  testPortRemote: 443,
  testToken: 'test_token',
  totalDownloadBytes: 100000,
  totalUploadBytes: 100000,
  uuid: 'uuid',
);
final _measurementResultScreenArguments = {
  MeasurementResultScreen.argumentResult: null,
  MeasurementResultScreen.argumentTestUuid: 'test',
};
final _errorHandler = MockErrorHandler();
final _dioError = MockDioError();
final _loopChangesHandler = MockMeasurementBlocLoopMeasurementChangesHandler();
final _noConnectionError = MeasurementError(ApiErrors.noInternetConnection);
final _unknownError = MeasurementError();
final _unknownErrorString = 'Unknown error';

@GenerateMocks([
  MeasurementService,
  PermissionsService,
  SettingsService,
  LocationService,
  NavigationService,
  DeviceInfoPlugin,
  LocalizationService,
  AppReviewService,
  LoopModeService,
  WakelockWrapper,
], customMocks: [
  MockSpec<NetworkService>(
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<CMSService>(
    onMissingStub: OnMissingStub.returnDefault,
  ),
])
void main() {
  setUpAll(() {
    TestingServiceLocator.registerInstances();
    _setUpStubs();
  });

  group('Test measurements bloc', () {
    blocTest<MeasurementsBloc, MeasurementsState>(
      'Initialize event',
      build: () => _setUpBloc(),
      act: (bloc) => bloc.add(Initialize()),
      expect: () => [
        _initStateWithPermissions.copyWith(
          isInitializing: true,
          locationServicesEnabled: true,
        ),
        _initStateWithPermissions.copyWith(
          isInitializing: true,
          clientUuid: "uuid",
          locationServicesEnabled: true,
        ),
        _initStateWithPermissions.copyWith(
          networkInfoDetails: _networkInfoDetails,
          clientUuid: "uuid",
          locationServicesEnabled: true,
        ),
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'Initialize event called twice',
      build: () => _setUpBloc(),
      act: (bloc) {
        bloc.add(Initialize());
        bloc.add(Initialize());
      },
      expect: () => [
        _initStateWithPermissions.copyWith(
          isInitializing: true,
          locationServicesEnabled: true,
        ),
        _initStateWithPermissions.copyWith(
          isInitializing: true,
          clientUuid: "uuid",
          locationServicesEnabled: true,
        ),
        _initStateWithPermissions.copyWith(
          isInitializing: true,
          locationServicesEnabled: true,
        ),
        _initStateWithPermissions.copyWith(
          isInitializing: true,
          clientUuid: "uuid",
          locationServicesEnabled: true,
        ),
        _initStateWithPermissions.copyWith(
          networkInfoDetails: _networkInfoDetails,
          clientUuid: "uuid",
          locationServicesEnabled: true,
        ),
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'GetNetworkInfo event',
      build: () => _setUpBloc(),
      act: (bloc) =>
          bloc.add(GetNetworkInfo(connectivity: ConnectivityResult.wifi)),
      expect: () => [
        _initStateWithPermissions.copyWith(
          connectivity: ConnectivityResult.wifi,
        ),
        _initStateWithPermissions.copyWith(
          networkInfoDetails: _networkInfoDetails,
          currentServer: _measurementServers.first,
          servers: _measurementServers,
          connectivity: ConnectivityResult.wifi,
        )
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'SignalUpdate event',
      build: () {
        MeasurementsBloc bloc = _setUpBloc();
        bloc.add(GetNetworkInfo(connectivity: ConnectivityResult.wifi));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(SignalUpdate(networkDetails: _networkInfoDetailsChanged)),
      skip: 1,
      expect: () => [
        _initStateWithPermissions.copyWith(
          networkInfoDetails: _networkInfoDetailsChanged,
          connectivity: ConnectivityResult.wifi,
        ),
        _initStateWithPermissions.copyWith(
          networkInfoDetails: _networkInfoDetails,
          currentServer: _measurementServers.first,
          servers: _measurementServers,
          connectivity: ConnectivityResult.wifi,
        ),
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'GetNetworkInfo event without connection',
      build: () => _setUpBloc(),
      act: (bloc) =>
          bloc.add(GetNetworkInfo(connectivity: ConnectivityResult.none)),
      expect: () => [],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'Signal update event without connection',
      build: () => _setUpBloc(),
      act: (bloc) => {
        bloc.add(GetNetworkInfo(connectivity: ConnectivityResult.none)),
        bloc.add(SignalUpdate(networkDetails: _networkInfoDetails))
      },
      skip: 1,
      expect: () => [],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'SetLocationInfo event',
      build: () => _setUpBloc(),
      act: (bloc) => bloc.add(SetLocationInfo(_locationModel)),
      expect: () => [
        _initStateWithPermissions.copyWith(
          currentLocation: _locationModel,
          currentServer: _measurementServers.first,
          servers: _measurementServers,
        )
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'RemoveObsoleteInfo event',
      build: () => _setUpBloc(),
      act: (bloc) {
        bloc.add(SetLocationInfo(_locationModel));
        bloc.add(RemoveObsoleteInfo());
      },
      expect: () => [
        _initStateWithPermissions.copyWith(
          currentLocation: _locationModel,
          currentServer: _measurementServers.first,
          servers: _measurementServers,
        ),
        _initStateWithPermissions.copyWith(
          currentLocation: null,
          currentServer: _measurementServers.first,
          servers: _measurementServers,
        )
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>('StartMeasurement event',
        build: () => _measurementsBloc,
        act: (bloc) {
          bloc.add(SetCurrentServer(_measurementServers[0]));
          bloc.add(StartMeasurement());
        },
        expect: () {
          final initState = MeasurementsState.init().copyWith(
            currentServer: _measurementServers[0],
          );
          return [
            initState,
            MeasurementsState.started(initState),
            MeasurementsState.started(
              initState.copyWith(
                triedServersIds: {
                  _measurementServers[0].id,
                },
                clientUuid: _measurementResult.uuid,
              ),
            ),
          ];
        });
    blocTest<MeasurementsBloc, MeasurementsState>(
      'RestartMeasurement event',
      build: () => _measurementsBloc,
      act: (bloc) {
        bloc.add(SetCurrentServer(_measurementServers[0]));
        bloc.add(RestartMeasurement());
      },
      expect: () {
        final initState = MeasurementsState.init().copyWith(
          currentServer: _measurementServers[0],
        );
        final finishedState = MeasurementsState.finished(initState);
        final startedState = MeasurementsState.started(initState);
        return [
          finishedState,
          startedState,
          startedState.copyWith(
            clientUuid: _measurementResult.uuid,
            triedServersIds: {
              _measurementServers[0].id,
            },
          ),
        ];
      },
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'StartMeasurementPhase event',
      build: () => _measurementsBloc,
      act: (bloc) => bloc.add(StartMeasurementPhase(MeasurementPhase.down)),
      expect: () => [
        MeasurementsState.startingPhase(
            MeasurementsState.init(), MeasurementPhase.down),
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'SetPhaseResult event',
      build: () => _measurementsBloc,
      act: (bloc) => bloc.add(SetPhaseResult(2.0)),
      expect: () => [
        MeasurementsState.withProgressForPhase(MeasurementsState.init(), 2.0),
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'SetPhaseFinalResult latency event',
      build: () => _measurementsBloc,
      act: (bloc) =>
          bloc.add(SetPhaseFinalResult(MeasurementPhase.latency, 2000000.0)),
      expect: () => [
        MeasurementsState.withResultsForPhase(MeasurementsState.init(),
            MapEntry(MeasurementPhase.latency, 2000000.0)),
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'SetPhaseFinalResult jitter event',
      build: () => _measurementsBloc,
      act: (bloc) =>
          bloc.add(SetPhaseFinalResult(MeasurementPhase.jitter, 2.0)),
      expect: () => [
        MeasurementsState.withResultsForPhase(
            MeasurementsState.init(), MapEntry(MeasurementPhase.jitter, 2.0)),
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'SetPhaseFinalResult packet loss event',
      build: () => _measurementsBloc,
      act: (bloc) =>
          bloc.add(SetPhaseFinalResult(MeasurementPhase.packLoss, 0.0)),
      expect: () => [
        MeasurementsState.withResultsForPhase(
            MeasurementsState.init(), MapEntry(MeasurementPhase.packLoss, 0.0)),
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'SetPhaseFinalResult download event',
      build: () => _measurementsBloc,
      act: (bloc) =>
          bloc.add(SetPhaseFinalResult(MeasurementPhase.down, 2000000.0)),
      expect: () => [
        MeasurementsState.withResultsForPhase(MeasurementsState.init(),
            MapEntry(MeasurementPhase.down, 2000000.0)),
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'SetPhaseFinalResult upload event',
      build: () => _measurementsBloc,
      act: (bloc) =>
          bloc.add(SetPhaseFinalResult(MeasurementPhase.up, 2000000.0)),
      expect: () => [
        MeasurementsState.withResultsForPhase(
            MeasurementsState.init(), MapEntry(MeasurementPhase.up, 2000000.0)),
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'StopMeasurement event',
      build: () => _setUpBloc(MeasurementPhase.submittingTestResult),
      act: (bloc) => bloc.add(StopMeasurement()),
      expect: () => [
        MeasurementsState.finished(_initStateWithPermissions),
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'SetPermissions event',
      build: () => _measurementsBloc,
      act: (bloc) => bloc.add(SetPermissions(_permissionsMap)),
      skip: 3,
      expect: () => [
        _initStateWithPermissions.copyWith(
          networkInfoDetails: _networkInfoDetails,
          clientUuid: "uuid",
          locationServicesEnabled: true,
        ),
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'SetMeasurmentScreenOpen event',
      build: () => _measurementsBloc,
      act: (bloc) => bloc.add(SetMeasurmentScreenOpen(true)),
      expect: () => [
        MeasurementsState.init().copyWith(isMeasurementScreenOpen: true),
      ],
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'CompleteMeasurement event',
      build: () => _measurementsBloc,
      act: (bloc) => bloc.add(CompleteAndroidMeasurement(_measurementResult)),
      expect: () => [
        MeasurementsState.startingPhase(
            MeasurementsState.init(), MeasurementPhase.submittingTestResult)
      ],
      verify: (bloc) {
        verifyNever(GetIt.I.get<NavigationService>().pushReplacementRoute(
              MeasurementResultScreen.route,
              _measurementResultScreenArguments,
            ));
      },
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'OnMeasurementComplete event',
      build: () => _measurementsBloc,
      act: (bloc) => bloc.add(CompleteIOSMeasurement('test')),
      verify: (bloc) {
        verifyNever(GetIt.I.get<NavigationService>().pushReplacementRoute(
              MeasurementResultScreen.route,
              _measurementResultScreenArguments,
            ));
      },
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'StartMeasurement event with error from settings request',
      build: () {
        when(GetIt.I
                .get<SettingsService>()
                .saveClientUuidAndSettings(errorHandler: _errorHandler))
            .thenAnswer((realInvocation) async => null);
        return _measurementsBloc;
      },
      act: (bloc) {
        bloc.add(SetCurrentServer(_measurementServers[0]));
        bloc.add(StartMeasurement());
      },
      expect: () {
        final initState = MeasurementsState.init().copyWith(
          currentServer: _measurementServers[0],
        );
        final startedState = MeasurementsState.started(initState);
        final startedStateWithUuid = startedState.copyWith(
          clientUuid: _measurementResult.uuid,
          triedServersIds: {_measurementServers[0].id},
        );
        return [initState, startedState, startedStateWithUuid];
      },
    );
    blocTest<MeasurementsBloc, MeasurementsState>(
      'SetCurrentServer event',
      build: () => _measurementsBloc,
      act: (bloc) => bloc.add(SetCurrentServer(_measurementServers[1])),
      expect: () => [
        MeasurementsState.init().copyWith(
          currentServer: _measurementServers[1],
        ),
      ],
    );

    blocTest(
      'Handling connectivity changes',
      build: () {
        TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(
            () => _measurementsBloc);
        return GetIt.I.get<MeasurementsBloc>();
      },
      act: (_) {
        final ConnectivityChangesHandler changesHandler =
            MeasurementBlocConnectivityChangesHandler();
        changesHandler.process(ConnectivityResult.wifi);
      },
      expect: () => [
        MeasurementsState.init().copyWith(
          connectivity: ConnectivityResult.wifi,
        ),
        MeasurementsState.init().copyWith(
          connectivity: ConnectivityResult.wifi,
          networkInfoDetails: _networkInfoDetails,
          currentServer: _measurementServers.first,
          servers: _measurementServers,
        ),
      ],
    );

    blocTest(
      'Handling errors',
      build: () {
        TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(
            () => _measurementsBloc);
        return GetIt.I.get<MeasurementsBloc>();
      },
      act: (_) {
        final ErrorHandler errorHandler = MeasurementBlocErrorHandler();
        errorHandler.process(_dioError);
      },
      expect: () => [MeasurementsState.init().copyWith(error: _dioError)],
    );

    blocTest<MeasurementsBloc, MeasurementsState>(
      'SetError event when there is no connectivity',
      build: () => _measurementsBloc,
      act: (bloc) => bloc.add(SetError(_noConnectionError)),
      expect: () => [
        MeasurementsState.init().copyWith(
          error: _noConnectionError,
          connectivity: ConnectivityResult.none,
        ),
      ],
    );

    blocTest<MeasurementsBloc, MeasurementsState>(
      'SetError event with double-checking for connectivity returning basic wifi',
      build: () {
        when(GetIt.I
                .get<MeasurementsApiService>()
                .getMeasurementServersForCurrentFlavor())
            .thenAnswer((_) async => []);
        return _measurementsBloc;
      },
      act: (bloc) {
        bloc.add(GetNetworkInfo(connectivity: ConnectivityResult.wifi));
        bloc.add(SetError(_unknownError));
      },
      expect: () => [
        MeasurementsState.init().copyWith(
          connectivity: ConnectivityResult.wifi,
        ),
        MeasurementsState.init().copyWith(
          connectivity: ConnectivityResult.wifi,
          networkInfoDetails: _networkInfoDetails,
          servers: _measurementServers,
          currentServer: _measurementServers.first,
        ),
        MeasurementsState.init().copyWith(
          connectivity: ConnectivityResult.wifi,
          networkInfoDetails: _networkInfoDetails,
          servers: _measurementServers,
          currentServer: _measurementServers.first,
          error: MeasurementsBloc.noConnectionError,
        ),
      ],
    );

    blocTest<MeasurementsBloc, MeasurementsState>(
      'connectivity returning basic mobile',
      build: () {
        when(GetIt.I.get<NetworkService>().getNetworkInfo(
              setState: argThat(isNotNull, named: 'setState'),
              state: argThat(isNotNull, named: 'state'),
            )).thenAnswer((_) async => _basicMobileNetworkInfoDetails);
        when(GetIt.I
                .get<MeasurementsApiService>()
                .getMeasurementServersForCurrentFlavor())
            .thenAnswer((_) async => []);
        return _measurementsBloc;
      },
      act: (bloc) {
        bloc.add(GetNetworkInfo(connectivity: ConnectivityResult.mobile));
      },
      expect: () => [
        MeasurementsState.init().copyWith(
          connectivity: ConnectivityResult.mobile,
        ),
        MeasurementsState.init().copyWith(
          connectivity: ConnectivityResult.mobile,
          networkInfoDetails: NetworkInfoDetails(type: mobile),
          servers: _measurementServers,
          currentServer: _measurementServers.first,
        )
      ],
    );

    blocTest<MeasurementsBloc, MeasurementsState>(
      'SetError event with double-checking for connectivity returning some connectivity',
      build: () {
        when(GetIt.I.get<NetworkService>().getNetworkInfo(
              setState: argThat(isNotNull, named: 'setState'),
              state: argThat(isNotNull, named: 'state'),
            )).thenAnswer((_) async => _basicWifiNetworkInfoDetails);
        when(GetIt.I
                .get<MeasurementsApiService>()
                .getMeasurementServersForCurrentFlavor())
            .thenAnswer((_) async => _measurementServers);
        return _measurementsBloc;
      },
      act: (bloc) {
        bloc.add(GetNetworkInfo(connectivity: ConnectivityResult.wifi));
        bloc.add(SetError(_unknownError));
      },
      expect: () => [
        MeasurementsState.init().copyWith(
          connectivity: ConnectivityResult.wifi,
        ),
        MeasurementsState.init().copyWith(
          connectivity: ConnectivityResult.wifi,
          networkInfoDetails: NetworkInfoDetails(type: wifi),
          servers: _measurementServers,
          currentServer: _measurementServers.first,
        ),
        MeasurementsState.init().copyWith(
          connectivity: ConnectivityResult.wifi,
          servers: _measurementServers,
          networkInfoDetails: NetworkInfoDetails(type: wifi),
          currentServer: _measurementServers.first,
          error: _unknownError,
        ),
      ],
    );

    test('result screen opens', () async {
      final bloc = _measurementsBloc;
      bloc.emit(bloc.state.copyWith(
        phase: MeasurementPhase.submittingTestResult,
        isMeasurementScreenOpen: true,
      ));
      bloc.showMeasurementResult(_measurementResultScreenArguments[
          MeasurementResultScreen.argumentTestUuid]!);
      verify(GetIt.I.get<NavigationService>().pushReplacementRoute(
            MeasurementResultScreen.route,
            _measurementResultScreenArguments,
          ));
    });
  });
}

MeasurementsBloc _setUpBloc([MeasurementPhase? phase]) {
  final bloc = _measurementsBloc;
  bloc.emit(bloc.state.copyWith(
    permissions: _permissionsMap,
    phase: phase,
  ));
  return bloc;
}

MeasurementsBloc get _measurementsBloc => MeasurementsBloc(
      errorHandler: _errorHandler,
      testing: true,
    );

MeasurementsState get _initStateWithPermissions =>
    MeasurementsState.init().copyWith(
      permissions: _permissionsMap,
    );

_setUpStubs() {
  when(GetIt.I.get<LoopModeService>().loopModeDetails)
      .thenAnswer((_) => _loopModeDetails);
  when(GetIt.I.get<LoopModeService>().updateLocation(_locationModel))
      .thenAnswer((_) {});
  when(GetIt.I.get<LoopModeService>().isLoopModeActivated)
      .thenAnswer((_) => false);
  when(GetIt.I.get<LoopModeService>().onTestStarted()).thenAnswer((_) {});
  when(GetIt.I.get<LoopModeService>().onTestFinished(_measurementResult))
      .thenAnswer((_) {});
  when(GetIt.I.get<LoopModeService>().onTestFinished(null)).thenAnswer((_) {});
  when(GetIt.I
          .get<LoopModeService>()
          .listenToLoopModeChanges(_loopChangesHandler))
      .thenAnswer((_) {});
  when(GetIt.I.get<LoopModeService>().initializeNewLoopMode(null))
      .thenAnswer((_) async {});
  when(GetIt.I.get<LoopModeService>().stopLoopTest(false)).thenAnswer((_) {});
  when(GetIt.I.get<LoopModeService>().stopLoopTest(true)).thenAnswer((_) {});

  when(GetIt.I.get<LocationService>().isLocationServiceEnabled)
      .thenAnswer((_) async => true);

  when(GetIt.I.get<NetworkService>().getNetworkInfo(
        setState: argThat(isNotNull, named: 'setState'),
        state: argThat(isNotNull, named: 'state'),
      )).thenAnswer((realInvocation) async {
    return _networkInfoDetails;
  });

  when(GetIt.I.get<NetworkService>().subscribeToNetworkChanges(
          changesHandler: anyNamed('changesHandler')))
      .thenAnswer((_) async => Stream.fromIterable([]).listen((event) {}));
  when(GetIt.I.get<NetworkService>().getAllNetworkDetails())
      .thenAnswer((_) async => _networkInfoDetails);
  when(GetIt.I.get<NetworkService>().getBasicNetworkDetails())
      .thenAnswer((_) async => _basicWifiNetworkInfoDetails);

  when(GetIt.I.get<PermissionsService>().initAndGet()).thenAnswer((_) async {
    return _permissionsMap;
  });
  when(GetIt.I.get<PermissionsService>().isSignalPermissionGranted)
      .thenAnswer((_) async => true);
  when(GetIt.I.get<PermissionsService>().permissionsMap)
      .thenAnswer((_) => _permissionsMap);

  when(GetIt.I
      .get<MeasurementsApiService>()
      .getMeasurementServersForCurrentFlavor(
        location: _locationModel,
        errorHandler: _errorHandler,
      )).thenAnswer((_) async => _measurementServers);
  when(GetIt.I
      .get<MeasurementsApiService>()
      .getMeasurementServersForCurrentFlavor(
        location: null,
        errorHandler: _errorHandler,
      )).thenAnswer((_) async => _measurementServers);
  when(GetIt.I.get<MeasurementsApiService>().sendMeasurementResults(
          _measurementResult,
          errorHandler: _errorHandler))
      .thenAnswer((_) async {
    return Response(requestOptions: RequestOptions());
  });

  when(GetIt.I.get<SettingsService>().saveClientUuidAndSettings(
        errorHandler: _errorHandler,
      )).thenAnswer((_) async => _measurementResult.uuid);

  when(GetIt.I.get<SharedPreferencesWrapper>().clientUuid)
      .thenAnswer((_) async => _measurementResult.uuid);
  when(GetIt.I
          .get<SharedPreferencesWrapper>()
          .setString(StorageKeys.clientUuid, _measurementResult.uuid))
      .thenAnswer((_) async {});
  when(GetIt.I
          .get<SharedPreferencesWrapper>()
          .getBool(StorageKeys.isWizardCompleted))
      .thenReturn(true);
  when(GetIt.I
          .get<SharedPreferencesWrapper>()
          .getBool(StorageKeys.locationPermissionsGranted))
      .thenReturn(true);
  when(GetIt.I
          .get<SharedPreferencesWrapper>()
          .setBool(StorageKeys.locationPermissionsGranted, true))
      .thenAnswer((_) async {});
  when(GetIt.I
          .get<SharedPreferencesWrapper>()
          .getBool(StorageKeys.phoneStatePermissionsGranted))
      .thenReturn(true);
  when(GetIt.I
          .get<SharedPreferencesWrapper>()
          .setBool(StorageKeys.phoneStatePermissionsGranted, true))
      .thenAnswer((_) async {});

  when(GetIt.I.get<MeasurementService>().startTest(
        Environment.appSuffix.substring(1),
        clientUUID: _measurementResult.uuid,
        location: null,
        measurementServer: null,
        loopModeSettings: null,
      )).thenAnswer((_) async => testStartedMessage);

  when(GetIt.I.get<MeasurementService>().startTest(
        Environment.appSuffix.substring(1),
        clientUUID: _measurementResult.uuid,
        location: null,
        measurementServer: _measurementServers[0],
        loopModeSettings: null,
      )).thenAnswer((_) async => testStartedMessage);

  when(GetIt.I.get<MeasurementService>().startTest(
        Environment.appSuffix.substring(1),
        clientUUID: null,
        location: null,
        measurementServer: null,
        loopModeSettings: null,
      )).thenAnswer((_) async => testStartedMessage);
  when(GetIt.I.get<MeasurementService>().stopTest())
      .thenAnswer((_) async => testStoppedMessage);

  when(GetIt.I.get<PlatformWrapper>().isAndroid).thenAnswer((_) => false);
  when(GetIt.I.get<PlatformWrapper>().isIOS).thenAnswer((_) => true);

  when(GetIt.I.get<LocalizationService>().currentLocale)
      .thenAnswer((_) => Locale('en'));

  when(GetIt.I.get<LocalizationService>().translate(_unknownErrorString))
      .thenAnswer((_) => _unknownErrorString);

  when(GetIt.I.get<NavigationService>().pushReplacementRoute(
          MeasurementResultScreen.route, _measurementResultScreenArguments))
      .thenAnswer((_) async {});

  when(GetIt.I.get<AppReviewService>().startAppReview())
      .thenAnswer((_) async => false);

  when(GetIt.I.get<WakelockWrapper>().enable()).thenAnswer((_) {});

  when(GetIt.I.get<WakelockWrapper>().disable()).thenAnswer((_) {});

  when(
    GetIt.I.get<SignalService>().startRecordingSignalInfo(
          setState: argThat(isNotNull, named: 'setState'),
          state: argThat(isNotNull, named: 'state'),
        ),
  ).thenAnswer((realInvocation) async {});
}
