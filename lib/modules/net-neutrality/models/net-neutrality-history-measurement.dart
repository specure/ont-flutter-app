import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-category.dart';

class NetNeutralityHistoryMeasurement {
  final Map<String, NetNeutralityHistoryCategory> tests;
  final String openTestUuid;
  final String deviceName;
  final String networkType;
  final String measurementDate;


  NetNeutralityHistoryMeasurement({
    required this.tests,
    required this.openTestUuid,
    this.deviceName = "",
    this.networkType = "",
    this.measurementDate = "",
  });
}
