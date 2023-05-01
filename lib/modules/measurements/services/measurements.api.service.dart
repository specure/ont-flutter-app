import 'package:dio/dio.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';

class MeasurementsApiService extends DioService {
  MeasurementsApiService({bool testing = false}) : super(testing: testing);

  Future sendMeasurementResults(MeasurementResult result,
      {ErrorHandler? errorHandler}) async {
    try {
      return await dio.post(
        NTUrls.csResultRoute,
        data: result.toJson(),
      );
    } on DioError catch (e) {
      print(e);
      errorHandler?.process(e);
    }
  }

  Future<List<MeasurementServer>> getMeasurementServersForCurrentFlavor({
    LocationModel? location,
    ErrorHandler? errorHandler,
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
      return MeasurementServer.fromJsonToList(response.data);
    } on DioError catch (e) {
      print(e);
      errorHandler?.process(e);
      return [];
    }
  }
}
