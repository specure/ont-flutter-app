// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      label: json['label'] as String?,
      countryCode: json['countryCode'] as String?,
      countryName: json['countryName'] as String?,
      state: json['state'] as String?,
      county: json['county'] as String?,
      city: json['city'] as String?,
      street: json['street'] as String?,
      postalCode: json['postalCode'] as String?,
      houseNumber: json['houseNumber'] as String?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'label': instance.label,
      'countryCode': instance.countryCode,
      'countryName': instance.countryName,
      'state': instance.state,
      'county': instance.county,
      'city': instance.city,
      'street': instance.street,
      'postalCode': instance.postalCode,
      'houseNumber': instance.houseNumber,
    };
