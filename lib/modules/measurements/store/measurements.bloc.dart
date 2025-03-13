import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/api-errors.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/extensions/loopModeDetails.ext.dart';
import 'package:nt_flutter_standalone/core/models/bloc-event.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/wakelock.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/measurement-result/measurement-result.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-error.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/radio-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/loop.mode.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurement.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurements.api.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/network.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/permissions.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/signal.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/handlers/connectivity-changes-handler.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/handlers/error-handler.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/handlers/loop-measurement-changes-handler.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/app.review.service.dart';
import 'package:nt_flutter_standalone/modules/settings/services/settings.service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
  final SharedPreferencesWrapper preferences =
      GetIt.I.get<SharedPreferencesWrapper>();
  final WakelockWrapper _wakelock = GetIt.I.get<WakelockWrapper>();
  ErrorHandler? errorHandler;
  ConnectivityChangesHandler? connectivityChangesHandler;
  LoopModeChangesHandler? loopModeChangesHandler;
  Timer? _locationHomeScreenTimer;
  RadioInfo? _radioInfo;
  StreamSubscription? _connectivitySubscription;
  bool testing;

  MeasurementsBloc({
    ErrorHandler? errorHandler,
    ConnectivityChangesHandler? connectivityChangesHandler,
    this.testing = false,
  }) : super(MeasurementsState.init()) {
    this.errorHandler = errorHandler ?? MeasurementBlocErrorHandler();
    this.connectivityChangesHandler = connectivityChangesHandler ??
        MeasurementBlocConnectivityChangesHandler();
    this.loopModeChangesHandler = loopModeChangesHandler ??
        MeasurementBlocLoopMeasurementChangesHandler();

// ANCHOR Initialize

    on<Initialize>((event, emit) async {
      emit(state.copyWith(
        loopModeDetails: loopModeService.loopModeDetails,
        permissions: permissionsService.permissionsMap,
        networkInfoDetails: networkService.networkInfoDetails,
        servers: measurementsApiService.servers,
        currentServer: measurementsApiService.servers.length > 0
            ? measurementsApiService.servers.first
            : null,
      ));
      _watchNetwork();
      _updateLocation();
    });

// ANCHOR GetNetworkInfo

    on<GetNetworkInfo>((event, emit) async {
      emit(state.copyWith(connectivity: event.payload));
      if (event.payload == ConnectivityResult.none) {
        return;
      }
      emit(state.copyWith(
        networkInfoDetails: await networkService.getNetworkInfo(
          permissions: state.permissions,
        ),
      ));
    });

// ANCHOR SetLocationInfo

    on<SetLocationInfo>((event, emit) async {
      if (loopModeService.isLoopModeActivated) {
        loopModeService.updateLocation(event.payload);
      }
      final servers =
          await measurementsApiService.getMeasurementServersForCurrentFlavor(
        location: event.payload ?? state.currentLocation,
        errorHandler: this.errorHandler,
        project: state.project,
      );
      MeasurementServer? currentServer = state.currentServer;
      if (currentServer == null) {
        currentServer = servers.length > 0 ? servers.first : null;
      }
      final networkInfoDetails = await networkService.getNetworkInfo(
        permissions: state.permissions,
      );
      emit(state.copyWith(
        currentLocation: event.payload,
        servers: servers,
        currentServer: currentServer,
        networkInfoDetails: networkInfoDetails,
      ));
    });

// ANCHOR RemoveObsoleteInfo

    on<RemoveObsoleteInfo>((event, emit) async {
      emit(MeasurementsState.removeObsoleteInformation(state));
    });

// ANCHOR StartMeasurement

    on<StartMeasurement>((event, emit) async {
      // this happens before setMeasurementScreenOpen event - called only first time when we open the screen
      _wakelock.enable();
      await loopModeService.initializeNewLoopMode(state.currentLocation);
      emit(MeasurementsState.started(state).copyWith(triedServersIds: {}));
      await startMeasurement(
        retryCount: max(0, state.project?.measurementRetries ?? 0),
        currentServer: state.currentServer!,
        emit: emit,
      );
    });

// ANCHOR StartMeasurementPhase

    on<StartMeasurementPhase>((event, emit) {
      emit(MeasurementsState.startingPhase(state, event.payload));
    });

// ANCHOR SetPhaseResult

    on<SetPhaseResult>((event, emit) {
      emit(MeasurementsState.withProgressForPhase(state, event.payload));
    });

// ANCHOR SetPhaseFinalResult

    on<SetPhaseFinalResult>((event, emit) {
      // this is called many times, not only once with final results
      emit(MeasurementsState.withResultsForPhase(state, event.payload));
    });

// ANCHOR StopMeasurement

    on<StopMeasurement>((event, emit) async {
      if (loopModeService.isLoopModeActivated) {
        loopModeService.onTestFinished(null);
      }
      emit(await stopMeasurement());
    });

// ANCHOR SetPermissions

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
        preferences.setBool(
          StorageKeys.notificationPermissionGranted,
          event.payload.notificationPermissionGranted,
        );
      }
      emit(state.copyWith(permissions: event.payload));
      if (event.payload.locationPermissionsGranted &&
          event.payload.phoneStatePermissionsGranted) {
        add(Initialize());
      }
    });

