// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web-net-neutrality-result-item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebNetNeutralityResultItem _$WebNetNeutralityResultItemFromJson(
        Map<String, dynamic> json) =>
    WebNetNeutralityResultItem(
      id: (json['id'] as num).toInt(),
      openTestUuid: json['openTestUuid'] as String,
      durationNs: (json['durationNs'] as num).toInt(),
      timeoutExceeded: json['timeoutExceeded'] as bool,
      type: json['type'] as String,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      clientUuid: json['clientUuid'] as String?,
    );

Map<String, dynamic> _$WebNetNeutralityResultItemToJson(
        WebNetNeutralityResultItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'openTestUuid': instance.openTestUuid,
      'clientUuid': instance.clientUuid,
      'durationNs': instance.durationNs,
      'timeoutExceeded': instance.timeoutExceeded,
      'type': instance.type,
      'statusCode': instance.statusCode,
    };
