import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:io' show Platform;

part 'settings.g.dart';

@JsonSerializable()
class Settings with EquatableMixin {
  @JsonKey(name: 'api_level')
  final int? apiLevel;
  final Map<String, dynamic>? capabilities;
  final String? device;
  final String? language;
  final String? model;
  final String name;
  @JsonKey(name: 'os_version')
  final String? osVersion;
  @JsonKey(name: 'platform')
  String platform;
  final String? product;
  final String? softwareRevision;
  final int? softwareRevisionCode;
  final String? softwareVersionName;
  @JsonKey(name: 'terms_and_conditions_accepted')
  final bool? termsAndConditionsAccepted;
  @JsonKey(name: 'terms_and_conditions_accepted_version')
  final int? termsAndConditionsAcceptedVersion;
  final String? timezone;
  final String type;
  @JsonKey(name: 'user_server_selection')
  final bool? userServerSelection;
  final String? uuid;
  @JsonKey(name: 'version_code')
  final int? versionCode;
  @JsonKey(name: 'version_name')
  final String? versionName;

  Settings({
    this.apiLevel,
    this.capabilities,
    this.device,
    this.language,
    this.model,
    this.name = 'RMBT',
    this.osVersion,
    this.platform = '',
    this.product,
    this.softwareRevision,
    this.softwareRevisionCode,
    this.softwareVersionName,
    this.termsAndConditionsAccepted,
    this.termsAndConditionsAcceptedVersion,
    this.timezone,
    this.type = 'MOBILE',
    this.userServerSelection,
    this.uuid,
    this.versionCode,
    this.versionName,
  }) {
    platform = Platform.isAndroid ? 'Android' : 'iOS';
  }

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  @override
  List<Object?> get props => [
        apiLevel,
        capabilities,
        device,
        language,
        model,
        name,
        osVersion,
        platform,
        product,
        softwareRevision,
        softwareRevisionCode,
        softwareVersionName,
        termsAndConditionsAccepted,
        termsAndConditionsAcceptedVersion,
        timezone,
        type,
        userServerSelection,
        uuid,
        versionCode,
        versionName,
      ];
}
