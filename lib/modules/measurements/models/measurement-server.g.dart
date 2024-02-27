// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement-server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasurementServer _$MeasurementServerFromJson(Map<String, dynamic> json) =>
    MeasurementServer(
      id: json['id'] as int,
      uuid: json['uuid'] as String?,
      name: json['name'] as String?,
      webAddress: json['webAddress'] as String?,
      city: json['city'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      serverTypeDetails: (json['serverTypeDetails'] as List<dynamic>?)
          ?.map((e) =>
              MeasurementServerTypeDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeasurementServerToJson(MeasurementServer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'name': instance.name,
      'webAddress': instance.webAddress,
      'city': instance.city,
      'distance': instance.distance,
      'serverTypeDetails': instance.serverTypeDetails,
    };

MeasurementServerTypeDetails _$MeasurementServerTypeDetailsFromJson(
        Map<String, dynamic> json) =>
    MeasurementServerTypeDetails(
      serverType: json['serverType'] as String? ?? 'RMBTws',
      port: json['port'] as int? ?? 8080,
      portSsl: json['portSsl'] as int? ?? 443,
      encrypted: json['encrypted'] as bool? ?? true,
    );

Map<String, dynamic> _$MeasurementServerTypeDetailsToJson(
        MeasurementServerTypeDetails instance) =>
    <String, dynamic>{
      'serverType': instance.serverType,
      'port': instance.port,
      'portSsl': instance.portSsl,
      'encrypted': instance.encrypted,
    };
