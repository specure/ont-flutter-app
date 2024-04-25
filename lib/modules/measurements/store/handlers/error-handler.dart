import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';

class MeasurementBlocErrorHandler implements ErrorHandler {
  @override
  process(Exception? error) {
    if (error != null) {
      GetIt.I.get<MeasurementsBloc>().add(SetError(error));
    }
  }
}
