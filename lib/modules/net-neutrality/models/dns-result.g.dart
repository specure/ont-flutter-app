// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns-result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DnsResult _$DnsResultFromJson(Map<String, dynamic> json) => DnsResult(
      givenResolver: json['givenResolver'] as String?,
      record: json['record'] as String?,
      host: json['host'] as String?,
      timeoutSeconds: (json['timeoutSeconds'] as num?)?.toInt(),
      resultQueryStatus: json['resultQueryStatus'] as String?,
      resultStatus: (json['resultStatus'] as num?)?.toInt(),
      resultDurationNanos: (json['resultDurationNanos'] as num?)?.toInt(),
      resultResolver: json['resultResolver'] as String?,
      rawResponse: json['rawResponse'] as String?,
      dnsRecords: (json['dnsRecords'] as List<dynamic>?)
          ?.map((e) => DnsRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DnsResultToJson(DnsResult instance) => <String, dynamic>{
      'givenResolver': instance.givenResolver,
      'record': instance.record,
      'host': instance.host,
      'timeoutSeconds': instance.timeoutSeconds,
      'resultQueryStatus': instance.resultQueryStatus,
      'resultStatus': instance.resultStatus,
      'resultDurationNanos': instance.resultDurationNanos,
      'resultResolver': instance.resultResolver,
      'rawResponse': instance.rawResponse,
      'dnsRecords': instance.dnsRecords,
    };

DnsRecord _$DnsRecordFromJson(Map<String, dynamic> json) => DnsRecord(
      resultAddress: json['resultAddress'] as String?,
      resultPriority: json['resultPriority'] as String?,
      resultTtl: json['resultTtl'] as String?,
    );

Map<String, dynamic> _$DnsRecordToJson(DnsRecord instance) => <String, dynamic>{
      'resultAddress': instance.resultAddress,
      'resultPriority': instance.resultPriority,
      'resultTtl': instance.resultTtl,
    };
