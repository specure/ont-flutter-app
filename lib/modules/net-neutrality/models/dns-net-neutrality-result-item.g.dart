// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns-net-neutrality-result-item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DnsNetNeutralityResultItem _$DnsNetNeutralityResultItemFromJson(
        Map<String, dynamic> json) =>
    DnsNetNeutralityResultItem(
      id: (json['id'] as num).toInt(),
      openTestUuid: json['openTestUuid'] as String,
      durationNs: (json['durationNs'] as num).toInt(),
      timeoutExceeded: json['timeoutExceeded'] as bool,
      type: json['type'] as String,
      dnsStatus: json['dnsStatus'] as String,
      resolver: json['resolver'] as String,
      dnsEntries: (json['dnsEntries'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      clientUuid: json['clientUuid'] as String?,
    );

Map<String, dynamic> _$DnsNetNeutralityResultItemToJson(
        DnsNetNeutralityResultItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'openTestUuid': instance.openTestUuid,
      'clientUuid': instance.clientUuid,
      'durationNs': instance.durationNs,
      'timeoutExceeded': instance.timeoutExceeded,
      'type': instance.type,
      'dnsStatus': instance.dnsStatus,
      'resolver': instance.resolver,
      'dnsEntries': instance.dnsEntries,
    };
