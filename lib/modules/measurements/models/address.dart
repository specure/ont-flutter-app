import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  final String? label;
  final String? countryCode;
  final String? countryName;
  final String? state;
  final String? county;
  final String? city;
  final String? street;
  final String? postalCode;
  final String? houseNumber;

  Address({
    this.label,
    this.countryCode,
    this.countryName,
    this.state,
    this.county,
    this.city,
    this.street,
    this.postalCode,
    this.houseNumber,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}