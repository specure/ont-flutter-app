// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement-history-results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasurementHistoryResults _$MeasurementHistoryResultsFromJson(
        Map<String, dynamic> json) =>
    MeasurementHistoryResults(
      (json['tests'] as List<dynamic>)
          .map((e) =>
              MeasurementHistoryResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeasurementHistoryResultsToJson(
        MeasurementHistoryResults instance) =>
    <String, dynamic>{
      'tests': instance.tests,
    };
