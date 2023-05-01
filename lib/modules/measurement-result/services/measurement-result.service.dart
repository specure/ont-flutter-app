import 'package:dio/dio.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/speed-curve.item.dart';

class MeasurementResultService extends DioService {
  MeasurementResultService({bool testing = false}) : super(testing: testing);

  Future<MeasurementHistoryResult?> getMeasurementHistoryResult(String uuid,
      {ErrorHandler? errorHandler}) async {
    try {
      var response = await dio.get('${NTUrls.csResultsRoute}/$uuid');
      return MeasurementHistoryResult.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      errorHandler?.process(e);
      return null;
    }
  }

  Future<Map<String, List<SpeedCurveItem>>?> getMeasurementSpeedGraphs(
      String uuid,
      {ErrorHandler? errorHandler}) async {
    try {
      var response = await dio.get('${NTUrls.csGraphsRoute}/$uuid');
      return {
        'download': SpeedCurveItem.fromJsonToList(
            response.data['speed_curve']['download']),
        'upload': SpeedCurveItem.fromJsonToList(
            response.data['speed_curve']['upload']),
      };
    } on DioError catch (e) {
      print(e);
      errorHandler?.process(e);
      return null;
    }
  }

  Future<MeasurementHistoryResult?> getResultWithSpeedCurves(
    String uuid, {
    MeasurementHistoryResult? result,
    ErrorHandler? errorHandler,
  }) async {
    final graphs = await getMeasurementSpeedGraphs(
      uuid,
      errorHandler: errorHandler,
    );
    if (result == null) {
      result = await getMeasurementHistoryResult(
        uuid,
        errorHandler: errorHandler,
      );
    }
    List<SpeedCurveItem> download = graphs?['download'] ?? [];
    List<SpeedCurveItem> upload = graphs?['upload'] ?? [];
    List<double> downloadSpeed = _getSpeedCurveFromGraph(download);
    List<double> uploadSpeed = _getSpeedCurveFromGraph(upload);
    return result?.withSpeedDetails(downloadSpeed, uploadSpeed);
  }

  List<double> _getSpeedCurveFromGraph(List<SpeedCurveItem> list) {
    final listLength = list.length;
    List<double> speedList = [];
    var index = 1;
    for (int i = 0; i < listLength - 1; i++) {
      var prevTimeDiff = 1000 - (list[index - 1].time % 1000);
      var currentTimeDiff = 1000 - (list[index].time % 1000);
      if (prevTimeDiff > currentTimeDiff || prevTimeDiff == currentTimeDiff) {
        list.removeAt(index - 1);
      } else {
        index++;
      }
    }
    for (int i = 0; i < list.length - 1; i++) {
      speedList.add((list[i + 1].bytes - list[i].bytes) / 125000);
    }
    return speedList;
  }
}
