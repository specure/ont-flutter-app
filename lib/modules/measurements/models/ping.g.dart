// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ping _$PingFromJson(Map<String, dynamic> json) => Ping(
      valueClient: (json['value'] as num).toInt(),
      valueServer: (json['value_server'] as num).toInt(),
      timeNS: (json['time_ns'] as num).toInt(),
    );

Map<String, dynamic> _$PingToJson(Ping instance) => <String, dynamic>{
      'value': instance.valueClient,
      'value_server': instance.valueServer,
      'time_ns': instance.timeNS,
    };
