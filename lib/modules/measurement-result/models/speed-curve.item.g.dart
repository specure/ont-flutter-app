// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speed-curve.item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeedCurveItem _$SpeedCurveItemFromJson(Map<String, dynamic> json) =>
    SpeedCurveItem(
      bytes: json['bytes_total'] as int,
      time: json['time_elapsed'] as int,
    );

Map<String, dynamic> _$SpeedCurveItemToJson(SpeedCurveItem instance) =>
    <String, dynamic>{
      'bytes_total': instance.bytes,
      'time_elapsed': instance.time,
    };
