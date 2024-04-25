import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/api-errors.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/extensions/list.ext.dart';
import 'package:nt_flutter_standalone/core/models/bloc-event.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/services/max-mind.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-error.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';
import 'package:nt_flutter_standalone/modules/measurements/wrappers/carrier-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/wrappers/ping.wrapper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:system_clock/system_clock.dart';

import '../../measurement-result/models/loop-mode-settings-model.dart';

const String testStartedMessage = 'TEST_STARTED';
const String testStoppedMessage = 'TEST_STOPPED';
const pingSummaryEventCount = 1;

class MeasurementService {
  final MethodChannel channel;
  MeasurementPhase? lastPhase;
  BlocEvent? lastDispatchedEvent;
  final _prefs = GetIt.I.get<SharedPreferencesWrapper>();
  final _carrier = GetIt.I.get<CarrierInfoWrapper>();
  final _platform = GetIt.I.get<PlatformWrapper>();
  List<double> _pingsNs = [];
  double _testStartNs = 0;
  double? _packLoss = 0;
  double? _jitterNs = 0;
  StreamSubscription? _pingStream;

  MeasurementService({
    this.channel = const MethodChannel('nettest/measurements'),
  }) {
    channel.setMethodCallHandler(platformCallHandler);
  }

  Future<String?> startTest(
    String flavor, {
    String? clientUUID,
    LocationModel? location,
    MeasurementServer? measurementServer,
    LoopModeSettings? loopModeSettings,
    NTProject? project,
  }) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final params = {
        'appVersion': '${packageInfo.version} (${packageInfo.buildNumber})',
        'clientUUID': clientUUID,
        'flavor': flavor,
        'location': location != null ? location.toJson() : {},
        'measurementServer': measurementServer?.toTargetMeasurementServer(
          serverType: project?.enableAppRmbtServer == true ? "RMBT" : "RMBTws",
        ),
        'loopModeSettings': loopModeSettings?.toJson(),
        'telephonyPermissionGranted':
            _prefs.getBool(StorageKeys.phoneStatePermissionsGranted),
        'locationPermissionGranted':
            _prefs.getBool(StorageKeys.locationPermissionsGranted),
        'uuidPermissionGranted':
            _prefs.getBool(StorageKeys.persistentClientUuidEnabled),
        'pingsNs': _pingsNs,
        'testStartNs': _testStartNs,
        'packetLoss': _packLoss,
        'jitterNs': _jitterNs
      };
      var carrierName = await _carrier.getNativeCarrierName();
      if (_platform.isIOS && carrierName == unknown) {
        final maxMindInfo =
            await GetIt.I.get<MaxMindService>().getInfoForCurrentIp();
        params["telephonyInfo"] = {
          'telephonyNetworkSimOperator':
              "${maxMindInfo?.traits.mobileCountryCode}-${maxMindInfo?.traits.mobileNetworkCode}",
          'telephonyNetworkSimCountry': maxMindInfo?.registeredCountry.iso,
          'telephonyNetworkOperatorName': maxMindInfo?.traits.organization,
          'telephonyNetworkSimOperatorName': maxMindInfo?.traits.isp,
        };
      }
      final message = await channel.invokeMethod(
        'startTest',
        params,
      );
      return message;
    } on PlatformException catch (err) {
      print(err);
      return null;
    }
  }

  Future<String?> stopTest() async {
    try {
      final message = await channel.invokeMethod('stopTest');
      return message;
    } on PlatformException catch (err) {
      print(err);
      return null;
    }
  }

  Future<void> startPingTest({String? host, NTProject? project}) async {
    _resetAllPhasesResults();
    final bloc = GetIt.I.get<MeasurementsBloc>();
    // To add visual initialization
    await Future.delayed(Duration(milliseconds: 600), () {
      lastPhase = MeasurementPhase.latency;
      lastDispatchedEvent = StartMeasurementPhase(MeasurementPhase.latency);
      bloc.add(lastDispatchedEvent!);
    });
    if (host == null || host.isEmpty) {
      throw MeasurementError.pingFailed;
    }
    double durationS = 3;
    double intervalS = 0.2;
    if (project != null) {
      durationS = max(durationS, project.pingDuration);
      intervalS = max(intervalS, project.pingInterval);
    }
    final count = durationS ~/ intervalS + pingSummaryEventCount;
    final List<PingResponse> pings = [];
    int progressCount = 0;
    double progressPercent = 0;
    final ping = GetIt.I
        .get<PingWrapper>()
        .getIstance(host, count: count, intervalS: intervalS);
    _testStartNs = SystemClock.uptime().inMilliseconds / 1e9;
    _pingStream = ping?.stream.listen(handlePingEvent(
      count: count,
      progressCount: progressCount,
      progressPercent: progressPercent,
      pings: pings,
      ping: ping,
    ));
    return _pingStream?.asFuture();
  }

  Future platformCallHandler(MethodCall call) async {
    print("MEASUREMENT: ${call.method}: ${call.arguments}");
    try {
      final int? phaseIdx =
          call.arguments is Map == true ? call.arguments["phase"] : null;
      final MeasurementPhase phase = phaseIdx != null
          ? MeasurementPhase.values[phaseIdx]
          : MeasurementPhase.none;
      final bloc = GetIt.I.get<MeasurementsBloc>();
      switch (call.method) {
        case "speedMeasurementPhaseFinalResult":
          final double finalResult = call.arguments is Map == true
              ? call.arguments["finalResult"]
              : null;
          lastDispatchedEvent = SetPhaseFinalResult(phase, finalResult);
          bloc.add(lastDispatchedEvent!);
          break;
        case "speedMeasurementDidStartPhase":
          lastPhase = phase;
          lastDispatchedEvent = StartMeasurementPhase(phase);
          bloc.add(lastDispatchedEvent!);
          break;
        case "speedMeasurementDidUpdateWith":
          // To prevent setting progress as value where result is expected
          if (lastPhase == phase &&
              [
                MeasurementPhase.latency,
                MeasurementPhase.jitter,
                MeasurementPhase.packLoss
              ].contains(phase)) {
            lastDispatchedEvent =
                SetPhaseResult(_parsePhaseProgress(phase, call));
            bloc.add(lastDispatchedEvent!);
          }
          break;
        case "speedMeasurementDidFinishPhase":
        case "speedMeasurementDidMeasureSpeed":
          if (lastPhase == phase) {
            lastDispatchedEvent =
                SetPhaseResult(_parsePhaseResult(phase, call));
            bloc.add(lastDispatchedEvent!);
          }
          break;
        case "measurementComplete":
          lastDispatchedEvent = CompleteAndroidMeasurement(
              MeasurementResult.fromPlatformChannelArguments(call.arguments));
          bloc.add(lastDispatchedEvent!);
          break;
        case "measurementResultSubmitted":
          lastDispatchedEvent =
              CompleteIOSMeasurement(call.arguments ?? unknown);
          bloc.add(lastDispatchedEvent!);
          break;
        case "measurementDidFail":
          final String? error =
              bloc.state.connectivity == ConnectivityResult.none
                  ? ApiErrors.noInternetConnection
                  : call.arguments;
          final newEvent = SetError(MeasurementError(error));
          if (newEvent.toString() == lastDispatchedEvent.toString()) {
            break;
          }
          lastDispatchedEvent = newEvent;
          bloc.add(lastDispatchedEvent!);
          break;
        case "measurementPostFinish":
          lastDispatchedEvent = MeasurementPostFinish();
          bloc.add(lastDispatchedEvent!);
          break;
        case "measurementRequestSent":
          var loopUuid =
              call.arguments is Map == true ? call.arguments["loopUuid"] : null;
          if (loopUuid != null) {
            lastDispatchedEvent = MeasurementLoopUuidObtained(loopUuid);
            bloc.add(lastDispatchedEvent!);
          }
          break;
      }
    } catch (err) {
      print(err);
    }
  }

  double _parsePhaseResult(MeasurementPhase phase, MethodCall call) {
    final double rawResult = call.arguments?["result"] ?? 0;
    if ([MeasurementPhase.down, MeasurementPhase.up].contains(phase)) {
      return (rawResult / 1000 * 100).round() / 100;
    }
    return rawResult;
  }

  double _parsePhaseProgress(MeasurementPhase phase, MethodCall call) {
    final double rawProgress = call.arguments?["progress"] ?? 0;
    return (rawProgress * 100).roundToDouble();
  }

  double _getPackLoss(List<PingResponse> pings, int count, PingData? event) {
    final transmitted = event?.summary?.transmitted ?? count;
    final received = event?.summary?.received ?? min(pings.length, count);
    return ((1 - received / transmitted) * 10).roundToDouble() * 10;
  }

  double _getJitter(List<double> pings) {
    double pingDiffs = 0;
    for (var i = 1; i < pings.length; i++) {
      pingDiffs += (pings[i] - pings[i - 1]).abs();
    }
    return pingDiffs / (pings.length - 1);
  }

  void _resetAllPhasesResults() {
    _pingStream?.cancel();
    _pingsNs = [];
    _jitterNs = null;
    _packLoss = null;
    _testStartNs = 0;
    final bloc = GetIt.I.get<MeasurementsBloc>();
    bloc.add(SetPhaseFinalResult(MeasurementPhase.latency, null));
    bloc.add(SetPhaseFinalResult(MeasurementPhase.packLoss, null));
    bloc.add(SetPhaseFinalResult(MeasurementPhase.jitter, null));
    bloc.add(SetPhaseFinalResult(MeasurementPhase.down, null));
    bloc.add(SetPhaseFinalResult(MeasurementPhase.up, null));
  }

  handlePingEvent({
    required int count,
    required int progressCount,
    required double progressPercent,
    required List<PingResponse> pings,
    Ping? ping,
  }) =>
      (PingData event) {
        print(event);
        final bloc = GetIt.I.get<MeasurementsBloc>();
        progressCount++;
        progressPercent = min(progressCount / count, 1);
        lastDispatchedEvent =
            SetPhaseResult((progressPercent * 100).roundToDouble());
        bloc.add(lastDispatchedEvent!);
        if (event.summary != null || progressCount >= count) {
          _setFinalPingResult(pings, count - pingSummaryEventCount,
              event: event);
          if (progressCount > count) {
            ping?.stop();
          }
        } else if (event.response != null) {
          pings.add(event.response!);
        }
      };

  void _setFinalPingResult(List<PingResponse> pings, int count,
      {PingData? event}) {
    try {
      final pingsWithTime = pings.where((e) => e.time != null);
      _pingsNs =
          pingsWithTime.map((e) => e.time!.inMilliseconds * 1e6).toList();
      _packLoss = _getPackLoss(pingsWithTime.toList(), count, event);
      _jitterNs = _getJitter(_pingsNs);
      final bloc = GetIt.I.get<MeasurementsBloc>();
      bloc.add(SetPhaseFinalResult(MeasurementPhase.packLoss, _packLoss));
      bloc.add(SetPhaseFinalResult(MeasurementPhase.jitter, _jitterNs));
      lastDispatchedEvent = SetPhaseFinalResult(lastPhase!, _pingsNs.median);
      bloc.add(lastDispatchedEvent!);
    } on RangeError catch (_) {
      throw MeasurementError.pingFailed;
    }
  }
}
