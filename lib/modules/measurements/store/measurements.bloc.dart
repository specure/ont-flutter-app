import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/api-errors.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/extensions/loopModeDetails.ext.dart';
import 'package:nt_flutter_standalone/core/models/bloc-event.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/services/localization.service.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/wakelock.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/measurement-result/measurement-result.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-error.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/permissions-map.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/radio-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/signal-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/loop.mode.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurement.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurements.api.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/network.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/permissions.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/signal.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/app.review.service.dart';
import 'package:nt_flutter_standalone/modules/settings/services/settings.service.dart';

import '../../history/screens/history.screen.dart';
import '../models/loop-mode-details.dart';
import '../models/measurement-server.dart';

class MeasurementsBloc extends Bloc<BlocEvent, MeasurementsState> {
  static final noConnectionError =
      MeasurementError(ApiErrors.noInternetConnection);

  final MeasurementService measurementService =
      GetIt.I.get<MeasurementService>();
  final LoopModeService loopModeService = GetIt.I.get<LoopModeService>();
  final PermissionsService permissionsService =
      GetIt.I.get<PermissionsService>();
  final MeasurementsApiService measurementsApiService =
      GetIt.I.get<MeasurementsApiService>();
  final AppReviewService _appReviewService = GetIt.I.get<AppReviewService>();
  final SettingsService settingsService = GetIt.I.get<SettingsService>();
  final LocationService locationService = GetIt.I.get<LocationService>();
  final NetworkService networkService = GetIt.I.get<NetworkService>();
  final SignalService signalService = GetIt.I.get<SignalService>();
  final NavigationService navigationService = GetIt.I.get<NavigationService>();
  final PlatformWrapper platform = GetIt.I.get<PlatformWrapper>();
  final DeviceInfoPlugin deviceInfoPlugin = GetIt.I.get<DeviceInfoPlugin>();
  final SharedPreferencesWrapper preferences =
      GetIt.I.get<SharedPreferencesWrapper>();
  final CMSService _cmsService = GetIt.I.get<CMSService>();
  final WakelockWrapper _wakelock = GetIt.I.get<WakelockWrapper>();
  ErrorHandler? errorHandler;
  ConnectivityChangesHandler? connectivityChangesHandler;
  LoopModeChangesHandler? loopModeChangesHandler;

  LocationModel? _lastLocation;

  int? _measurementStartTimestamp;
  Timer? _signalsMeasurementTimer;
  Timer? _signalsHomeScreenTimer;
  RadioInfo? _radioInfo;

  StreamSubscription? _connectivitySubscription;

