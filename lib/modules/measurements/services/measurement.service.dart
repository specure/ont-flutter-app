import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/api-errors.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/bloc-event.dart';
import 'package:nt_flutter_standalone/core/services/max-mind.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-error.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';
import 'package:nt_flutter_standalone/modules/measurements/wrappers/carrier-info.wrapper.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../measurement-result/models/loop-mode-settings-model.dart';

const String testStartedMessage = 'TEST_STARTED';
const String testStoppedMessage = 'TEST_STOPPED';

class MeasurementService {
  final MethodChannel channel;
  MeasurementPhase? lastPhase;
  BlocEvent? lastDispatchedEvent;
  final _prefs = GetIt.I.get<SharedPreferencesWrapper>();
  final _carrier = GetIt.I.get<CarrierInfoWrapper>();
  final _platform = GetIt.I.get<PlatformWrapper>();

  MeasurementService({
    this.channel = const MethodChannel('nettest/measurements'),
  }) {
    channel.setMethodCallHandler(platformCallHandler);
  }

  Future<String?> startTest(
    String flavor, {
    String? clientUUID,
    LocationModel? location,
    int? measurementServerId,
    LoopModeSettings? loopModeSettings,
    enableAppJitterAndPacketLoss = false,
  }) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final params = {
        'appVersion': '${packageInfo.version} (${packageInfo.buildNumber})',
        'clientUUID': clientUUID,
        'flavor': flavor,
        'location': location != null ? location.toJson() : {},
        'selectedMeasurementServerId': measurementServerId,
        'loopModeSettings': loopModeSettings?.toJson(),
        'enableAppJitterAndPacketLoss': enableAppJitterAndPacketLoss,
        'telephonyPermissionGranted':
            _prefs.getBool(StorageKeys.phoneStatePermissionsGranted),
        'locationPermissionGranted':
            _prefs.getBool(StorageKeys.locationPermissionsGranted),
        'uuidPermissionGranted':
            _prefs.getBool(StorageKeys.persistentClientUuidEnabled)
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
          lastDispatchedEvent = CompleteMeasurement(
              MeasurementResult.fromPlatformChannelArguments(call.arguments));
          bloc.add(lastDispatchedEvent!);
          break;
        case "measurementResultSubmitted":
          lastDispatchedEvent =
              OnMeasurementComplete(call.arguments ?? unknown);
          bloc.add(lastDispatchedEvent!);
          break;
        case "measurementDidFail":
          final String? error =
              bloc.state.connectivity == ConnectivityResult.none
                  ? ApiErrors.noInternetConnection
                  : call.arguments;
          lastDispatchedEvent = SetError(MeasurementError(error));
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
}
