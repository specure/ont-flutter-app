import 'package:dio/dio.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';

class TechnologyApiService extends DioService {
  TechnologyApiService({bool testing = false}) : super(testing: testing);

  Future<List<String>> getMobileOperators() async {
    try {
      var response = await dio.get('/nationalTable');
      List<dynamic> list = response.data['statsByProvider'];
      return list.map((item) => item['providerName'] as String).toList();
    } on DioError catch (e) {
      print(e);
      return [];
    }
  }
}
