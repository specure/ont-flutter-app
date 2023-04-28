// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement-result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasurementResult _$MeasurementResultFromJson(Map<String, dynamic> json) =>
    MeasurementResult(
      uuid: json['client_uuid'] as String,
      testToken: json['test_token'] as String,
      clientName: json['client_name'] as String,
      bytesDownload: json['test_bytes_download'] as int,
      bytesUpload: json['test_bytes_upload'] as int,
      nsecDownload: json['test_nsec_download'] as int,
      nsecUpload: json['test_nsec_upload'] as int,
      totalDownloadBytes: json['test_total_bytes_download'] as int,
      totalUploadBytes: json['test_total_bytes_upload'] as int,
      speedDownload: (json['test_speed_download'] as num).toDouble(),
      speedUpload: (json['test_speed_upload'] as num).toDouble(),
      pingShortest: json['test_ping_shortest'] as int,
      serverIpAddress: json['test_ip_server'] as String,
      localIpAddress: json['test_ip_local'] as String,
      testNumThreads: json['test_num_threads'] as int,
      testPortRemote: json['test_port_remote'] as int,
      model: json['model'] as String?,
      osVersion: json['os_version'] as String?,
      device: json['device'] as String?,
      apiLevel: json['api_level'] as String?,
      product: json['product'] as String?,
      clientVersion: json['client_version'] as String?,
      testEncryption: json['test_encryption'] as String?,
      speedDetail: (json['speed_detail'] as List<dynamic>?)
          ?.map((e) => SpeedDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      pings: (json['pings'] as List<dynamic>?)
          ?.map((e) => Ping.fromJson(e as Map<String, dynamic>))
          .toList(),
      radioInfo: json['radioInfo'] == null
          ? null
          : RadioInfo.fromJson(json['radioInfo'] as Map<String, dynamic>),
      clientLanguage: json['client_language'] as String?,
      networkType: json['network_type'] as int?,
      packetLoss:
          (json['voip_result_packet_loss_percents'] as num?)?.toDouble(),
      jitter: json['voip_result_jitter_millis'] as int?,
      time: json['time'] as int? ?? 0,
      platform: json['platform'] as String?,
      dualSim: json['dual_sim'] as bool?,
      telephonyNetworkSimOperator: json['sim_mcc_mnc'] as String?,
      telephonyNetworkSimOperatorName: json['sim_operator_name'] as String?,
      telephonyNetworkSimCountry: json['sim_country'] as String?,
      telephonyNetworkOperator: json['network_mcc_mnc'] as String?,
      telephonyNetworkOperatorName: json['network_operator_name'] as String?,
      telephonyNetworkCountry: json['network_country'] as String?,
      telephonyNetworkIsRoaming: json['network_is_roaming'] as bool?,
      loopModeInfo: json['loopmode_info'] == null
          ? null
          : LoopModeSettings.fromJson(
              json['loopmode_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MeasurementResultToJson(MeasurementResult instance) =>
    <String, dynamic>{
      'client_uuid': instance.uuid,
      'test_token': instance.testToken,
      'model': instance.model,
      'os_version': instance.osVersion,
      'device': instance.device,
      'api_level': instance.apiLevel,
      'product': instance.product,
      'client_version': instance.clientVersion,
      'client_language': instance.clientLanguage,
      'test_encryption': instance.testEncryption,
      'speed_detail': SpeedDetail.toJsonList(instance.speedDetail),
      'pings': Ping.toJsonList(instance.pings),
      'radioInfo': instance.radioInfo,
      'dual_sim': instance.dualSim,
      'network_type': instance.networkType,
      'client_name': instance.clientName,
      'test_bytes_download': instance.bytesDownload,
      'test_bytes_upload': instance.bytesUpload,
      'test_nsec_download': instance.nsecDownload,
      'test_nsec_upload': instance.nsecUpload,
      'test_total_bytes_download': instance.totalDownloadBytes,
      'test_total_bytes_upload': instance.totalUploadBytes,
      'test_speed_download': instance.speedDownload,
      'test_speed_upload': instance.speedUpload,
      'test_ping_shortest': instance.pingShortest,
      'test_ip_server': instance.serverIpAddress,
      'test_ip_local': instance.localIpAddress,
      'voip_result_packet_loss_percents': instance.packetLoss,
      'voip_result_jitter_millis': instance.jitter,
      'test_num_threads': instance.testNumThreads,
      'test_port_remote': instance.testPortRemote,
      'time': instance.time,
      'platform': instance.platform,
      'sim_mcc_mnc': instance.telephonyNetworkSimOperator,
      'sim_operator_name': instance.telephonyNetworkSimOperatorName,
      'sim_country': instance.telephonyNetworkSimCountry,
      'network_mcc_mnc': instance.telephonyNetworkOperator,
      'network_operator_name': instance.telephonyNetworkOperatorName,
      'network_country': instance.telephonyNetworkCountry,
      'network_is_roaming': instance.telephonyNetworkIsRoaming,
      'loopmode_info': instance.loopModeInfo,
    };
