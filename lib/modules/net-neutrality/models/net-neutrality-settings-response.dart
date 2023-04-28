import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-net-neutrality-settings-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/web-net-neutrality-settings-item.dart';
import 'package:uuid/uuid.dart';

part 'net-neutrality-settings-response.g.dart';

@JsonSerializable()
class NetNeutralitySettingsResponse {
  @JsonKey(name: "WEB")
  final List<WebNetNeutralitySettingsItem>? web;
  @JsonKey(name: "DNS")
  final List<DnsNetNeutralitySettingsItem>? dns;
  final openTestUuid = Uuid().v4();

  @JsonKey(includeFromJson: false, includeToJson: false)
  int totalTests = 0;

  NetNeutralitySettingsResponse({this.web, this.dns}) {
    this.totalTests = this.web?.length ?? 0;
    this.totalTests += this.dns?.length ?? 0;
  }

  factory NetNeutralitySettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$NetNeutralitySettingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NetNeutralitySettingsResponseToJson(this);
}
