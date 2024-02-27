import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

part 'measurement-server.g.dart';

@JsonSerializable()
class MeasurementServer with EquatableMixin {
  final int id;
  final String? uuid;
  final String? name;
  final String? webAddress;
  final String? city;
  final double? distance;
  final List<MeasurementServerTypeDetails>? serverTypeDetails;

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
    this.uuid,
    this.name,
    this.webAddress,
    this.city,
    this.distance,
    this.serverTypeDetails,
  });

  factory MeasurementServer.fromJson(Map<String, dynamic> json) =>
      _$MeasurementServerFromJson(json);
  Map<String, dynamic> toJson() =>
      _$MeasurementServerToJson(this).map((key, value) {
        if (value is List<MeasurementServerTypeDetails>) {
          return MapEntry(key, value.map((e) => e.toJson()).toList());
        }
        return MapEntry(key, value);
      });
  Map<String, dynamic> toTargetMeasurementServer({required String serverType}) {
    var map = toJson();
    final details = serverTypeDetails?.firstWhere(
      (element) => element.serverType == serverType,
      orElse: null,
    );
    if (details == null) {
      return map;
    }
    map["encrypted"] = details.encrypted;
    map["port"] = details.encrypted ? details.portSsl : details.port;
    map["serverType"] = details.serverType;
    return map;
  }

  static List<MeasurementServer> fromJsonToList(
      dynamic data, String serverType) {
    return (data as List)
        .map((e) => MeasurementServer.fromJson(e as Map<String, dynamic>))
        .where((e) =>
            e.serverTypeDetails?.any(
              (detail) => detail.serverType == serverType,
            ) ??
            false)
        .toList()
      ..sort((a, b) => a.distance != null && b.distance != null
          ? a.distance!.compareTo(b.distance!)
          : 0);
  }

  @override
  List<Object?> get props => [id, uuid, name, webAddress, city, distance];
}

@JsonSerializable()
class MeasurementServerTypeDetails with EquatableMixin {
  final String serverType;
  final int port;
  final int portSsl;
  final bool encrypted;

  MeasurementServerTypeDetails({
    this.serverType = 'RMBTws',
    this.port = 8080,
    this.portSsl = 443,
    this.encrypted = true,
  });

  factory MeasurementServerTypeDetails.fromJson(Map<String, dynamic> json) =>
      _$MeasurementServerTypeDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$MeasurementServerTypeDetailsToJson(this);

  @override
  List<Object?> get props => [serverType, port, portSsl, encrypted];
}
