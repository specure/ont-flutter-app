// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speed-detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeedDetail _$SpeedDetailFromJson(Map<String, dynamic> json) => SpeedDetail(
      bytes: (json['bytes'] as num).toInt(),
      direction: json['direction'] as String,
      thread: (json['thread'] as num).toInt(),
      time: (json['time'] as num).toInt(),
    );

Map<String, dynamic> _$SpeedDetailToJson(SpeedDetail instance) =>
    <String, dynamic>{
      'bytes': instance.bytes,
      'direction': instance.direction,
      'thread': instance.thread,
      'time': instance.time,
    };
