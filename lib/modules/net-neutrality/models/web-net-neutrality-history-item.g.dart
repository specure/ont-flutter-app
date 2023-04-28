// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web-net-neutrality-history-item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebNetNeutralityHistoryItem _$WebNetNeutralityHistoryItemFromJson(
        Map<String, dynamic> json) =>
    WebNetNeutralityHistoryItem(
      url: json['url'] as String,
      timeout: json['timeout'] as num,
      actualStatusCode: json['actualStatusCode'] as int?,
      expectedStatusCode: json['expectedStatusCode'] as int,
      timeoutExceeded: json['timeoutExceeded'] as bool,
      clientUuid: json['clientUuid'] as String,
      durationNs: json['durationNs'] as int,
      measurementDate: json['measurementDate'] as String,
      openTestUuid: json['openTestUuid'] as String,
      testStatus: json['testStatus'] as String,
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

Map<String, dynamic> _$WebNetNeutralityHistoryItemToJson(
        WebNetNeutralityHistoryItem instance) =>
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
      'url': instance.url,
      'timeout': instance.timeout,
      'actualStatusCode': instance.actualStatusCode,
      'expectedStatusCode': instance.expectedStatusCode,
      'timeoutExceeded': instance.timeoutExceeded,
    };
