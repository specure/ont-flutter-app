import 'package:dio/dio.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';

class TechnologyApiService extends DioService {
  TechnologyApiService({bool testing = false}) : super(testing: testing);

  Future<List<String>> getMnoProviders() async {
    try {
      var response = await dio.get(NTUrls.csMnoProvidersRoute);
      return _parseResponse(response);
    } on DioError catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<String>> getIspProviders() async {
    try {
      var response = await dio.get(NTUrls.csIspProvidersRoute);
      return _parseResponse(response);
    } on DioError catch (e) {
      print(e);
      return [];
    }
  }

  List<String> _parseResponse(Response<dynamic> response) {
    List<dynamic> list = response.data['statsByProvider'];
    return list.map((item) => item['providerName'] as String).toList();
  }
}
