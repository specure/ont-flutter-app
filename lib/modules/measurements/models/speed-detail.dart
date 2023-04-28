import 'package:json_annotation/json_annotation.dart';

part 'speed-detail.g.dart';

@JsonSerializable()
class SpeedDetail {
  final int bytes;
  final String direction;
  final int thread;
  final int time;

  SpeedDetail({
    required this.bytes,
    required this.direction,
    required this.thread,
    required this.time,
  });

  factory SpeedDetail.fromJson(Map<String, dynamic> json) =>
      _$SpeedDetailFromJson(json);
  Map<String, dynamic> toJson() => _$SpeedDetailToJson(this);

  static List<Map<String, dynamic>> toJsonList(List<SpeedDetail>? list) =>
      list?.map((e) => e.toJson()).toList() ?? [];
}
