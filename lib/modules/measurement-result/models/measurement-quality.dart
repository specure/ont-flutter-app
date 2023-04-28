import 'package:json_annotation/json_annotation.dart';

part 'measurement-quality.g.dart';

@JsonSerializable()
class MeasurementQuality {
  final String category;
  final String quality;

  MeasurementQuality({
    required this.category,
    required this.quality,
  });

  factory MeasurementQuality.fromJson(Map<String, dynamic> json) =>
      _$MeasurementQualityFromJson(json);

  Map<String, dynamic> toJson() => _$MeasurementQualityToJson(this);
}
