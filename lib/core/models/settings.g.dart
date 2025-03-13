// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      apiLevel: (json['api_level'] as num?)?.toInt(),
      capabilities: json['capabilities'] as Map<String, dynamic>?,
      device: json['device'] as String?,
      language: json['language'] as String?,
      model: json['model'] as String?,
      name: json['name'] as String? ?? 'RMBT',
      osVersion: json['os_version'] as String?,
      platform: json['platform'] as String? ?? '',
      product: json['product'] as String?,
      softwareRevision: json['softwareRevision'] as String?,
      softwareRevisionCode: (json['softwareRevisionCode'] as num?)?.toInt(),
      softwareVersionName: json['softwareVersionName'] as String?,
      termsAndConditionsAccepted:
          json['terms_and_conditions_accepted'] as bool?,
      termsAndConditionsAcceptedVersion:
          (json['terms_and_conditions_accepted_version'] as num?)?.toInt(),
      timezone: json['timezone'] as String?,
      type: json['type'] as String? ?? 'MOBILE',
      userServerSelection: json['user_server_selection'] as bool?,
      uuid: json['uuid'] as String?,
      versionCode: (json['version_code'] as num?)?.toInt(),
      versionName: json['version_name'] as String?,
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'api_level': instance.apiLevel,
      'capabilities': instance.capabilities,
      'device': instance.device,
      'language': instance.language,
      'model': instance.model,
      'name': instance.name,
      'os_version': instance.osVersion,
      'platform': instance.platform,
      'product': instance.product,
      'softwareRevision': instance.softwareRevision,
      'softwareRevisionCode': instance.softwareRevisionCode,
      'softwareVersionName': instance.softwareVersionName,
      'terms_and_conditions_accepted': instance.termsAndConditionsAccepted,
      'terms_and_conditions_accepted_version':
          instance.termsAndConditionsAcceptedVersion,
      'timezone': instance.timezone,
      'type': instance.type,
      'user_server_selection': instance.userServerSelection,
      'uuid': instance.uuid,
      'version_code': instance.versionCode,
      'version_name': instance.versionName,
    };
