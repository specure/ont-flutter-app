import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

part 'measurement-server.g.dart';

@JsonSerializable()
class MeasurementServer with EquatableMixin {
  final int id;
  final String uuid;
  final String? name;
  final String? webAddress;
  final String? city;
  final double? distance;
  final List<Map<String, dynamic>>? serverTypeDetails;

  String get nameWithCity =>
      (city != null && city!.isNotEmpty ? "$name ($city)" : name) ??
      'Unknown'.translated;

  String get formattedDistance {
    if (distance == null) {
      return "Distance unknown".translated;
    }
    final distanceInKm = distance! / 1000;
    final formatter = NumberFormat();
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 1;
    return formatter.format(distanceInKm) + " " + "km".translated;
  }

  MeasurementServer({
    required this.id,
    required this.uuid,
    this.name,
    this.webAddress,
    this.city,
    this.distance,
    this.serverTypeDetails,
  });

  factory MeasurementServer.fromJson(Map<String, dynamic> json) =>
      _$MeasurementServerFromJson(json);
  Map<String, dynamic> toJson() => _$MeasurementServerToJson(this);

  static List<MeasurementServer> fromJsonToList(dynamic data) {
    return (data as List)
        .map((e) => MeasurementServer.fromJson(e as Map<String, dynamic>))
        .where((e) =>
            e.serverTypeDetails
                ?.any((detail) => detail['serverType'] == 'RMBT') ??
            false)
        .toList()
      ..sort((a, b) => a.distance != null && b.distance != null
          ? a.distance!.compareTo(b.distance!)
          : 0);
  }

  @override
  List<Object?> get props => [id, uuid, name, webAddress, city, distance];
}
