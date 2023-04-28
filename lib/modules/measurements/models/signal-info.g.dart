// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signal-info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignalInfo _$SignalInfoFromJson(Map<String, dynamic> json) => SignalInfo(
      cellUuid: json['cell_uuid'] as String?,
      networkTypeId: json['network_type_id'] as int?,
      timeNsLast: json['time_ns_last'] as int?,
      timeNs: json['time_ns'] as int?,
      timingAdvance: json['timing_advance'] as int?,
      lteCqi: json['lte_cqi'] as int?,
      lteRsrp: (json['lte_rsrp'] as num?)?.toDouble(),
      lteRsrq: (json['lte_rsrq'] as num?)?.toDouble(),
      lteRssnr: (json['lte_rssnr'] as num?)?.toDouble(),
      signal: json['signal'] as int?,
      band: json['band'] as String?,
      technology: json['technology'] as String?,
      isPrimaryCell: json['isPrimaryCell'] as bool?,
    );

Map<String, dynamic> _$SignalInfoToJson(SignalInfo instance) =>
    <String, dynamic>{
      'cell_uuid': instance.cellUuid,
      'network_type_id': instance.networkTypeId,
      'time_ns_last': instance.timeNsLast,
      'time_ns': instance.timeNs,
      'timing_advance': instance.timingAdvance,
      'lte_cqi': instance.lteCqi,
      'lte_rsrp': instance.lteRsrp,
      'lte_rsrq': instance.lteRsrq,
      'lte_rssnr': instance.lteRssnr,
      'signal': instance.signal,
      'band': instance.band,
      'technology': instance.technology,
      'isPrimaryCell': instance.isPrimaryCell,
    };
