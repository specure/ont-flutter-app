// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-result-item.dart';

part 'net-neutrality-result.g.dart';

@JsonSerializable()
class NetNeutralityResult with EquatableMixin {
  @JsonKey(name: 'model')
  String? model;
  @JsonKey(name: 'device')
  String? device;
  @JsonKey(name: 'product')
  String? product;
  @JsonKey(name: 'clientVersion')
  String? clientVersion;
  @JsonKey(name: 'clientLanguage')
  String? clientLanguage;
  @JsonKey(name: 'dualSim')
  bool? dualSim;
  @JsonKey(name: 'networkType')
  int networkType = serverNetworkTypes[unknown]!;
  @JsonKey(name: 'testIpLocal')
  String? localIpAddress;
  @JsonKey(name: 'platform')
  String? platform;
  @JsonKey(name: 'simMccMnc')
  String? telephonyNetworkSimOperator;
  @JsonKey(name: 'simOperatorName')
  String? telephonyNetworkSimOperatorName;
  @JsonKey(name: 'simCountry')
  String? telephonyNetworkSimCountry;
  @JsonKey(name: 'networkMccMnc')
  String? telephonyNetworkOperator;
  @JsonKey(name: 'networkOperatorName')
  String? telephonyNetworkOperatorName;
  @JsonKey(name: 'networkCountry')
  String? telephonyNetworkCountry;
  @JsonKey(name: 'networkIsRoaming')
  bool? telephonyNetworkIsRoaming;
  @JsonKey(name: 'signalStrength')
  int? signalStrength;
  @JsonKey(name: 'networkChannelNumber')
  String? networkBand;
  LocationModel? location;
  @JsonKey(toJson: NetNeutralityResultItem.toJsonList)
  List<NetNeutralityResultItem>? testResults;

  NetNeutralityResult();

  factory NetNeutralityResult.fromJson(Map<String, dynamic> json) =>
      _$NetNeutralityResultFromJson(json);

  Map<String, dynamic> toJson() => _$NetNeutralityResultToJson(this);

  @override
  List<Object?> get props => [
        model,
        device,
        product,
        clientVersion,
        clientLanguage,
        dualSim,
        networkType,
        localIpAddress,
        platform,
        telephonyNetworkSimOperator,
        telephonyNetworkSimOperatorName,
        telephonyNetworkSimCountry,
        telephonyNetworkOperator,
        telephonyNetworkOperatorName,
        telephonyNetworkCountry,
        telephonyNetworkIsRoaming,
        signalStrength,
        networkBand,
        location,
        testResults,
      ];
}
