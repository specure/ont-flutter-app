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
    Map<int, SpeedCurveItem> dedupedMap = {};
    for (int i = 0; i < list.length - 1; i++) {
      dedupedMap[list[i].time] = list[i];
    }
    List<double> speedList = [];
    List<SpeedCurveItem> dedupedList = dedupedMap.values.toList();
    for (int i = 0; i < dedupedList.length - 1; i++) {
      final thisItem = dedupedList[i];
      speedList.add(thisItem.bytes / thisItem.time);
    }
    return speedList;
  }
}
