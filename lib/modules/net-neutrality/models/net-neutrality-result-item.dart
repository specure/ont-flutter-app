import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-net-neutrality-result-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/unknown-net-neutrality-result-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/web-net-neutrality-result-item.dart';

abstract class NetNeutralityResultItem {
  final int id;
  final String openTestUuid;
  final String? clientUuid;
  final int durationNs;
  final bool timeoutExceeded;
  final String type;

  NetNeutralityResultItem({
    required this.id,
    required this.openTestUuid,
    required this.durationNs,
    required this.timeoutExceeded,
    required this.type,
    this.clientUuid,
  });

  factory NetNeutralityResultItem.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('type')) {
      var type = json['type'];
      if (type == NetNeutralityType.WEB) {
        return WebNetNeutralityResultItem.fromJson(json);
      } else if (type == NetNeutralityType.DNS) {
        return DnsNetNeutralityResultItem.fromJson(json);
      }
    }
    return UnknownNetNeutralityResultItem();
  }

  Map<String, dynamic> toJson();

  static List<Map<String, dynamic>> toJsonList(List<NetNeutralityResultItem>? list) =>
      list?.map((e) => e.toJson()).toList() ?? [];
}
