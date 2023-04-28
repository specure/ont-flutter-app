import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/date-time.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-result-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/web-net-neutrality-settings-item.dart';

part 'web-net-neutrality-result-item.g.dart';

@JsonSerializable()
class WebNetNeutralityResultItem extends NetNeutralityResultItem {
  final int? statusCode;

  WebNetNeutralityResultItem({
    required int id,
    required String openTestUuid,
    required int durationNs,
    required bool timeoutExceeded,
    required String type,
    this.statusCode,
    String? clientUuid,
  }) : super(
          id: id,
          openTestUuid: openTestUuid,
          clientUuid: clientUuid,
          durationNs: durationNs,
          timeoutExceeded: timeoutExceeded,
          type: type,
        );

  factory WebNetNeutralityResultItem.fromSettingsItem(
    WebNetNeutralitySettingsItem settingsItem, {
    required String openTestUuid,
    required int requestSentAt,
    required bool timeoutExceeded,
    int? statusCode,
  }) {
    final durationNs =
        (GetIt.I.get<DateTimeWrapper>().nowInMillis() - requestSentAt) * 1000000;
    final id = settingsItem.id;
    final clientUuid = GetIt.I
        .get<SharedPreferencesWrapper>()
        .getString(StorageKeys.clientUuid);
    return WebNetNeutralityResultItem(
      clientUuid: clientUuid,
      id: id,
      durationNs: durationNs,
      statusCode: statusCode,
      timeoutExceeded: timeoutExceeded,
      openTestUuid: openTestUuid,
      type: NetNeutralityType.WEB,
    );
  }

  factory WebNetNeutralityResultItem.fromJson(Map<String, dynamic> json) =>
      _$WebNetNeutralityResultItemFromJson(json);

  Map<String, dynamic> toJson() => _$WebNetNeutralityResultItemToJson(this);
}
