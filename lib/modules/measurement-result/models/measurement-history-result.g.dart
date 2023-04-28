// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement-history-result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasurementHistoryResult _$MeasurementHistoryResultFromJson(
        Map<String, dynamic> json) =>
    MeasurementHistoryResult(
      testUuid: json['test_uuid'] as String,
      uploadKbps: (json['speed_upload'] as num).toDouble(),
      downloadKbps: (json['speed_download'] as num).toDouble(),
      pingMs: (json['ping'] as num).toDouble(),
      measurementDate: json['measurement_date'] as String,
      networkType: json['network_type'] as String?,
      networkName: json['networkName'] as String?,
      device: json['device'] as String?,
      loopModeUuid: json['loop_mode_uuid'] as String?,
      userExperienceMetrics: (json['userExperienceMetrics'] as List<dynamic>?)
              ?.map(
                  (e) => MeasurementQuality.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      jitterMs: (json['voip_result_jitter_millis'] as num?)?.toDouble(),
      packetLossPercents:
          (json['voip_result_packet_loss_percents'] as num?)?.toDouble(),
      radioSignals: (json['radioSignals'] as List<dynamic>?)
          ?.map((e) => TechnologySignal.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      measurementServerName: json['measurementServerName'] as String?,
      measurementServerCity: json['measurementServerCity'] as String?,
      operator: json['operator'] as String?,
    );

Map<String, dynamic> _$MeasurementHistoryResultToJson(
        MeasurementHistoryResult instance) =>
    <String, dynamic>{
      'test_uuid': instance.testUuid,
      'speed_upload': instance.uploadKbps,
      'speed_download': instance.downloadKbps,
      'ping': instance.pingMs,
      'network_type': instance.networkType,
      'networkName': instance.networkName,
      'measurement_date': instance.measurementDate,
      'device': instance.device,
      'loop_mode_uuid': instance.loopModeUuid,
      'userExperienceMetrics': instance.userExperienceMetrics,
      'voip_result_jitter_millis': instance.jitterMs,
      'voip_result_packet_loss_percents': instance.packetLossPercents,
      'radioSignals': instance.radioSignals,
      'location': instance.location,
      'measurementServerName': instance.measurementServerName,
      'measurementServerCity': instance.measurementServerCity,
      'operator': instance.operator,
    };
