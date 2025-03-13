// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technology-signal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TechnologySignal _$TechnologySignalFromJson(Map<String, dynamic> json) =>
    TechnologySignal(
      signal: (json['signal'] as num).toInt(),
      technology: json['technology'] as String,
      timeNs: (json['timeNs'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TechnologySignalToJson(TechnologySignal instance) =>
    <String, dynamic>{
      'signal': instance.signal,
      'technology': instance.technology,
      'timeNs': instance.timeNs,
    };
