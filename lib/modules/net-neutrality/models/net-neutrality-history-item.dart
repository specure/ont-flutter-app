import 'package:equatable/equatable.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';

import '../../measurements/models/server-network-types.dart';

abstract class NetNeutralityHistoryItem with EquatableMixin {
  final String clientUuid;
  final int durationNs;
  final String measurementDate;
  final String openTestUuid;
  final String testStatus;
  final String type;
  final String uuid;
  final String? device;
  final String? networkType;
  final String? networkName;
  final LocationModel? location;
  final String? operator;

  NetNeutralityHistoryItem({
    required this.clientUuid,
    required this.durationNs,
    required this.measurementDate,
    required this.openTestUuid,
    required this.testStatus,
    required this.type,
    required this.uuid,
    required this.device,
    required this.networkType,
    required this.networkName,
    required this.location,
    required this.operator,
  });

  String resolveNetworkInfo() {
    var networkInfo = "";
    if (networkType != null) {
      networkInfo += "$networkType";
      if (networkName != null &&
          networkName?.toLowerCase() != "wlan" &&
          networkName?.toLowerCase() != "unknown" &&
          networkName?.toLowerCase() != "mobile" &&
          networkName?.toLowerCase() != "cellular_any" &&
          (networkInfo != nrSignallingOnly &&
              networkInfo != nrSignallingOnlyAlt)) {
        networkInfo += " ($networkName)";
      }
      return networkInfo;
    } else {
      return '-';
    }
  }
}
