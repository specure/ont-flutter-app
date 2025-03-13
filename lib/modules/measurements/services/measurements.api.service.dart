import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-error.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';

class MeasurementsApiService extends DioService {
  final SharedPreferencesWrapper _sharedPreferences =
      GetIt.I.get<SharedPreferencesWrapper>();
  List<MeasurementServer> _servers = [];

  List<MeasurementServer> get servers => _servers;

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
    final serverType = project?.enableAppRmbtServer == true ? "RMBT" : "RMBTws";
    final cachedServers =
        _sharedPreferences.getString(StorageKeys.measurementServers);
    final getFromApi = () => _getMeasurementServersFromApi(
          location: location,
          errorHandler: errorHandler,
          serverType: serverType,
        );
    if (cachedServers != null) {
      getFromApi();
      try {
        final decoded = jsonDecode(cachedServers);
        _servers = MeasurementServer.fromJsonToList(decoded, serverType);
        return _servers;
      } catch (e) {
        print(e);
        return [];
      }
    }
    return getFromApi();
  }

  Future<List<MeasurementServer>> _getMeasurementServersFromApi({
    LocationModel? location,
    ErrorHandler? errorHandler,
    required String serverType,
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
      if (response.data is List && (response.data as List).isNotEmpty) {
        _servers = MeasurementServer.fromJsonToList(response.data, serverType);
        try {
          _sharedPreferences.setString(
            StorageKeys.measurementServers,
            jsonEncode(_servers),
          );
        } catch (e) {
          print(e);
        }
        return _servers;
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
