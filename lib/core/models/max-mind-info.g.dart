// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'max-mind-info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaxMindInfo _$MaxMindInfoFromJson(Map<String, dynamic> json) => MaxMindInfo(
      traits:
          MaxMindInfoTraits.fromJson(json['traits'] as Map<String, dynamic>),
      registeredCountry: MaxMindInfoRegisteredCountry.fromJson(
          json['registered_country'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MaxMindInfoToJson(MaxMindInfo instance) =>
    <String, dynamic>{
      'traits': instance.traits,
      'registered_country': instance.registeredCountry,
    };

MaxMindInfoTraits _$MaxMindInfoTraitsFromJson(Map<String, dynamic> json) =>
    MaxMindInfoTraits(
      isp: json['isp'] as String?,
      mobileCountryCode: json['mobile_country_code'] as String?,
      mobileNetworkCode: json['mobile_network_code'] as String?,
      organization: json['organization'] as String?,
    );

Map<String, dynamic> _$MaxMindInfoTraitsToJson(MaxMindInfoTraits instance) =>
    <String, dynamic>{
      'isp': instance.isp,
      'mobile_country_code': instance.mobileCountryCode,
      'mobile_network_code': instance.mobileNetworkCode,
      'organization': instance.organization,
    };

MaxMindInfoRegisteredCountry _$MaxMindInfoRegisteredCountryFromJson(
        Map<String, dynamic> json) =>
    MaxMindInfoRegisteredCountry(
      iso: json['iso_code'] as String?,
    );

Map<String, dynamic> _$MaxMindInfoRegisteredCountryToJson(
        MaxMindInfoRegisteredCountry instance) =>
    <String, dynamic>{
      'iso_code': instance.iso,
    };
