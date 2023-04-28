import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dns-result.g.dart';

@JsonSerializable()
class DnsResult with EquatableMixin {
  String? givenResolver;
  String? record;
  String? host;
  int? timeoutSeconds;
  String? resultQueryStatus;
  int? resultStatus;
  int? resultDurationNanos;
  String? resultResolver;
  String? rawResponse;
  List<DnsRecord>? dnsRecords;

  DnsResult({
    this.givenResolver,
    this.record,
    this.host,
    this.timeoutSeconds,
    this.resultQueryStatus,
    this.resultStatus,
    this.resultDurationNanos,
    this.resultResolver,
    this.rawResponse,
    this.dnsRecords,
  });

  factory DnsResult.fromJson(Map<String, dynamic> json) =>
      _$DnsResultFromJson(json);

  Map<String, dynamic> toJson() => _$DnsResultToJson(this);

  @override
  List<Object?> get props => [
        this.givenResolver,
        this.record,
        this.host,
        this.timeoutSeconds,
        this.resultQueryStatus,
        this.resultStatus,
        this.resultDurationNanos,
        this.resultResolver,
        this.rawResponse,
        this.dnsRecords,
      ];
}

@JsonSerializable()
class DnsRecord with EquatableMixin {
  String? resultAddress;
  String? resultPriority;
  String? resultTtl;

  DnsRecord({
    this.resultAddress,
    this.resultPriority,
    this.resultTtl,
  });

  factory DnsRecord.fromJson(Map<String, dynamic> json) =>
      _$DnsRecordFromJson(json);

  Map<String, dynamic> toJson() => _$DnsRecordToJson(this);

  @override
  List<Object?> get props => [
        this.resultAddress,
        this.resultPriority,
        this.resultTtl,
      ];
}
