import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/loop-mode-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/loop.mode.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';

class MeasurementBlocLoopMeasurementChangesHandler
    implements LoopModeChangesHandler {
  @override
  onLoopModeDetailsChanged(LoopModeDetails loopModeDetails) {
    GetIt.I
        .get<MeasurementsBloc>()
        .add(LoopModeDetailsChanged(loopModeDetails));
  }
}
