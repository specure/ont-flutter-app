import 'package:dio/dio.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-error.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';

class MeasurementsApiService extends DioService {
  MeasurementsApiService({bool testing = false}) : super(testing: testing);

  Future<Response?> sendMeasurementResults(MeasurementResult result,
      {ErrorHandler? errorHandler}) async {
    try {
      return await dio.post(
        NTUrls.csResultRoute,
        data: result.toJson(),
      );
    } on DioException catch (e) {
      print(e);
      errorHandler?.process(MeasurementError(e.message));
      return null;
    }
  }

  Future<List<MeasurementServer>> getMeasurementServersForCurrentFlavor({
    LocationModel? location,
    ErrorHandler? errorHandler,
    NTProject? project,
  }) async {
    try {
      final queryParameters = location != null
          ? {
              'latitude': location.latitude,
              'longitude': location.longitude,
            }
          : null;
      final response = await dio.get(
        NTUrls.csMeasurementServerRoute,
        queryParameters: queryParameters,
      );
      final serverType =
          project?.enableAppRmbtServer == true ? "RMBT" : "RMBTws";
      if (response.data is List && (response.data as List).isNotEmpty) {
        return MeasurementServer.fromJsonToList(response.data, serverType);
      } else {
        return [];
      }
    } on DioException catch (e) {
      print(e);
      errorHandler?.process(e);
      return [];
    }
  }
}
