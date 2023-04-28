import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'speed-curve.item.g.dart';

@JsonSerializable()
class SpeedCurveItem with EquatableMixin {
  @JsonKey(name: 'bytes_total')
  final int bytes;
  @JsonKey(name: 'time_elapsed')
  final int time;

  SpeedCurveItem({
    required this.bytes,
    required this.time,
  });

  factory SpeedCurveItem.fromJson(Map<String, dynamic> json) =>
      _$SpeedCurveItemFromJson(json);
  Map<String, dynamic> toJson() => _$SpeedCurveItemToJson(this);

  static List<SpeedCurveItem> fromJsonToList(dynamic data) {
    return (data as List)
        .map((e) => SpeedCurveItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Object?> get props => [bytes, time];
}