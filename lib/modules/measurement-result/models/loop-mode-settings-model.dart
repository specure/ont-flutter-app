import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'loop-mode-settings-model.g.dart';

@JsonSerializable()
class LoopModeSettings with EquatableMixin {
  @JsonKey(name: 'max_delay')
  final int targetWaitingTimeSeconds;
  @JsonKey(name: 'max_movement')
  final int targetDistanceMeters;
  @JsonKey(name: 'max_tests')
  final int targetTestCount;
  @JsonKey(name: 'test_counter')
  final int currentTestNumber;
  @JsonKey(name: 'loop_uuid')
  final String? loopUuid;

  String get loopModeSettingsString {
    final loopUuidFromServer =
        loopUuid != null && loopUuid!.isNotEmpty ? '$loopUuid, ' : '';
    final loopSettings = '$loopUuidFromServer $currentTestNumber + $targetTestCount + $targetDistanceMeters + $targetWaitingTimeSeconds';
    return loopSettings.isEmpty ? '-' : loopSettings;
  }

  LoopModeSettings({
    required this.targetWaitingTimeSeconds,
    required this.targetDistanceMeters,
    required this.targetTestCount,
    required this.currentTestNumber,
    this.loopUuid,
  });

  factory LoopModeSettings.fromJson(Map<String, dynamic> json) =>
      _$LoopModeSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$LoopModeSettingsToJson(this);

  @override
  List<Object?> get props => [
    targetWaitingTimeSeconds,
    targetDistanceMeters,
    targetTestCount,
    currentTestNumber,
    loopUuid
  ];
}
