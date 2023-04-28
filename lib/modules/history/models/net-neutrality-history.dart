import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-measurement.dart';

class NetNeutralityHistory {
  List<NetNeutralityHistoryMeasurement> content;
  final int totalElements;
  final int totalPages;
  final bool last;

  NetNeutralityHistory({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });
}