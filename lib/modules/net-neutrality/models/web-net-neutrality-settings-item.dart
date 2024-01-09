import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-settings-item.dart';

part 'web-net-neutrality-settings-item.g.dart';

@JsonSerializable()
class WebNetNeutralitySettingsItem extends NetNeutralitySettingsItem {
  final String target;
  final int? expectedStatusCode;

  WebNetNeutralitySettingsItem({
    this.expectedStatusCode,
    required this.target,
    required int id,
    required String type,
    required double timeout,
  }) : super(
          id: id,
          type: type,
          timeout: timeout,
        );

  factory WebNetNeutralitySettingsItem.fromJson(Map<String, dynamic> json) =>
      _$WebNetNeutralitySettingsItemFromJson(json);
  Map<String, dynamic> toJson() => _$WebNetNeutralitySettingsItemToJson(this);
}
