// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns-net-neutrality-settings-item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DnsNetNeutralitySettingsItem _$DnsNetNeutralitySettingsItemFromJson(
        Map<String, dynamic> json) =>
    DnsNetNeutralitySettingsItem(
      resolver: json['resolver'] as String?,
      expectedDnsEntries: json['expectedDnsEntries'] as String?,
      target: json['target'] as String,
      entryType: json['entryType'] as String,
      expectedDnsStatus: json['expectedDnsStatus'] as String,
      id: json['id'] as int,
      type: json['type'] as String,
      timeout: json['timeout'] as num,
    );

Map<String, dynamic> _$DnsNetNeutralitySettingsItemToJson(
        DnsNetNeutralitySettingsItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'timeout': instance.timeout,
      'resolver': instance.resolver,
      'entryType': instance.entryType,
      'target': instance.target,
      'expectedDnsStatus': instance.expectedDnsStatus,
      'expectedDnsEntries': instance.expectedDnsEntries,
    };
