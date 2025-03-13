// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net-neutrality-result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetNeutralityResult _$NetNeutralityResultFromJson(Map<String, dynamic> json) =>
    NetNeutralityResult()
      ..model = json['model'] as String?
      ..device = json['device'] as String?
      ..product = json['product'] as String?
      ..clientVersion = json['clientVersion'] as String?
      ..clientLanguage = json['clientLanguage'] as String?
      ..dualSim = json['dualSim'] as bool?
      ..networkType = (json['networkType'] as num).toInt()
      ..localIpAddress = json['testIpLocal'] as String?
      ..platform = json['platform'] as String?
      ..telephonyNetworkSimOperator = json['simMccMnc'] as String?
      ..telephonyNetworkSimOperatorName = json['simOperatorName'] as String?
      ..telephonyNetworkSimCountry = json['simCountry'] as String?
      ..telephonyNetworkOperator = json['networkMccMnc'] as String?
      ..telephonyNetworkOperatorName = json['networkOperatorName'] as String?
      ..telephonyNetworkCountry = json['networkCountry'] as String?
      ..telephonyNetworkIsRoaming = json['networkIsRoaming'] as bool?
      ..signalStrength = (json['signalStrength'] as num?)?.toInt()
      ..networkBand = json['networkChannelNumber'] as String?
      ..location = json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>)
      ..testResults = (json['testResults'] as List<dynamic>?)
          ?.map((e) =>
              NetNeutralityResultItem.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$NetNeutralityResultToJson(
        NetNeutralityResult instance) =>
    <String, dynamic>{
      'model': instance.model,
      'device': instance.device,
      'product': instance.product,
      'clientVersion': instance.clientVersion,
      'clientLanguage': instance.clientLanguage,
      'dualSim': instance.dualSim,
      'networkType': instance.networkType,
      'testIpLocal': instance.localIpAddress,
      'platform': instance.platform,
      'simMccMnc': instance.telephonyNetworkSimOperator,
      'simOperatorName': instance.telephonyNetworkSimOperatorName,
      'simCountry': instance.telephonyNetworkSimCountry,
      'networkMccMnc': instance.telephonyNetworkOperator,
      'networkOperatorName': instance.telephonyNetworkOperatorName,
      'networkCountry': instance.telephonyNetworkCountry,
      'networkIsRoaming': instance.telephonyNetworkIsRoaming,
      'signalStrength': instance.signalStrength,
      'networkChannelNumber': instance.networkBand,
      'location': instance.location,
      'testResults': NetNeutralityResultItem.toJsonList(instance.testResults),
    };