  MeasurementsBloc({
    ErrorHandler? errorHandler,
    ConnectivityChangesHandler? connectivityChangesHandler,
  }) : super(MeasurementsState.init()) {
    this.errorHandler = errorHandler ?? MeasurementBlocErrorHandler();
    this.connectivityChangesHandler = connectivityChangesHandler ??
        MeasurementBlocConnectivityChangesHandler();
    this.loopModeChangesHandler = loopModeChangesHandler ??
        MeasurementBlocLoopMeasurementChangesHandler();
    on<Initialize>((event, emit) async {
      emit(state.copyWith(
        isInitializing: true,
        permissions: await checkPermissions(),
        locationServicesEnabled: await locationService.isLocationServiceEnabled,
        loopModeDetails: loopModeService.loopModeDetails,
      ));
      final List<dynamic> remoteSettings = await Future.wait([
        _cmsService.getProject(),
        settingsService.saveClientUuidAndSettings(
            errorHandler: this.errorHandler),
      ]);
      emit(state.copyWith(
        project: remoteSettings[0],
        clientUuid: remoteSettings[1],
      ));
      final List<dynamic> localSettings =
          await Future.wait([getNetworkInfo(), _setUpSubscriptions()]);
      emit(state.copyWith(
        networkInfoDetails: localSettings[0],
        isInitializing: false,
      ));
    });
    on<SignalUpdate>((event, emit) async {
      emit(state.copyWith(networkInfoDetails: event.payload));
    });
    on<GetNetworkInfo>((event, emit) async {
      emit(state.copyWith(connectivity: event.payload));
      if (event.payload == ConnectivityResult.none) {
        return;
      }
      final List<dynamic> info = await Future.wait([
        getNetworkInfo(),
        measurementsApiService.getMeasurementServersForCurrentFlavor(
          location: state.currentLocation,
          errorHandler: this.errorHandler,
        )
      ]);
      final List<MeasurementServer> servers = info[1];
      MeasurementServer? currentServer = state.currentServer;
      if (currentServer == null) {
        currentServer = servers.length > 0 ? servers.first : null;
      }
      emit(state.copyWith(
        networkInfoDetails: info[0],
        servers: servers,
        currentServer: currentServer,
      ));
    });
    on<SetLocationInfo>((event, emit) async {
      final servers =
          await measurementsApiService.getMeasurementServersForCurrentFlavor(
        location: event.payload ?? state.currentLocation,
        errorHandler: this.errorHandler,
      );
      if (loopModeService.isLoopModeActivated) {
        loopModeService.updateLocation(event.payload);
      }
      MeasurementServer? currentServer = state.currentServer;
      if (currentServer == null) {
        currentServer = servers.length > 0 ? servers.first : null;
      }
      emit(state.copyWith(
        currentLocation: event.payload,
        servers: servers,
        currentServer: currentServer,
      ));
    });
    on<RemoveObsoleteInfo>((event, emit) async {
      emit(MeasurementsState.removeObsoleteInformation(state));
    });
    on<StartMeasurement>((event, emit) async {
      // this happens before setMeasurementScreenOpen event - called only first time when we open the screen
      _wakelock.enable();
      await loopModeService.initializeNewLoopMode(state.currentLocation);
      emit(MeasurementsState.started(state));
      emit(await startMeasurement());
    });
    on<StartMeasurementPhase>((event, emit) {
      emit(MeasurementsState.startingPhase(state, event.payload));
    });
    on<SetPhaseResult>((event, emit) {
      emit(MeasurementsState.withProgressForPhase(state, event.payload));
    });
    on<SetPhaseFinalResult>((event, emit) {
      // this is called many times, not only once with final results
      emit(MeasurementsState.withResultsForPhase(state, event.payload));
    });
    on<StopMeasurement>((event, emit) async {
      if (loopModeService.isLoopModeActivated) {
        loopModeService.onTestFinished(null);
      }
      emit(await stopMeasurement());
    });
    on<SetPermissions>((event, emit) {
      preferences.setBool(
        StorageKeys.locationPermissionsGranted,
        event.payload.locationPermissionsGranted,
      );
      preferences.setBool(
        StorageKeys.phoneStatePermissionsGranted,
        event.payload.phoneStatePermissionsGranted,
      );
      if (platform.isAndroid) {
        preferences.setBool(
          StorageKeys.preciseLocationPermissionsGranted,
          event.payload.preciseLocationPermissionsGranted,
        );
      }
      emit(state.copyWith(permissions: event.payload));
      if (event.payload.locationPermissionsGranted &&
          event.payload.phoneStatePermissionsGranted) {
        add(Initialize());
      }
    });
    on<SetMeasurmentScreenOpen>((event, emit) {
      if (loopModeService.isLoopModeActivated) {
        loopModeService.listenToLoopModeChanges(loopModeChangesHandler);
      }
      emit(state.copyWith(isMeasurementScreenOpen: event.payload));
    });
    on<CompleteMeasurement>((event, emit) async {
      // called only on Android
      emit(MeasurementsState.startingPhase(
          state, MeasurementPhase.submittingTestResult));
      await _completeMeasurement(event.payload);
      if (loopModeService.isLoopModeActivated) {
        loopModeService.onTestFinished(event.payload);
      } else {
        _appReviewService.startAppReview();
      }
    });
    on<ShowMeasurementResult>((event, emit) async {
      // called only on iOS
      if (!loopModeService.isLoopModeActivated)
        showMeasurementResult(event.payload);
      _wakelock.disable();
    });
    on<OnMeasurementComplete>((event, emit) async {
      // called only on iOS
      if (loopModeService.loopModeDetails.isLoopModeActive) {
        double jitterUnitsFixed =
            (state.phaseFinalResults[MeasurementPhase.jitter]?.toInt() ?? -1) /
                1000000;
        var localResults = MeasurementResult(
          uuid: "",
          testToken: "",
          clientName: "",
          bytesDownload: -1,
          bytesUpload: -1,
          nsecDownload: -1,
          nsecUpload: -1,
          totalDownloadBytes: -1,
          totalUploadBytes: -1,
          serverIpAddress: "",
          localIpAddress: "",
          testNumThreads: -1,
          testPortRemote: -1,
          jitter: jitterUnitsFixed,
          packetLoss: state.phaseFinalResults[MeasurementPhase.packLoss],
          pingShortest:
              state.phaseFinalResults[MeasurementPhase.latency]?.toInt() ?? -1,
          speedUpload: state.phaseFinalResults[MeasurementPhase.up] ?? -1,
          speedDownload: state.phaseFinalResults[MeasurementPhase.down] ?? -1,
          time: state.loopModeDetails.lastTestTimestampMillis ?? -1,
        );
        loopModeService.onTestFinished(localResults);
      }
      _onMeasurementComplete(event.payload);
      _appReviewService.startAppReview();
    });
    on<SetError>((event, emit) async {
      if (loopModeService.isLoopModeActivated) {
        loopModeService.onTestFinished(null);
      } else {
        if (event.payload is MeasurementError &&
            event.payload.toString() != ApiErrors.noInternetConnection) {
          // double-check if error is due to missing Internet connection
          final servers = await measurementsApiService
              .getMeasurementServersForCurrentFlavor();
          if (servers.isNotEmpty) {
            emit(state.copyWith(error: event.payload));
          } else {
            emit(state.copyWith(error: noConnectionError));
          }
        } else {
          emit(state.copyWith(error: event.payload));
        }
      }
    });
    on<SetCurrentServer>((event, emit) {
      emit(state.copyWith(currentServer: event.payload));
    });
    on<RestartMeasurement>((event, emit) async {
      emit(await stopMeasurement());
      emit(MeasurementsState.started(state));
      emit(await startMeasurement());
    });
    on<MeasurementPostFinish>((event, emit) async {
      var isLoopModeRunning =
          loopModeService.loopModeDetails.isLoopModeActive &&
              !loopModeService.loopModeDetails.isLoopModeFinished;
      var isLoopTestRunning = loopModeService.loopModeDetails.isTestRunning;
      if (!isLoopModeRunning || isLoopTestRunning) {
        emit(MeasurementsState.finished(state));
      }
    });
    on<LoopModeDetailsChanged>((event, emit) async {
      emit(state.copyWith(loopModeDetails: event.payload));
      LoopModeDetails loopModeDetails = event.payload;
      if (loopModeDetails.shouldAnotherTestBeStarted &&
          !loopModeDetails.isTestRunning) {
        emit(MeasurementsState.started(state));
        emit(await startMeasurement());
      } else if (loopModeDetails.isLoopModeFinished) {
        emit(MeasurementsState.finished(state));
        GetIt.I.get<CoreCubit>().goToScreen<HistoryScreen>();
        _wakelock.disable();
      }
    });
    on<CheckIfLoopModeShouldStart>((event, emit) {
      if (loopModeService.loopModeDetails.shouldLoopModeBeStarted) {
        add(StartMeasurement());
      }
    });
    on<HomeScreenLeft>((event, emit) {
      _signalsHomeScreenTimer?.cancel();
    });
    on<MeasurementLoopUuidObtained>((event, emit) async {
      emit(state.copyWith(
          loopModeDetails: loopModeService.loopModeDetails
              .copyWith(loopUuid: event.payload)));
      await loopModeService.setLoopUuid(event.payload);
    });
    on<LocationServiceStateChanged>((event, emit) {
      if (state.locationServicesEnabled != event.payload) {
        emit(state.copyWith(locationServicesEnabled: event.payload));
      }
    });
    on<CloseDialogVisibilityChanged>((event, emit) {
      emit(state.copyWith(leavingScreenShown: event.payload));
    });
  }

