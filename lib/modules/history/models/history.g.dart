// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) => History(
      content: (json['content'] as List<dynamic>)
          .map((e) =>
              MeasurementHistoryResults.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      last: json['last'] as bool,
    );

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'content': instance.content,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last,
    };
