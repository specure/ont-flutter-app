// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
      name: json['name'] as String,
      nativeName: json['nativeName'] as String,
      languageCode: json['languageCode'] as String,
      countryCode: json['countryCode'] as String,
      scriptCode: json['scriptCode'] as String?,
    );

Map<String, dynamic> _$LanguageToJson(Language instance) => <String, dynamic>{
      'name': instance.name,
      'nativeName': instance.nativeName,
      'languageCode': instance.languageCode,
      'scriptCode': instance.scriptCode,
      'countryCode': instance.countryCode,
    };
