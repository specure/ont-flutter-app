import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/modules/history/models/history.dart';

class HistoryApiService extends DioService {
  HistoryApiService({bool testing = false}) : super(testing: testing);

  Future<History?> getSpeedHistory(
      int page, List<String>? networkTypes, List<String>? devices,
      {ErrorHandler? errorHandler}) async {
    final String? clientUUID =
        await GetIt.I.get<SharedPreferencesWrapper>().clientUuid;
    History? history;
    try {
      var response = await dio.post(
        '***REMOVED***?page=$page&size=100&sort=measurementDate,desc',
        data: {
          'uuid': clientUUID,
          'devices': devices,
          'network_types': networkTypes,
        },
      );
      history = History.fromJson(response.data['measurements']);
    } on DioError catch (e) {
      print(e);
      errorHandler?.process(e);
    }
    return history;
  }
}
