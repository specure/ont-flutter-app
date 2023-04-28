// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ping _$PingFromJson(Map<String, dynamic> json) => Ping(
      valueClient: json['value'] as int,
      valueServer: json['value_server'] as int,
      timeNS: json['time_ns'] as int,
    );

Map<String, dynamic> _$PingToJson(Ping instance) => <String, dynamic>{
      'value': instance.valueClient,
      'value_server': instance.valueServer,
      'time_ns': instance.timeNS,
    };
