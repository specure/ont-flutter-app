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

  NetNeutralityHistoryMeasurement copyWith({
    Map<String, NetNeutralityHistoryCategory>? tests,
    String? openTestUuid,
    String? deviceName,
    String? networkType,
    String? measurementDate,
  }) {
    return NetNeutralityHistoryMeasurement(
      tests: tests ?? this.tests,
      openTestUuid: openTestUuid ?? this.openTestUuid,
      deviceName: deviceName ?? this.deviceName,
      networkType: networkType ?? this.networkType,
      measurementDate: measurementDate ?? this.measurementDate,
    );
  }
}
