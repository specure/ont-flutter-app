import 'package:json_annotation/json_annotation.dart';

part 'ping.g.dart';

@JsonSerializable()
class Ping {
  @JsonKey(name: 'value')
  final int valueClient;
  @JsonKey(name: 'value_server')
  final int valueServer;
  @JsonKey(name: 'time_ns')
  final int timeNS;

  Ping({
    required this.valueClient,
    required this.valueServer,
    required this.timeNS,
  });

  factory Ping.fromJson(Map<String, dynamic> json) =>
      _$PingFromJson(json);
  Map<String, dynamic> toJson() => _$PingToJson(this);

  static List<Map<String, dynamic>> toJsonList(List<Ping>? list) =>
      list?.map((e) => e.toJson()).toList() ?? [];
}
