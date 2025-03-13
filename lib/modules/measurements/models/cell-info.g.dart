// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell-info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CellInfoModel _$CellInfoModelFromJson(Map<String, dynamic> json) =>
    CellInfoModel(
      active: json['active'] as bool,
      registered: json['registered'] as bool,
      areaCode: (json['area_code'] as num?)?.toInt(),
      channelNumber: (json['channel_number'] as num?)?.toInt(),
      primaryDataSubscription: json['primary_data_subscription'] as bool?,
      locationId: (json['location_id'] as num?)?.toInt(),
      mcc: (json['mcc'] as num?)?.toInt(),
      mnc: (json['mnc'] as num?)?.toInt(),
      primaryScramblingCode: (json['primary_scrambling_code'] as num?)?.toInt(),
      technology: json['technology'] as String?,
      uuid: json['uuid'] as String?,
    );

Map<String, dynamic> _$CellInfoModelToJson(CellInfoModel instance) =>
    <String, dynamic>{
      'active': instance.active,
      'registered': instance.registered,
      'area_code': instance.areaCode,
      'channel_number': instance.channelNumber,
      'primary_data_subscription': instance.primaryDataSubscription,
      'location_id': instance.locationId,
      'mcc': instance.mcc,
      'mnc': instance.mnc,
      'primary_scrambling_code': instance.primaryScramblingCode,
      'technology': instance.technology,
      'uuid': instance.uuid,
    };
