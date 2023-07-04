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

extension NetNeutralityHistoryItemList
    on List<NetNeutralityHistoryMeasurement> {
  List<NetNeutralityHistoryMeasurement> merge(
      List<NetNeutralityHistoryMeasurement> that) {
    Map<String, NetNeutralityHistoryMeasurement> thatContentMap = {};
    if (that.length <= 0) {
      return this;
    }
    for (final item in that) {
      final existingItem = thatContentMap[item.openTestUuid];
      thatContentMap[item.openTestUuid] =
          item.copyWith(tests: {...existingItem?.tests ?? {}, ...item.tests});
    }
    for (var i = 0; i < this.length; i++) {
      final item = this[i];
      final existingItem = thatContentMap[item.openTestUuid];
      if (existingItem != null) {
        this[i] =
            this[i].copyWith(tests: {...item.tests, ...existingItem.tests});
      }
      thatContentMap.remove(item.openTestUuid);
    }
    final retVal = [...this, ...thatContentMap.values];
    return retVal;
  }
}
