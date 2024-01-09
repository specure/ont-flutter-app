// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web-net-neutrality-settings-item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebNetNeutralitySettingsItem _$WebNetNeutralitySettingsItemFromJson(
        Map<String, dynamic> json) =>
    WebNetNeutralitySettingsItem(
      expectedStatusCode: json['expectedStatusCode'] as int?,
      target: json['target'] as String,
      id: json['id'] as int,
      type: json['type'] as String,
      timeout: (json['timeout'] as num).toDouble(),
    );

Map<String, dynamic> _$WebNetNeutralitySettingsItemToJson(
        WebNetNeutralitySettingsItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'timeout': instance.timeout,
      'target': instance.target,
      'expectedStatusCode': instance.expectedStatusCode,
    };
