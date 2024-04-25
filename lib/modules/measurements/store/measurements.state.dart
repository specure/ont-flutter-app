import 'dart:collection';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/mixins/error-state.mixin.dart';
import 'package:nt_flutter_standalone/core/models/basic-measurements.state.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/permissions-map.dart';
import 'package:nt_flutter_standalone/core/extensions/double.ext.dart';

import '../models/loop-mode-details.dart';

class MeasurementsState
    with EquatableMixin, ErrorState
    implements BasicMeasurementState {
  final NetworkInfoDetails networkInfoDetails;
  final LoopModeDetails loopModeDetails;
  final bool isInitializing;
  final bool isContinuing;
  final bool isMeasurementScreenOpen;
  final MeasurementPhase prevPhase;
  final MeasurementPhase phase;
  final Map<MeasurementPhase, List<double>> phaseProgressResults;
  final Map<MeasurementPhase, double?> phaseFinalResults;
  final PermissionsMap permissions;
  final bool locationServicesEnabled;
  final List<MeasurementServer>? servers;
  final MeasurementServer? currentServer;
  final LocationModel? currentLocation;
  final String? clientUuid;
  final ConnectivityResult connectivity;
  final NTProject? project;
  final bool leavingScreenShown;
  final int retryCount;
  late final Set<int> triedServersIds;
  final String? message;

  List<double> get currentPhaseResultsList => phaseProgressResults[phase] ?? [];
  double get lastResultForCurrentPhase => currentPhaseResultsList.lastWhere(
        (element) => element >= 0,
        orElse: () => 0,
      );
  String get currentServerName =>
      currentServer?.nameWithCity ?? 'Unknown'.translated;

  @override
  String get phaseName => phase.name.translated.toUpperCase();

  @override
  String get phaseUnits => phase.progressUnits;

  @override
  String get formattedPhaseResult {
    switch (phase) {
      case MeasurementPhase.down:
      case MeasurementPhase.up:
        return (lastResultForCurrentPhase * 1000).roundSpeed();
      default:
        return lastResultForCurrentPhase.toString();
    }
  }

  MeasurementsState({
    required this.networkInfoDetails,
    required this.isInitializing,
    required this.isContinuing,
    required this.loopModeDetails,
    required this.isMeasurementScreenOpen,
    required this.prevPhase,
    required this.phase,
    required this.phaseProgressResults,
    required this.phaseFinalResults,
    required this.permissions,
    this.project,
    this.servers,
    this.currentServer,
    this.currentLocation,
    this.clientUuid,
    this.connectivity = ConnectivityResult.none,
    this.locationServicesEnabled = false,
    this.leavingScreenShown = false,
    this.retryCount = 0,
    this.message = null,
    Set<int>? triedServersIds,
    Exception? error,
  }) {
    this.error = error;
    this.triedServersIds = triedServersIds ?? {};
  }

  MeasurementsState.init()
      : networkInfoDetails = NetworkInfoDetails(),
        loopModeDetails = LoopModeDetails(medians: HashMap()),
        prevPhase = MeasurementPhase.none,
        phase = MeasurementPhase.none,
        phaseProgressResults = {},
        phaseFinalResults = {},
        permissions = PermissionsMap(),
        isInitializing = false,
        isContinuing = false,
        isMeasurementScreenOpen = false,
        servers = null,
        triedServersIds = {},
        currentServer = null,
        currentLocation = null,
        clientUuid = null,
        connectivity = ConnectivityResult.none,
        locationServicesEnabled = false,
        leavingScreenShown = false,
        project = null,
        retryCount = 0,
        message = null;

  MeasurementsState.started(MeasurementsState currentState)
      : networkInfoDetails = currentState.networkInfoDetails,
        loopModeDetails = currentState.loopModeDetails,
        prevPhase = MeasurementPhase.none,
        permissions = currentState.permissions,
        phase = MeasurementPhase.initLatency,
        phaseProgressResults = {},
        phaseFinalResults = {},
        isInitializing = currentState.isInitializing,
        isContinuing = true,
        isMeasurementScreenOpen = currentState.isMeasurementScreenOpen,
        servers = currentState.servers,
        triedServersIds = currentState.triedServersIds,
        currentServer = currentState.currentServer,
        currentLocation = currentState.currentLocation,
        clientUuid = currentState.clientUuid,
        connectivity = currentState.connectivity,
        locationServicesEnabled = currentState.locationServicesEnabled,
        leavingScreenShown = false,
        project = currentState.project,
        retryCount = currentState.retryCount,
        message = null;

  MeasurementsState.startingPhase(
    MeasurementsState currentState,
    MeasurementPhase phase,
  )   : networkInfoDetails = currentState.networkInfoDetails,
        prevPhase = currentState.phase,
        permissions = currentState.permissions,
        this.phase = phase,
        phaseProgressResults = {
          ...currentState.phaseProgressResults,
          phase: []
        },
        phaseFinalResults = {...currentState.phaseFinalResults, phase: null},
        isInitializing = currentState.isInitializing,
        isContinuing = phase != MeasurementPhase.none,
        isMeasurementScreenOpen = currentState.isMeasurementScreenOpen,
        servers = currentState.servers,
        triedServersIds = currentState.triedServersIds,
        currentServer = currentState.currentServer,
        currentLocation = currentState.currentLocation,
        clientUuid = currentState.clientUuid,
        connectivity = currentState.connectivity,
        loopModeDetails = currentState.loopModeDetails,
        locationServicesEnabled = currentState.locationServicesEnabled,
        leavingScreenShown = currentState.leavingScreenShown,
        project = currentState.project,
        retryCount = currentState.retryCount,
        message = currentState.message;

  MeasurementsState.withResultsForPhase(
    MeasurementsState currentState,
    MapEntry<MeasurementPhase, double?> result,
  )   : networkInfoDetails = currentState.networkInfoDetails,
        prevPhase = currentState.prevPhase,
        phase = currentState.phase,
        phaseProgressResults = currentState.phaseProgressResults,
        phaseFinalResults = {
          ...currentState.phaseFinalResults,
          result.key: result.value,
        },
        permissions = currentState.permissions,
        isInitializing = currentState.isInitializing,
        isContinuing = true,
        isMeasurementScreenOpen = currentState.isMeasurementScreenOpen,
        servers = currentState.servers,
        triedServersIds = currentState.triedServersIds,
        currentServer = currentState.currentServer,
        currentLocation = currentState.currentLocation,
        clientUuid = currentState.clientUuid,
        connectivity = currentState.connectivity,
        loopModeDetails = currentState.loopModeDetails,
        locationServicesEnabled = currentState.locationServicesEnabled,
        leavingScreenShown = currentState.leavingScreenShown,
        project = currentState.project,
        retryCount = currentState.retryCount,
        message = currentState.message;

  MeasurementsState.withProgressForPhase(
    MeasurementsState currentState,
    double result,
  )   : networkInfoDetails = currentState.networkInfoDetails,
        prevPhase = currentState.prevPhase,
        phase = currentState.phase,
        phaseProgressResults = {
          ...currentState.phaseProgressResults,
          currentState.phase: [
            ...(currentState.phaseProgressResults[currentState.phase] ?? []),
            result
          ],
        },
        phaseFinalResults = currentState.phaseFinalResults,
        permissions = currentState.permissions,
        isInitializing = currentState.isInitializing,
        isContinuing = true,
        isMeasurementScreenOpen = currentState.isMeasurementScreenOpen,
        servers = currentState.servers,
        triedServersIds = currentState.triedServersIds,
        currentServer = currentState.currentServer,
        currentLocation = currentState.currentLocation,
        clientUuid = currentState.clientUuid,
        connectivity = currentState.connectivity,
        loopModeDetails = currentState.loopModeDetails,
        locationServicesEnabled = currentState.locationServicesEnabled,
        leavingScreenShown = currentState.leavingScreenShown,
        project = currentState.project,
        retryCount = currentState.retryCount,
        message = currentState.message;

  MeasurementsState.finished(
    MeasurementsState currentState,
  )   : networkInfoDetails = currentState.networkInfoDetails,
        prevPhase = currentState.prevPhase,
        permissions = currentState.permissions,
        this.phase = MeasurementPhase.none,
        phaseProgressResults = currentState.phaseProgressResults,
        phaseFinalResults = currentState.phaseFinalResults,
        isInitializing = currentState.isInitializing,
        isContinuing = false,
        isMeasurementScreenOpen = false,
        servers = currentState.servers,
        triedServersIds = currentState.triedServersIds,
        currentServer = currentState.currentServer,
        currentLocation = currentState.currentLocation,
        clientUuid = currentState.clientUuid,
        connectivity = currentState.connectivity,
        loopModeDetails = currentState.loopModeDetails,
        locationServicesEnabled = currentState.locationServicesEnabled,
        leavingScreenShown = currentState.leavingScreenShown,
        project = currentState.project,
        retryCount = currentState.retryCount,
        message = currentState.message;

  MeasurementsState.removeObsoleteInformation(
    MeasurementsState currentState,
  )   : networkInfoDetails = currentState.networkInfoDetails
            .copyWith(currentAllSignalInfo: [], measurementSignalInfo: []),
        prevPhase = currentState.prevPhase,
        permissions = currentState.permissions,
        phase = currentState.phase,
        phaseProgressResults = currentState.phaseProgressResults,
        phaseFinalResults = currentState.phaseFinalResults,
        isInitializing = currentState.isInitializing,
        isContinuing = currentState.isContinuing,
        isMeasurementScreenOpen = currentState.isMeasurementScreenOpen,
        servers = currentState.servers,
        triedServersIds = currentState.triedServersIds,
        currentServer = currentState.currentServer,
        currentLocation = null,
        clientUuid = currentState.clientUuid,
        connectivity = currentState.connectivity,
        loopModeDetails = currentState.loopModeDetails,
        locationServicesEnabled = currentState.locationServicesEnabled,
        leavingScreenShown = currentState.leavingScreenShown,
        project = currentState.project,
        retryCount = currentState.retryCount,
        message = currentState.message;

  MeasurementsState copyWith({
    NetworkInfoDetails? networkInfoDetails,
    bool? isInitializing,
    bool? isContinuing,
    bool? isMeasurementScreenOpen,
    MeasurementPhase? prevPhase,
    MeasurementPhase? phase,
    Map<MeasurementPhase, List<double>>? phaseProgress,
    Map<MeasurementPhase, double?>? phaseFinalResults,
    PermissionsMap? permissions,
    List<MeasurementServer>? servers,
    Set<int>? triedServersIds,
    MeasurementServer? currentServer,
    LocationModel? currentLocation,
    Exception? error,
    String? clientUuid,
    ConnectivityResult? connectivity,
    LoopModeDetails? loopModeDetails,
    bool? enableAppPrivateIp,
    bool? enableAppIpColorCoding,
    NTProject? project,
    bool? locationServicesEnabled,
    bool? leavingScreenShown,
    int? retryCount,
    String? message,
  }) {
    return MeasurementsState(
      networkInfoDetails: networkInfoDetails ?? this.networkInfoDetails,
      isInitializing: isInitializing ?? this.isInitializing,
      isContinuing: isContinuing ?? this.isContinuing,
      isMeasurementScreenOpen:
          isMeasurementScreenOpen ?? this.isMeasurementScreenOpen,
      prevPhase: prevPhase ?? this.prevPhase,
      phase: phase ?? this.phase,
      phaseProgressResults: phaseProgress ?? this.phaseProgressResults,
      phaseFinalResults: phaseFinalResults ?? this.phaseFinalResults,
      permissions: permissions ?? this.permissions,
      servers: servers ?? this.servers,
      triedServersIds: triedServersIds ?? this.triedServersIds,
      currentServer: currentServer ?? this.currentServer,
      currentLocation: currentLocation ?? this.currentLocation,
      error: error,
      clientUuid: clientUuid ?? this.clientUuid,
      loopModeDetails: loopModeDetails ?? this.loopModeDetails,
      connectivity: connectivity ?? this.connectivity,
      project: project ?? this.project,
      locationServicesEnabled:
          locationServicesEnabled ?? this.locationServicesEnabled,
      leavingScreenShown: leavingScreenShown ?? this.leavingScreenShown,
      retryCount: retryCount ?? this.retryCount,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        networkInfoDetails,
        isInitializing,
        isContinuing,
        isMeasurementScreenOpen,
        prevPhase,
        phase,
        phaseProgressResults,
        phaseFinalResults,
        permissions,
        servers,
        triedServersIds,
        currentServer,
        currentLocation,
        error,
        clientUuid,
        connectivity,
        loopModeDetails,
        locationServicesEnabled,
        leavingScreenShown,
        project,
        retryCount,
        message
      ];

  @override
  String get formattedMedianPhaseResult {
    switch (phase) {
      case MeasurementPhase.jitter:
        return _formatNanosToMillis(loopModeDetails
                    .medians[MeasurementPhase.jitter]?.medianValue)
                ?.toString() ??
            "-";
      case MeasurementPhase.latency:
        return _formatNanosToMillis(loopModeDetails
                    .medians[MeasurementPhase.latency]?.medianValue)
                ?.toString() ??
            "-";
      case MeasurementPhase.down:
        return _formatSpeed(
                loopModeDetails.medians[MeasurementPhase.down]?.medianValue) ??
            "-";
      case MeasurementPhase.initUp:
      case MeasurementPhase.up:
        return _formatSpeed(
                loopModeDetails.medians[MeasurementPhase.up]?.medianValue) ??
            "-";
      case MeasurementPhase.packLoss:
        return _formatPercents(loopModeDetails
                    .medians[MeasurementPhase.packLoss]?.medianValue)
                ?.toString() ??
            "-";
      case MeasurementPhase.none:
      case MeasurementPhase.fetchingTestParams:
      case MeasurementPhase.wait:
      case MeasurementPhase.init:
      case MeasurementPhase.submittingTestResult:
      default:
        return "-";
    }
  }

  MeasurementServer? get nextServer {
    try {
      final nextServer =
          servers!.firstWhere((el) => !triedServersIds.contains(el.id));
      return nextServer;
    } catch (_) {
      return null;
    }
  }

  _formatSpeed(double? speed) {
    if (speed == null) {
      return null;
    } else {
      return speed.roundSpeed();
    }
  }

  String? _formatNanosToMillis(double? nanos) {
    if (nanos != null && nanos >= 0) {
      return (nanos / 1000000.0).round().toString();
    } else {
      return null;
    }
  }

  String? _formatPercents(double? percents) {
    if (percents != null && percents >= 0) {
      return percents.toString();
    } else {
      return null;
    }
  }

  @override
  String get medianPhaseUnits {
    switch (phase) {
      case MeasurementPhase.jitter:
        return MeasurementPhase.jitter.resultUnits;
      case MeasurementPhase.latency:
        return MeasurementPhase.latency.resultUnits;
      case MeasurementPhase.down:
        return MeasurementPhase.down.resultUnits;
      case MeasurementPhase.initUp:
      case MeasurementPhase.up:
        return MeasurementPhase.up.resultUnits;
      case MeasurementPhase.packLoss:
        return MeasurementPhase.packLoss.progressUnits;
      case MeasurementPhase.none:
      case MeasurementPhase.fetchingTestParams:
      case MeasurementPhase.wait:
      case MeasurementPhase.init:
      case MeasurementPhase.submittingTestResult:
      default:
        return "";
    }
  }
}
