// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net-neutrality-settings-response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetNeutralitySettingsResponse _$NetNeutralitySettingsResponseFromJson(
        Map<String, dynamic> json) =>
    NetNeutralitySettingsResponse(
      web: (json['WEB'] as List<dynamic>?)
          ?.map((e) =>
              WebNetNeutralitySettingsItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      dns: (json['DNS'] as List<dynamic>?)
          ?.map((e) =>
              DnsNetNeutralitySettingsItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NetNeutralitySettingsResponseToJson(
        NetNeutralitySettingsResponse instance) =>
    <String, dynamic>{
      'WEB': instance.web,
      'DNS': instance.dns,
    };