  Future<void> _setUpSubscriptions() async {
    await _setUpConnectivitySubscription();
    await _refreshInfo();
    if (_signalsHomeScreenTimer?.isActive != true) {
      _signalsHomeScreenTimer =
          Timer.periodic(const Duration(seconds: 5), (timer) async {
        await _refreshInfo();
      });
    }
  }

  Future<void> _refreshInfo() async {
    final isLocationServiceEnabled =
        await locationService.isLocationServiceEnabled;
    if (platform.isAndroid) {
      add(LocationServiceStateChanged(isLocationServiceEnabled));
    }
    await getNetworkInfo();
    if (!isLocationServiceEnabled) {
      add(RemoveObsoleteInfo());
    } else {
      await _updateLocation();
    }
  }

  Future<void> _setUpConnectivitySubscription() async {
    try {
      _connectivitySubscription?.cancel();
      _connectivitySubscription =
          await networkService.subscribeToNetworkChanges(
        changesHandler: connectivityChangesHandler,
      );
    } catch (e) {
      print(e);
    }
  }

  Future showMeasurementResult(String measurementUuid) async {
    var loopModeIsActive = loopModeService.loopModeDetails.isLoopModeActive;

    if (!state.isMeasurementScreenOpen ||
        state.phase != MeasurementPhase.submittingTestResult) {
      return;
    }

    if (!loopModeIsActive) {
      await navigationService
          .pushReplacementRoute(MeasurementResultScreen.route, {
        MeasurementResultScreen.argumentResult: null,
        MeasurementResultScreen.argumentTestUuid: measurementUuid,
      });
    }
    add(MeasurementPostFinish());
  }

