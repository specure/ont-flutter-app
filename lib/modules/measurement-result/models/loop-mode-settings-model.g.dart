// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop-mode-settings-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoopModeSettings _$LoopModeSettingsFromJson(Map<String, dynamic> json) =>
    LoopModeSettings(
      targetWaitingTimeSeconds: (json['max_delay'] as num).toInt(),
      targetDistanceMeters: (json['max_movement'] as num).toInt(),
      targetTestCount: (json['max_tests'] as num).toInt(),
      currentTestNumber: (json['test_counter'] as num).toInt(),
      loopUuid: json['loop_uuid'] as String?,
    );

Map<String, dynamic> _$LoopModeSettingsToJson(LoopModeSettings instance) =>
    <String, dynamic>{
      'max_delay': instance.targetWaitingTimeSeconds,
      'max_movement': instance.targetDistanceMeters,
      'max_tests': instance.targetTestCount,
      'test_counter': instance.currentTestNumber,
      'loop_uuid': instance.loopUuid,
    };
