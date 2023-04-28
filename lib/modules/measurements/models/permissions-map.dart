import 'dart:io';

import 'package:equatable/equatable.dart';

class PermissionsMap extends Equatable {
  final bool locationPermissionsGranted;
  final bool preciseLocationPermissionsGranted;
  final bool readPhoneStatePermissionsGranted;

  bool get phoneStatePermissionsGranted =>
      Platform.isIOS || readPhoneStatePermissionsGranted;

  PermissionsMap({
    this.locationPermissionsGranted = false,
    this.preciseLocationPermissionsGranted = false,
    this.readPhoneStatePermissionsGranted = false,
  });

  PermissionsMap.fromJson(Map<String, dynamic> json)
      : locationPermissionsGranted =
            json['locationPermissionsGranted'].toString().toLowerCase() ==
                "true",
        preciseLocationPermissionsGranted =
            json['preciseLocationPermissionsGranted'].toString().toLowerCase() ==
                "true",
        readPhoneStatePermissionsGranted =
            json['readPhoneStatePermissionsGranted'].toString().toLowerCase() ==
                "true";

  @override
  List<Object?> get props =>
      [locationPermissionsGranted, preciseLocationPermissionsGranted, readPhoneStatePermissionsGranted];

  Map<String, dynamic> toJson() => {
        "locationPermissionsGranted": locationPermissionsGranted,
        "preciseLocationPermissionsGranted": preciseLocationPermissionsGranted,
        "readPhoneStatePermissionsGranted": readPhoneStatePermissionsGranted
      };
}
