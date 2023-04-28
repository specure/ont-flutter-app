// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speed-detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeedDetail _$SpeedDetailFromJson(Map<String, dynamic> json) => SpeedDetail(
      bytes: json['bytes'] as int,
      direction: json['direction'] as String,
      thread: json['thread'] as int,
      time: json['time'] as int,
    );

Map<String, dynamic> _$SpeedDetailToJson(SpeedDetail instance) =>
    <String, dynamic>{
      'bytes': instance.bytes,
      'direction': instance.direction,
      'thread': instance.thread,
      'time': instance.time,
    };
