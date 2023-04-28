import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/ping.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/radio-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/speed-detail.dart';

import '../../measurement-result/models/loop-mode-settings-model.dart';

part 'measurement-result.g.dart';

@JsonSerializable()
class MeasurementResult {
  @JsonKey(name: 'client_uuid')
  final String uuid;
  @JsonKey(name: 'test_token')
  final String testToken;
  @JsonKey(name: 'model')
  String? model;
  @JsonKey(name: 'os_version')
  String? osVersion;
  @JsonKey(name: 'device')
  String? device;
  @JsonKey(name: 'api_level')
  String? apiLevel;
  @JsonKey(name: 'product')
  String? product;
  @JsonKey(name: 'client_version')
  String? clientVersion;
  @JsonKey(name: 'client_language')
  String? clientLanguage;
  @JsonKey(name: 'test_encryption')
  String? testEncryption;
  @JsonKey(name: 'speed_detail', toJson: SpeedDetail.toJsonList)
  List<SpeedDetail>? speedDetail;
  @JsonKey(name: 'pings', toJson: Ping.toJsonList)
  List<Ping>? pings;
  @JsonKey(name: 'radioInfo')
  RadioInfo? radioInfo;
  @JsonKey(name: 'dual_sim')
  bool? dualSim;
  @JsonKey(name: 'network_type')
  int? networkType;
  @JsonKey(name: 'client_name')
  final String clientName;
  @JsonKey(name: 'test_bytes_download')
  final int bytesDownload;
  @JsonKey(name: 'test_bytes_upload')
  final int bytesUpload;
  @JsonKey(name: 'test_nsec_download')
  final int nsecDownload;
  @JsonKey(name: 'test_nsec_upload')
  final int nsecUpload;
  @JsonKey(name: 'test_total_bytes_download')
  final int totalDownloadBytes;
  @JsonKey(name: 'test_total_bytes_upload')
  final int totalUploadBytes;
  @JsonKey(name: 'test_speed_download')
  final double speedDownload;
  @JsonKey(name: 'test_speed_upload')
  final double speedUpload;
  @JsonKey(name: 'test_ping_shortest')
  final int pingShortest;
  @JsonKey(name: 'test_ip_server')
  final String serverIpAddress;
  @JsonKey(name: 'test_ip_local')
  final String localIpAddress;
  @JsonKey(name: 'voip_result_packet_loss_percents')
  double? packetLoss;
  @JsonKey(name: 'voip_result_jitter_millis')
  int? jitter;
  @JsonKey(name: 'test_num_threads')
  final int testNumThreads;
  @JsonKey(name: 'test_port_remote')
  final int testPortRemote;
  @JsonKey(name: 'time')
  int time;
  @JsonKey(name: 'platform')
  String? platform;

  @JsonKey(name: 'sim_mcc_mnc')
  String? telephonyNetworkSimOperator;
  @JsonKey(name: 'sim_operator_name')
  String? telephonyNetworkSimOperatorName;
  @JsonKey(name: 'sim_country')
  String? telephonyNetworkSimCountry;
  @JsonKey(name: 'network_mcc_mnc')
  String? telephonyNetworkOperator;
  @JsonKey(name: 'network_operator_name')
  String? telephonyNetworkOperatorName;
  @JsonKey(name: 'network_country')
  String? telephonyNetworkCountry;
  @JsonKey(name: 'network_is_roaming')
  bool? telephonyNetworkIsRoaming;
  @JsonKey(name: 'loopmode_info')
  LoopModeSettings? loopModeInfo;