  Future<NetworkInfoDetails?> getNetworkInfo() async {
    var locationServiceEnabled = await locationService.isLocationServiceEnabled;
    if (!state.permissions.locationPermissionsGranted ||
        !locationServiceEnabled) {
      var networkInfoDetails = await networkService.getBasicNetworkDetails();
      return networkInfoDetails;
    }
    var networkInfoDetails = await networkService.getAllNetworkDetails();
    add(SignalUpdate(networkDetails: networkInfoDetails));
    return networkInfoDetails;
  }

  Future<void> _updateLocation() async {
    if (!state.permissions.locationPermissionsGranted) {
      return;
    }
    final locationServiceEnabled =
        await locationService.isLocationServiceEnabled;
    if (!locationServiceEnabled) {
      return;
    }
    final currentLocation = await locationService.latestLocation;
    if (currentLocation == null || !_isLocationDifferent(currentLocation)) {
      return;
    }
    try {
      _lastLocation = await locationService.getAddressByLocation(
          currentLocation.latitude!, currentLocation.longitude!);
      add(SetLocationInfo(_lastLocation));
    } catch (_) {}
  }

  bool _isLocationDifferent(LocationModel newLocation) {
    if (_lastLocation == null) {
      return true;
    }
    final latDiff = (newLocation.latitude! - _lastLocation!.latitude!).abs();
    final lonDiff = (newLocation.longitude! - _lastLocation!.longitude!).abs();
    return latDiff > 0.005 || lonDiff > 0.005;
  }

  Future<MeasurementsState> startMeasurement() async {
    if (loopModeService.isLoopModeActivated) {
      loopModeService.onTestStarted();
    }
    final uuid = await preferences.clientUuid ??
        await settingsService.saveClientUuidAndSettings(
          errorHandler: this.errorHandler,
        );
    try {
      await measurementService.startPingTest(
        host: state.currentServer?.webAddress,
        project: state.project,
      );
    } on MeasurementError catch (e) {
      return state.copyWith(error: e);
    }
    measurementService.startTest(
      Environment.appSuffix.substring(1),
      clientUUID: uuid,
      location: _lastLocation,
      measurementServerId: state.currentServer?.id,
      loopModeSettings: loopModeService.loopModeDetails
          .toLoopModeSettings(loopModeService.isLoopModeActivated),
      enableAppJitterAndPacketLoss: state.project?.enableAppJitterAndPacketLoss,
    );
    if (platform.isAndroid) {
      await _startRecordingSignalInfo();
    }
    return state.copyWith(clientUuid: uuid);
  }

  Future _startRecordingSignalInfo() async {
    final isSignalPermissionGranted =
        await permissionsService.isSignalPermissionGranted;
    if (!state.permissions.locationPermissionsGranted ||
        !state.permissions.phoneStatePermissionsGranted ||
        !isSignalPermissionGranted) {
      return;
    }
    final primaryCell = await signalService.getPrimaryCellInfo();
    _radioInfo = RadioInfo(
      cells: primaryCell != null ? [primaryCell] : [],
      signals: [],
    );
    _measurementStartTimestamp = DateTime.now().millisecondsSinceEpoch;
    _signalsMeasurementTimer?.cancel();
    _signalsMeasurementTimer =
        Timer.periodic(Duration(seconds: 1), (timer) async {
      final signalInfo =
          await signalService.getCurrentSignalInfo(_measurementStartTimestamp!);
      if (signalInfo != null) {
        _radioInfo!.signals.addAll(signalInfo);
      }
    });
  }

