// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      latitude: (json['lat'] as num?)?.toDouble(),
      longitude: (json['long'] as num?)?.toDouble(),
      city: json['city'] as String?,
      country: json['country'] as String?,
      county: json['county'] as String?,
      postalCode: json['postalCode'] as String?,
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'lat': instance.latitude,
      'long': instance.longitude,
      'city': instance.city,
      'country': instance.country,
      'county': instance.county,
      'postalCode': instance.postalCode,
    };
