import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/models/net-neutrality-history.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-list-factory.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-result.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-settings-response.dart';

class NetNeutralityApiService extends DioService {
  NetNeutralityApiService({bool testing = false}) : super(testing: testing);

  Future<NetNeutralitySettingsResponse?> getSettings(
      {ErrorHandler? errorHandler}) async {
    try {
      final response = await dio.get(NTUrls.csNNRequestRoute);
      return NetNeutralitySettingsResponse.fromJson(response.data);
    } on DioException catch (e) {
      print(e);
      errorHandler?.process(e);
      return null;
    }
  }

  Future<void> postResults(
      {NetNeutralityResult? results, ErrorHandler? errorHandler}) async {
    try {
      await dio.post(NTUrls.csNNResultRoute, data: results?.toJson());
    } on DioException catch (e) {
      print(e);
      errorHandler?.process(e);
      return null;
    }
  }

  Future<List<NetNeutralityHistoryItem>?> getHistory(String openTestUuid,
      {ErrorHandler? errorHandler}) async {
    try {
      final uuid = GetIt.I
          .get<SharedPreferencesWrapper>()
          .getString(StorageKeys.clientUuid);
      final Response<Map<String, dynamic>> response = await dio.get(
          '${NTUrls.csNNHistoryRoute}?sort=measurementDate,desc&uuid=$uuid&openTestUuid=$openTestUuid');
      return NetNeutralityHistoryListFactory.parseHistoryResponse(
        response.data,
      );
    } on DioException catch (e) {
      print(e);
      errorHandler?.process(e);
      return null;
    }
  }

  Future<NetNeutralityHistory?> getWholeHistory(int page,
      {ErrorHandler? errorHandler}) async {
    try {
      final uuid = GetIt.I
          .get<SharedPreferencesWrapper>()
          .getString(StorageKeys.clientUuid);
      final Response<Map<String, dynamic>> response = await dio.get(
          '${NTUrls.csNNHistoryRoute}?page=$page&size=100&sort=measurementDate,desc&uuid=$uuid');
      final data = NetNeutralityHistoryListFactory.parseWholeHistoryResponse(
          response.data);
      return NetNeutralityHistory(
          content: data,
          totalElements: response.data?['totalElements'],
          totalPages: response.data?['totalPages'],
          last: response.data?['last']);
    } on DioException catch (e) {
      print(e);
      errorHandler?.process(e);
      return null;
    }
  }
}
