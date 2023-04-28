import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-item.dart';

class NetNeutralityHistoryCategory {
  final String name;
  final String deviceName;
  final String networkType;
  final String measurementDate;
  final int totalResults;
  final int successfulResults;
  final int failedResults;
  final List<NetNeutralityHistoryItem> items;
  final String type;

  String get successfulOfTotal => '$successfulResults / $totalResults';

  NetNeutralityHistoryCategory(
    this.name, {
    required this.type,
    required this.totalResults,
    required this.successfulResults,
    required this.failedResults,
    required this.items,
    this.deviceName = "",
    this.networkType = "",
    this.measurementDate = "",
  });
}
