// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio-info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RadioInfo _$RadioInfoFromJson(Map<String, dynamic> json) => RadioInfo(
      cells: (json['cells'] as List<dynamic>)
          .map((e) => CellInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      signals: (json['signals'] as List<dynamic>)
          .map((e) => SignalInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RadioInfoToJson(RadioInfo instance) => <String, dynamic>{
      'cells': instance.cells,
      'signals': instance.signals,
    };