// ANCHOR SetMeasurmentScreenOpen

    on<SetMeasurmentScreenOpen>((event, emit) {
      if (loopModeService.isLoopModeActivated) {
        loopModeService.listenToLoopModeChanges(loopModeChangesHandler);
      }
      emit(state.copyWith(isMeasurementScreenOpen: event.payload));
    });

// ANCHOR CompleteAndroidMeasurement

    on<CompleteAndroidMeasurement>((event, emit) async {
      final result = event.payload;
      await result.fillRemainingMetadata(
        state,
        radioInfo: _radioInfo,
        testing: testing,
      );
      result.loopModeInfo = loopModeService.loopModeDetails
          .toLoopModeSettings(loopModeService.isLoopModeActivated);
      emit(MeasurementsState.startingPhase(
          state, MeasurementPhase.submittingTestResult));
      final response = await measurementsApiService
          .sendMeasurementResults(result, errorHandler: this.errorHandler);
      if (response == null) {
        return;
      }
      _onMeasurementComplete(event.payload.testToken.split("_")[0]);
      if (loopModeService.isLoopModeActivated) {
        loopModeService.onTestFinished(event.payload);
      } else {
        _appReviewService.startAppReview();
      }
    });

// ANCHOR CompleteIOSMeasurement

    on<CompleteIOSMeasurement>((event, emit) async {
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

// ANCHOR SetError

    on<SetError>((event, emit) async {
      if (event.payload is MeasurementError) {
        Sentry.captureException(event.payload);

        if (state.retryCount > 0 && state.currentServer != null) {
          final nextServer = state.nextServer;
          if (nextServer != null) {
            emit(state.copyWith(message: "Switching measurement server"));
            await startMeasurement(
              retryCount: state.retryCount - 1,
              currentServer: nextServer,
              emit: emit,
              switchingServer: true,
            );
            return;
          }
        }
      }

      if (loopModeService.isLoopModeActivated) {
        loopModeService.onTestFinished(null);
        return;
      }

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
    });

// ANCHOR SetCurrentServer

    on<SetCurrentServer>((event, emit) {
      emit(state.copyWith(currentServer: event.payload));
    });

// ANCHOR RestartMeasurement

    on<RestartMeasurement>((event, emit) async {
      emit(await stopMeasurement());
      emit(MeasurementsState.started(state));
      await startMeasurement(
        retryCount: max(0, state.project?.measurementRetries ?? 0),
        currentServer: state.currentServer!,
        emit: emit,
      );
    });

// ANCHOR MeasurementPostFinish

    on<MeasurementPostFinish>((event, emit) async {
      var isLoopModeRunning =
          loopModeService.loopModeDetails.isLoopModeActive &&
              !loopModeService.loopModeDetails.isLoopModeFinished;
      var isLoopTestRunning = loopModeService.loopModeDetails.isTestRunning;
      if (!isLoopModeRunning || isLoopTestRunning) {
        emit(MeasurementsState.finished(state));
      }
    });

// ANCHOR LoopModeDetailsChanged

    on<LoopModeDetailsChanged>((event, emit) async {
      emit(state.copyWith(loopModeDetails: event.payload));
      LoopModeDetails loopModeDetails = event.payload;
      if (loopModeDetails.shouldAnotherTestBeStarted &&
          !loopModeDetails.isTestRunning) {
        emit(MeasurementsState.started(state));
        await startMeasurement(
          retryCount: max(0, state.project?.measurementRetries ?? 0),
          currentServer: state.currentServer!,
          emit: emit,
        );
      } else if (loopModeDetails.isLoopModeFinished) {
        emit(MeasurementsState.finished(state));
        GetIt.I.get<CoreCubit>().goToScreen<HistoryScreen>();
        _wakelock.disable();
      }
    });

// ANCHOR CheckIfLoopModeShouldStart

    on<CheckIfLoopModeShouldStart>((event, emit) {
      if (loopModeService.loopModeDetails.shouldLoopModeBeStarted) {
        add(StartMeasurement());
      }
    });

// ANCHOR HomeScreenLeft

    on<HomeScreenLeft>((event, emit) {
      _locationHomeScreenTimer?.cancel();
    });

// ANCHOR MeasurementLoopUuidObtained

    on<MeasurementLoopUuidObtained>((event, emit) async {
      emit(state.copyWith(
          loopModeDetails: loopModeService.loopModeDetails
              .copyWith(loopUuid: event.payload)));
      await loopModeService.setLoopUuid(event.payload);
    });

// ANCHOR LocationServiceStateChanged

    on<LocationServiceStateChanged>((event, emit) {
      if (state.locationServicesEnabled != event.payload) {
        emit(state.copyWith(locationServicesEnabled: event.payload));
      }
    });

// ANCHOR CloseDialogVisibilityChanged

    on<CloseDialogVisibilityChanged>((event, emit) {
      emit(state.copyWith(leavingScreenShown: event.payload));
    });
  }

// ANCHOR _watchNetwork

  Future<void> _watchNetwork() async {
    try {
      _connectivitySubscription?.cancel();
      _connectivitySubscription = networkService.subscribeToNetworkChanges(
        changesHandler: connectivityChangesHandler,
      );
    } catch (e) {
      print(e);
    }
  }

// ANCHOR _updateLocation

  Future<void> _updateLocation() async {
    final isLocationServiceEnabled =
        await locationService.isLocationServiceEnabled;
    add(LocationServiceStateChanged(isLocationServiceEnabled));
    if (!isLocationServiceEnabled) {
      add(RemoveObsoleteInfo());
    } else {
      locationService.updateLocation(
        state: state,
        setState: (location) {
          add(SetLocationInfo(location));
        },
      );
    }
    if (_locationHomeScreenTimer?.isActive != true) {
      _locationHomeScreenTimer =
          Timer.periodic(const Duration(seconds: 5), (timer) {
        _updateLocation();
      });
    }
  }

// ANCHOR startMeasurement

  Future<void> startMeasurement({
    required int retryCount,
    required MeasurementServer currentServer,
    required Emitter<MeasurementsState> emit,
    switchingServer = false,
  }) async {
    final uuid = await preferences.clientUuid ??
        await settingsService.saveClientUuidAndSettings(
          errorHandler: this.errorHandler,
        );
    final newState = state.copyWith(
      retryCount: retryCount,
      currentServer: currentServer,
      triedServersIds: {...state.triedServersIds, currentServer.id},
      clientUuid: uuid,
      prevPhase: MeasurementPhase.none,
      phase: MeasurementPhase.initLatency,
    );
    emit(newState);
    if (loopModeService.isLoopModeActivated && !switchingServer) {
      loopModeService.onTestStarted();
    }
    try {
      await measurementService.startPingTest(
        host: currentServer.webAddress,
        project: state.project,
      );
    } on MeasurementError catch (e) {
      add(SetError(e));
      return;
    }
    measurementService.startTest(
      Environment.appSuffix.substring(1),
      clientUUID: uuid,
      location: state.currentLocation,
      measurementServer: currentServer,
      loopModeSettings: loopModeService.loopModeDetails
          .toLoopModeSettings(loopModeService.isLoopModeActivated),
      project: state.project,
    );
    if (platform.isAndroid && !switchingServer) {
      await signalService.startRecordingSignalInfo(
        state: state,
        setState: (radioInfo) {
          _radioInfo = radioInfo;
          print("_radioInfo: $_radioInfo");
        },
      );
    }
  }

// ANCHOR stopMeasurement

  Future<MeasurementsState> stopMeasurement() async {
    await measurementService.stopTest();
    if (loopModeService.isLoopModeActivated) {
      loopModeService.stopLoopTest(true);
    }
    return MeasurementsState.finished(state);
  }

// ANCHOR _onMeasurementComplete

  void _onMeasurementComplete(String testUuid) {
    signalService.stopRecordingSignalInfo();
    // todo add displaying result according loop uuid or redo
    if (!loopModeService.isLoopModeActivated) {
      _wakelock.disable();
      showMeasurementResult(testUuid);
    }
  }

// ANCHOR showMeasurementResult

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

// ANCHOR setCloseDialogVisible

  setCloseDialogVisible(bool visible) {
    GetIt.I.get<MeasurementsBloc>().add(CloseDialogVisibilityChanged(visible));
  }

// ANCHOR close

  @override
  Future<void> close() async {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    return super.close();
  }
}
