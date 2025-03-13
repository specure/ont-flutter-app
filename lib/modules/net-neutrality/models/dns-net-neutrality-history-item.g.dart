// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns-net-neutrality-history-item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DnsNetNeutralityHistoryItem _$DnsNetNeutralityHistoryItemFromJson(
        Map<String, dynamic> json) =>
    DnsNetNeutralityHistoryItem(
      timeout: json['timeout'] as num,
      entryType: json['entryType'] as String?,
      actualDnsStatus: json['actualDnsStatus'] as String?,
      expectedDnsStatus: json['expectedDnsStatus'] as String?,
      expectedResolver: json['expectedResolver'] as String?,
      actualResolver: json['actualResolver'] as String?,
      target: json['target'] as String?,
      actualDnsResultEntriesFound:
          json['actualDnsResultEntriesFound'] as String?,
      expectedDnsResultEntriesFound:
          json['expectedDnsResultEntriesFound'] as String?,
      timeoutExceeded: json['timeoutExceeded'] as bool,
      failReason: json['failReason'] as String?,
      measurementDate: json['measurementDate'] as String,
      testStatus: json['testStatus'] as String,
      durationNs: (json['durationNs'] as num).toInt(),
      clientUuid: json['clientUuid'] as String,
      openTestUuid: json['openTestUuid'] as String,
      type: json['type'] as String,
      uuid: json['uuid'] as String,
      device: json['device'] as String?,
      networkType: json['networkType'] as String?,
      networkName: json['networkName'] as String?,
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      operator: json['operator'] as String?,
    );

Map<String, dynamic> _$DnsNetNeutralityHistoryItemToJson(
        DnsNetNeutralityHistoryItem instance) =>
    <String, dynamic>{
      'clientUuid': instance.clientUuid,
      'durationNs': instance.durationNs,
      'measurementDate': instance.measurementDate,
      'openTestUuid': instance.openTestUuid,
      'testStatus': instance.testStatus,
      'type': instance.type,
      'uuid': instance.uuid,
      'device': instance.device,
      'networkType': instance.networkType,
      'networkName': instance.networkName,
      'location': instance.location,
      'operator': instance.operator,
      'timeout': instance.timeout,
      'actualDnsStatus': instance.actualDnsStatus,
      'expectedDnsStatus': instance.expectedDnsStatus,
      'entryType': instance.entryType,
      'actualResolver': instance.actualResolver,
      'expectedResolver': instance.expectedResolver,
      'target': instance.target,
      'actualDnsResultEntriesFound': instance.actualDnsResultEntriesFound,
      'expectedDnsResultEntriesFound': instance.expectedDnsResultEntriesFound,
      'timeoutExceeded': instance.timeoutExceeded,
      'failReason': instance.failReason,
    };
