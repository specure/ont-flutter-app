import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/models/max-mind-info.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/ip-info.service.dart';

class MaxMindService extends DioService {
  final IPInfoService _ipService = GetIt.I.get<IPInfoService>();
  String? _lastIp;
  MaxMindInfo? _lastInfo;

  Future<MaxMindInfo?> getInfoForCurrentIp() async {
    var ip = await _ipService.getPublicAddress(IPVersion.v4);
    if (ip == addressIsNotAvailable) {
      ip = await _ipService.getPublicAddress(IPVersion.v6);
    }
    if (ip == _lastIp) {
      return _lastInfo;
    }
    final Response<Map<String, dynamic>> info =
        await dio.get('/maxmind-details', queryParameters: {"ip": ip});
    if (info.data != null) {
      _lastIp = ip;
      _lastInfo = MaxMindInfo.fromJson(info.data!);
      return _lastInfo;
    }
    return null;
  }
}