  MeasurementResult({
    required this.uuid,
    required this.testToken,
    required this.clientName,
    required this.bytesDownload,
    required this.bytesUpload,
    required this.nsecDownload,
    required this.nsecUpload,
    required this.totalDownloadBytes,
    required this.totalUploadBytes,
    required this.speedDownload,
    required this.speedUpload,
    required this.pingShortest,
    required this.serverIpAddress,
    required this.localIpAddress,
    required this.testNumThreads,
    required this.testPortRemote,
    this.model,
    this.osVersion,
    this.device,
    this.apiLevel,
    this.product,
    this.clientVersion,
    this.testEncryption,
    this.speedDetail,
    this.pings,
    this.radioInfo,
    this.clientLanguage,
    this.networkType,
    this.packetLoss,
    this.jitter,
    this.time = 0,
    this.platform,
    this.dualSim,
    this.telephonyNetworkSimOperator,
    this.telephonyNetworkSimOperatorName,
    this.telephonyNetworkSimCountry,
    this.telephonyNetworkOperator,
    this.telephonyNetworkOperatorName,
    this.telephonyNetworkCountry,
    this.telephonyNetworkIsRoaming,
    this.loopModeInfo
  });

  MeasurementHistoryResult mapToHistoryResult() {
    return MeasurementHistoryResult(
        testUuid: this.uuid,
        downloadKbps: this.speedDownload,
        uploadKbps: this.speedUpload,
        pingMs: this.pingShortest / 1000000,
        jitterMs: (this.jitter?.toDouble() ?? -1) >= 0.0
            ? this.jitter!.toDouble()
            : null,
        packetLossPercents:
            (this.packetLoss ?? -1) >= 0.0 ? this.packetLoss : null,
        measurementDate:
            DateTime.fromMillisecondsSinceEpoch(this.time).toIso8601String(),
        networkType: serverNetworkClassFromNumber[this.networkType]);
  }

  factory MeasurementResult.fromJson(Map<String, dynamic> json) =>
      _$MeasurementResultFromJson(json);
  Map<String, dynamic> toJson() => _$MeasurementResultToJson(this);

  factory MeasurementResult.fromPlatformChannelArguments(dynamic arguments) {
    return MeasurementResult(
      uuid: arguments?['client_uuid'] ?? unknown,
      testToken: arguments?['test_token'] ?? unknown,
      clientVersion: arguments?['client_version'],
      testEncryption: arguments?['test_encryption'],
      speedDetail: arguments?['speed_detail'] != null
          ? (arguments['speed_detail'] as List<Object?>).map((item) {
              item = item as Map;
              return SpeedDetail(
                bytes: item['bytes'],
                direction: item['direction'],
                thread: item['thread'],
                time: item['time'],
              );
            }).toList()
          : null,
      pings: arguments?['pings'] != null
          ? (arguments['pings'] as List<Object?>).map((item) {
              item = item as Map;
              return Ping(
                valueClient: item['value'],
                valueServer: item['value_server'],
                timeNS: item['time_ns'],
              );
            }).toList()
          : null,
      packetLoss: arguments?['voip_result_packet_loss_percents'],
      jitter: arguments?['voip_result_jitter_millis'],
      clientName: arguments?['client_name'] ?? unknown,
      bytesDownload: arguments?['test_bytes_download'] ?? 0,
      bytesUpload: arguments?['test_bytes_upload'] ?? 0,
      nsecDownload: arguments?['test_nsec_download'] ?? 0,
      nsecUpload: arguments?['test_nsec_upload'] ?? 0,
      totalDownloadBytes: arguments?['test_total_bytes_download'] ?? 0,
      totalUploadBytes: arguments?['test_total_bytes_upload'] ?? 0,
      speedDownload: arguments?['test_speed_download'] ?? 0,
      speedUpload: arguments?['test_speed_upload'] ?? 0,
      pingShortest: arguments?['test_ping_shortest'] ?? 0,
      testNumThreads: arguments?['test_num_threads'] ?? 0,
      testPortRemote: arguments?['test_port_remote'] ?? 0,
      serverIpAddress: arguments?['test_ip_server'] ?? unknown,
      localIpAddress: arguments?['test_ip_local'] ?? unknown,
      time: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
