import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/network.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';

class MeasurementBlocConnectivityChangesHandler
    implements ConnectivityChangesHandler {
  @override
  process(ConnectivityResult connectivity) {
    GetIt.I
        .get<MeasurementsBloc>()
        .add(GetNetworkInfo(connectivity: connectivity));
  }
}
