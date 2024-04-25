import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nt_flutter_standalone/core/models/bloc-event.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/loop-mode-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/permissions-map.dart';

class Initialize extends BlocEvent {
  Initialize() : super(null);
}

class GetNetworkInfo extends BlocEvent<ConnectivityResult> {
  GetNetworkInfo({required ConnectivityResult connectivity})
      : super(connectivity);
}

class SignalUpdate extends BlocEvent<NetworkInfoDetails> {
  SignalUpdate({required NetworkInfoDetails networkDetails})
      : super(networkDetails);
}

class SetLocationInfo extends BlocEvent<LocationModel?> {
  SetLocationInfo(LocationModel? location) : super(location);
}

class RemoveObsoleteInfo extends BlocEvent {
  RemoveObsoleteInfo() : super(null);
}

class StartMeasurement extends BlocEvent {
  StartMeasurement() : super(null);
}

class StartMeasurementPhase extends BlocEvent<MeasurementPhase> {
  StartMeasurementPhase(MeasurementPhase phase) : super(phase);
}

class SetPhaseFinalResult
    extends BlocEvent<MapEntry<MeasurementPhase, double?>> {
  SetPhaseFinalResult(MeasurementPhase phase, double? result)
      : super(MapEntry(phase, result));
}

class SetPhaseResult extends BlocEvent<double> {
  SetPhaseResult(double result) : super(result);
}

class StopMeasurement extends BlocEvent {
  StopMeasurement() : super(null);
}

class CompleteAndroidMeasurement extends BlocEvent<MeasurementResult> {
  CompleteAndroidMeasurement(MeasurementResult result) : super(result);
}

class CompleteIOSMeasurement extends BlocEvent<String> {
  CompleteIOSMeasurement(String testUuid) : super(testUuid);
}

class SetPermissions extends BlocEvent<PermissionsMap> {
  SetPermissions(PermissionsMap permissionsMap) : super(permissionsMap);
}

class SetMeasurmentScreenOpen extends BlocEvent<bool> {
  SetMeasurmentScreenOpen(bool isMeasurementScreenOpen)
      : super(isMeasurementScreenOpen);
}

class OpenResultScreenFromHistory extends BlocEvent<String> {
  OpenResultScreenFromHistory(String testUuid) : super(testUuid);
}

class SetError extends BlocEvent<Exception?> {
  SetError(Exception? error) : super(error);
}

class SetCurrentServer extends BlocEvent<MeasurementServer> {
  SetCurrentServer(MeasurementServer payload) : super(payload);
}

class RestartMeasurement extends BlocEvent {
  RestartMeasurement() : super(null);
}

class MeasurementPostFinish extends BlocEvent {
  MeasurementPostFinish() : super(null);
}

class HomeScreenLeft extends BlocEvent {
  HomeScreenLeft() : super(null);
}

class LoopModeDetailsChanged extends BlocEvent<LoopModeDetails> {
  LoopModeDetailsChanged(LoopModeDetails loopModeDetails)
      : super(loopModeDetails);
}

class CheckIfLoopModeShouldStart extends BlocEvent {
  CheckIfLoopModeShouldStart() : super(null);
}

class MeasurementLoopUuidObtained extends BlocEvent {
  MeasurementLoopUuidObtained(String loopUuid) : super(loopUuid);
}

class LocationServiceStateChanged extends BlocEvent<bool> {
  LocationServiceStateChanged(bool locationServicesEnabled)
      : super(locationServicesEnabled);
}

class CloseDialogVisibilityChanged extends BlocEvent<bool> {
  CloseDialogVisibilityChanged(bool visible) : super(visible);
}
