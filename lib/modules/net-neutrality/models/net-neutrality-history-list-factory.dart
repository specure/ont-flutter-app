import 'package:nt_flutter_standalone/core/extensions/iterables.ext.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-category.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-measurement.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/web-net-neutrality-history-item.dart';

class NetNeutralityHistoryListFactory {
  static List<NetNeutralityHistoryItem> parseHistoryResponse(
    Map<String, dynamic>? response,
  ) {
    final list = (response?['content'] as List?) ?? [];
    return list.map((item) {
      switch (item['type']) {
        case NetNeutralityType.DNS:
          return DnsNetNeutralityHistoryItem.fromJson(item);
        case NetNeutralityType.WEB:
        default:
          return WebNetNeutralityHistoryItem.fromJson(item);
      }
    }).toList();
  }

  static List<NetNeutralityHistoryMeasurement> parseWholeHistoryResponse(
    Map<String, dynamic>? response,
  ) {
    final itemList = parseHistoryResponse(response);
    final Map map = itemList.groupBy((m) => m.openTestUuid);
    List<NetNeutralityHistoryMeasurement> netNeutralityMeasurements = [];
    var measurementDate = "";
    map.keys.forEach((element) {
      Map<String, List<NetNeutralityHistoryItem>> typeResults =
          (map[element] as List<NetNeutralityHistoryItem>)
              .groupBy((m) => m.type);
      Map<String, NetNeutralityHistoryCategory> testCategories = {};
      typeResults.keys.forEach((categoryName) {
        var categoryResults =
            typeResults[categoryName] as List<NetNeutralityHistoryItem>;
        var device = categoryResults[0].device;
        var networkType = categoryResults[0].networkType;
        var successfulCountInCategory = categoryResults.where(
            (element) => element.testStatus == NetNeutralityTestStatus.SUCCEED);
        var failedCountInCategory = categoryResults.where(
            (element) => element.testStatus != NetNeutralityTestStatus.SUCCEED);
        var earliestCategoryMeasurementDate = categoryResults
            .reduce((current, next) =>
                current.measurementDate.compareTo(next.measurementDate) == -1
                    ? current
                    : next)
            .measurementDate;
        if (measurementDate.isEmpty) {
          measurementDate = earliestCategoryMeasurementDate;
        } else {
          measurementDate =
              earliestCategoryMeasurementDate.compareTo(measurementDate) < 0
                  ? earliestCategoryMeasurementDate
                  : measurementDate;
        }

        final category = NetNeutralityHistoryCategory(categoryName,
            deviceName: device ?? '',
            networkType: networkType ?? '',
            measurementDate: earliestCategoryMeasurementDate,
            totalResults: categoryResults.length,
            successfulResults: successfulCountInCategory.length,
            failedResults: failedCountInCategory.length,
            items: categoryResults,
            type: categoryName);
        testCategories[categoryName] = category;
      });
      String? device;
      String? networkType;
      if (testCategories.keys.isNotEmpty) {
        var key = testCategories.keys.first;
        var category = testCategories[key];
        if (category != null) {
          device = category.deviceName;
          networkType = category.networkType;
        }
      }
      final measurement = NetNeutralityHistoryMeasurement(
        tests: testCategories,
        openTestUuid: element,
        deviceName: device ?? "",
        networkType: networkType ?? "",
        measurementDate: measurementDate,
      );
      netNeutralityMeasurements.add(measurement);
    });
    return netNeutralityMeasurements;
  }

  NetNeutralityHistoryListFactory._();
}
