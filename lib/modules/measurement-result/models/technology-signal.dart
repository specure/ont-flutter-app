import 'package:json_annotation/json_annotation.dart';

part 'technology-signal.g.dart';

@JsonSerializable()
class TechnologySignal {
  final int signal;
  final String technology;
  final int? timeNs;

  TechnologySignal({
    required this.signal,
    required this.technology,
    this.timeNs,
  });

  factory TechnologySignal.fromJson(Map<String, dynamic> json) =>
      _$TechnologySignalFromJson(json);
  Map<String, dynamic> toJson() => _$TechnologySignalToJson(this);
}