  Future<MeasurementsState> stopMeasurement() async {
    await measurementService.stopTest();
    if (loopModeService.isLoopModeActivated) {
      loopModeService.stopLoopTest(true);
    }
    return MeasurementsState.finished(state);
  }

  Future<PermissionsMap> checkPermissions() async {
    permissionsService.initialize();
    return permissionsService.permissionsMap;
  }

  void _onMeasurementComplete(String testUuid) {
    _signalsMeasurementTimer?.cancel();
    // todo add displaying result according loop uuid or redo
    if (!loopModeService.isLoopModeActivated) {
      _wakelock.disable();
      showMeasurementResult(testUuid);
    }
  }

  Future _completeMeasurement(MeasurementResult result) async {
    // called on Android only
    await _fillRemainingMetadataForResult(result);
    result.loopModeInfo = loopModeService.loopModeDetails
        .toLoopModeSettings(loopModeService.isLoopModeActivated);
    await measurementsApiService.sendMeasurementResults(result,
        errorHandler: this.errorHandler);
    _onMeasurementComplete(result.testToken.split("_")[0]);
  }

  Future _fillRemainingMetadataForResult(MeasurementResult result) async {
    // called on Android only
    result.networkType = serverNetworkTypes[state.networkInfoDetails.type];
    result.dualSim = state.networkInfoDetails.isDualSim;
    result.clientLanguage =
        GetIt.I.get<LocalizationService>().currentLocale.languageCode;
    result.radioInfo = RadioInfo(
      cells: _radioInfo?.cells ?? [],
      signals: _setTimeNsLastForSignals(_radioInfo?.signals ?? []),
    );
    result.telephonyNetworkSimOperator =
        state.networkInfoDetails.telephonyNetworkSimOperator;
    result.telephonyNetworkSimOperatorName =
        state.networkInfoDetails.telephonyNetworkSimOperatorName;
    result.telephonyNetworkSimCountry =
        state.networkInfoDetails.telephonyNetworkSimCountry;
    result.telephonyNetworkOperator =
        state.networkInfoDetails.telephonyNetworkOperator;
    result.telephonyNetworkOperatorName =
        state.networkInfoDetails.telephonyNetworkOperatorName;
    result.telephonyNetworkCountry =
        state.networkInfoDetails.telephonyNetworkCountry;
    result.telephonyNetworkIsRoaming =
        state.networkInfoDetails.telephonyNetworkIsRoaming;
    if (platform.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      result.platform = 'Android';
      result.device = androidInfo.device;
      result.model = androidInfo.model;
      result.apiLevel = androidInfo.version.sdkInt.toString();
      result.osVersion =
          '${androidInfo.version.release} (${androidInfo.version.incremental})';
      result.product = androidInfo.brand;
    } else if (platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;
      result.platform = 'iOS';
      result.device = iosInfo.name;
      result.model = iosInfo.model;
      result.osVersion = iosInfo.systemVersion;
      result.product = iosInfo.name;
    }
  }

  List<SignalInfo> _setTimeNsLastForSignals(List<SignalInfo> signals) {
    return signals
        .map((signal) => signal.copyWithTimeNs(
              timeNsLast: _radioInfo!.signals.last.timeNs,
            ))
        .toList();
  }

  setCloseDialogVisible(bool visible) {
    GetIt.I.get<MeasurementsBloc>().add(CloseDialogVisibilityChanged(visible));
  }

  @override
  Future<void> close() async {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    return super.close();
  }
}

class MeasurementBlocErrorHandler implements ErrorHandler {
  @override
  process(Exception? error) {
    if (error != null) {
      GetIt.I.get<MeasurementsBloc>().add(SetError(error));
    }
  }
}

class MeasurementBlocConnectivityChangesHandler
    implements ConnectivityChangesHandler {
  @override
  process(ConnectivityResult connectivity) {
    GetIt.I
        .get<MeasurementsBloc>()
        .add(GetNetworkInfo(connectivity: connectivity));
  }
}

class MeasurementBlocLoopMeasurementChangesHandler
    implements LoopModeChangesHandler {
  @override
  onLoopModeDetailsChanged(LoopModeDetails loopModeDetails) {
    GetIt.I
        .get<MeasurementsBloc>()
        .add(LoopModeDetailsChanged(loopModeDetails));
  }
}
