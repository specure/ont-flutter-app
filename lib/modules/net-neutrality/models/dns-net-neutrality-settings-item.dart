import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-settings-item.dart';

part 'dns-net-neutrality-settings-item.g.dart';

@JsonSerializable()
class DnsNetNeutralitySettingsItem extends NetNeutralitySettingsItem {
  String? resolver;
  String entryType;
  String target;
  String expectedDnsStatus;
  String? expectedDnsEntries;

  DnsNetNeutralitySettingsItem({
    this.resolver,
    this.expectedDnsEntries,
    required this.target,
    required this.entryType,
    required this.expectedDnsStatus,
    required int id,
    required String type,
    required num timeout,
  }) : super(
          id: id,
          type: type,
          timeout: timeout,
        ) {
    this.resolver = this.resolver?.isNotEmpty == true ? this.resolver : null;
    this.target = this
        .target
        .replaceFirst("https://", "")
        .replaceFirst("http://", "")
        .replaceFirst("www.", "");
  }

  factory DnsNetNeutralitySettingsItem.fromJson(Map<String, dynamic> json) =>
      _$DnsNetNeutralitySettingsItemFromJson(json);

  Map<String, dynamic> toJson() => _$DnsNetNeutralitySettingsItemToJson(this);
}
