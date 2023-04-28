import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/signal-info.dart';

const addressIsNotAvailable = 'Address is not available';

class NetworkInfoDetails with EquatableMixin {
  static const Color red = Color(0xFFE02020);
  static const Color yellow = Color(0xFFFFCC00);
  static const Color green = Color(0xFF6DD400);

  final String type;
  final String mobileNetworkGeneration;
  final String name;
  final String ipV4PrivateAddress;
  final String ipV4PublicAddress;
  final String ipV6PrivateAddress;
  final String ipV6PublicAddress;
  final bool isDualSim;
  final List<SignalInfo> currentAllSignalInfo;

  String? telephonyNetworkSimOperator;
  String? telephonyNetworkSimOperatorName;
  String? telephonyNetworkSimCountry;
  String? telephonyNetworkOperator;
  String? telephonyNetworkOperatorName;
  String? telephonyNetworkCountry;
  bool? telephonyNetworkIsRoaming;

  Color get ipV4StatusColor =>
      _getStatusColor(ipV4PrivateAddress, ipV4PublicAddress);
  Color get ipV6StatusColor =>
      _getStatusColor(ipV6PrivateAddress, ipV6PublicAddress);

  resolveNetworkName({bool shorten = false}) {
    var displayType;
    if (type == nrNsa) {
      displayType = nrNsaDisplay;
    } else if (type == wifi) {
      displayType = wifiDisplay;
    } else {
      displayType = type;
    }

    var displayNetwork;
    if (mobileNetworkGeneration == unknown) {
      if (type == wifi) {
        displayNetwork = wifiDisplay;
      } else {
        displayNetwork = type;
      }
    } else if (mobileNetworkGeneration == nrSignallingOnly && shorten) {
      displayNetwork = mobileNetworkGeneration;
    } else {
      displayNetwork = '$mobileNetworkGeneration ($displayType)';
    }
    return displayNetwork;
  }

  NetworkInfoDetails({
    this.type = unknown,
    this.mobileNetworkGeneration = unknown,
    this.isDualSim = false,
    this.name = unknown,
    this.ipV4PrivateAddress = addressIsNotAvailable,
    this.ipV4PublicAddress = addressIsNotAvailable,
    this.ipV6PrivateAddress = addressIsNotAvailable,
    this.ipV6PublicAddress = addressIsNotAvailable,
    this.currentAllSignalInfo = const [],
    this.telephonyNetworkSimOperator,
    this.telephonyNetworkSimOperatorName,
    this.telephonyNetworkIsRoaming,
    this.telephonyNetworkOperator,
    this.telephonyNetworkOperatorName,
    this.telephonyNetworkCountry,
    this.telephonyNetworkSimCountry,
  });

  NetworkInfoDetails copyWith({
    String? type,
    String? mobileNetworkGeneration,
    String? name,
    String? ipV4PrivateAddress,
    String? ipV4PublicAddress,
    String? ipV6PrivateAddress,
    String? ipV6PublicAddress,
    bool? isDualSim,
    List<SignalInfo>? measurementSignalInfo,
    List<SignalInfo>? currentAllSignalInfo,
    String? telephonyNetworkSimOperator,
    String? telephonyNetworkSimOperatorName,
    String? telephonyNetworkSimCountry,
    String? telephonyNetworkOperator,
    String? telephonyNetworkOperatorName,
    String? telephonyNetworkCountry,
    bool? telephonyNetworkIsRoaming,
  }) {
    return NetworkInfoDetails(
      type: type ?? this.type,
      mobileNetworkGeneration:
          mobileNetworkGeneration ?? this.mobileNetworkGeneration,
      name: name ?? this.name,
      ipV4PrivateAddress: ipV4PrivateAddress ?? this.ipV4PrivateAddress,
      ipV4PublicAddress: ipV4PublicAddress ?? this.ipV4PublicAddress,
      ipV6PrivateAddress: ipV6PrivateAddress ?? this.ipV6PrivateAddress,
      ipV6PublicAddress: ipV6PublicAddress ?? this.ipV6PublicAddress,
      currentAllSignalInfo: currentAllSignalInfo ?? this.currentAllSignalInfo,
      isDualSim: isDualSim ?? this.isDualSim,
      telephonyNetworkSimOperator:
          telephonyNetworkSimOperator ?? this.telephonyNetworkSimOperator,
      telephonyNetworkSimOperatorName: telephonyNetworkSimOperatorName ??
          this.telephonyNetworkSimOperatorName,
      telephonyNetworkSimCountry:
          telephonyNetworkSimCountry ?? this.telephonyNetworkSimCountry,
      telephonyNetworkOperator:
          telephonyNetworkOperator ?? this.telephonyNetworkOperator,
      telephonyNetworkOperatorName:
          telephonyNetworkOperatorName ?? this.telephonyNetworkOperatorName,
      telephonyNetworkCountry:
          telephonyNetworkCountry ?? this.telephonyNetworkCountry,
      telephonyNetworkIsRoaming:
          telephonyNetworkIsRoaming ?? this.telephonyNetworkIsRoaming,
    );
  }

  @override
  List<Object?> get props => [
        type,
        name,
        mobileNetworkGeneration,
        ipV4PrivateAddress,
        ipV4PublicAddress,
        ipV6PrivateAddress,
        ipV6PublicAddress,
        currentAllSignalInfo,
        isDualSim,
        telephonyNetworkSimOperator,
        telephonyNetworkSimOperatorName,
        telephonyNetworkSimCountry,
        telephonyNetworkOperator,
        telephonyNetworkOperatorName,
        telephonyNetworkCountry,
        telephonyNetworkIsRoaming,
      ];

  Map<String, dynamic> toJson() => {name: name, type: type};

  Color _getStatusColor(publicIp, privateIp) {
    if (publicIp != addressIsNotAvailable &&
        privateIp != addressIsNotAvailable &&
        publicIp != privateIp) {
      return NetworkInfoDetails.yellow;
    }
    if (publicIp != addressIsNotAvailable && publicIp == privateIp) {
      return NetworkInfoDetails.green;
    }
    return NetworkInfoDetails.red;
  }
}
