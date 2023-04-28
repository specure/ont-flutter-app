import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-net-neutrality-settings-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-result.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-result-item.dart';

part 'dns-net-neutrality-result-item.g.dart';

@JsonSerializable()
class DnsNetNeutralityResultItem extends NetNeutralityResultItem {
  final String dnsStatus;
  final String resolver;
  final List<String> dnsEntries;

  DnsNetNeutralityResultItem({
    required int id,
    required String openTestUuid,
    required int durationNs,
    required bool timeoutExceeded,
    required String type,
    required this.dnsStatus,
    required this.resolver,
    required this.dnsEntries,
    String? clientUuid,
  }) : super(
          id: id,
          openTestUuid: openTestUuid,
          clientUuid: clientUuid,
          durationNs: durationNs,
          timeoutExceeded: timeoutExceeded,
          type: type,
        );

  factory DnsNetNeutralityResultItem.fromSettingsAndResultItem(
    DnsNetNeutralitySettingsItem settingsItem,
    DnsResult? dnsResult, {
    required String openTestUuid,
  }) {
    final id = settingsItem.id;
    final clientUuid = GetIt.I
        .get<SharedPreferencesWrapper>()
        .getString(StorageKeys.clientUuid);
    final timeoutSeconds = dnsResult?.timeoutSeconds ?? 0;
    final resultDurationNanos = dnsResult?.resultDurationNanos ?? 0;
    return DnsNetNeutralityResultItem(
      clientUuid: clientUuid,
      id: id,
      durationNs: resultDurationNanos,
      dnsStatus: dnsResult?.resultStatus != null
          ? DnsResultStatus.getAsString(dnsResult!.resultStatus)
          : (dnsResult?.resultQueryStatus ?? DnsResultStatus.getAsString(null)),
      timeoutExceeded: (resultDurationNanos / 1e9) > timeoutSeconds,
      openTestUuid: openTestUuid,
      dnsEntries:
          dnsResult?.dnsRecords?.map((e) => e.resultAddress!).toList() ??
              <String>[],
      resolver: dnsResult?.resultResolver ?? "",
      type: NetNeutralityType.DNS,
    );
  }

  factory DnsNetNeutralityResultItem.fromJson(Map<String, dynamic> json) =>
      _$DnsNetNeutralityResultItemFromJson(json);
  Map<String, dynamic> toJson() => _$DnsNetNeutralityResultItemToJson(this);
}
