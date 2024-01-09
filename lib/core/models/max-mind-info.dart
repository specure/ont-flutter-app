import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'max-mind-info.g.dart';

@JsonSerializable()
class MaxMindInfo extends Equatable {
  @JsonKey()
  final MaxMindInfoTraits traits;
  @JsonKey(name: "registered_country")
  final MaxMindInfoRegisteredCountry registeredCountry;

  MaxMindInfo({required this.traits, required this.registeredCountry});

  Map<String, dynamic> toJson() => _$MaxMindInfoToJson(this);
  factory MaxMindInfo.fromJson(Map<String, dynamic> json) =>
      _$MaxMindInfoFromJson(json);

  @override
  List<Object?> get props => [traits, registeredCountry];
}

@JsonSerializable()
class MaxMindInfoTraits extends Equatable {
  @JsonKey()
  final String? isp;
  @JsonKey(name: "mobile_country_code")
  final String? mobileCountryCode;
  @JsonKey(name: "mobile_network_code")
  final String? mobileNetworkCode;
  @JsonKey()
  final String? organization;

  MaxMindInfoTraits({
    this.isp,
    this.mobileCountryCode,
    this.mobileNetworkCode,
    this.organization,
  });

  Map<String, dynamic> toJson() => _$MaxMindInfoTraitsToJson(this);
  factory MaxMindInfoTraits.fromJson(Map<String, dynamic> json) =>
      _$MaxMindInfoTraitsFromJson(json);

  @override
  List<Object?> get props => [isp, mobileCountryCode, mobileNetworkCode];
}

@JsonSerializable()
class MaxMindInfoRegisteredCountry extends Equatable {
  @JsonKey(name: "iso_code")
  final String? iso;

  MaxMindInfoRegisteredCountry({this.iso});

  Map<String, dynamic> toJson() => _$MaxMindInfoRegisteredCountryToJson(this);
  factory MaxMindInfoRegisteredCountry.fromJson(Map<String, dynamic> json) =>
      _$MaxMindInfoRegisteredCountryFromJson(json);

  @override
  List<Object?> get props => [iso];
}
