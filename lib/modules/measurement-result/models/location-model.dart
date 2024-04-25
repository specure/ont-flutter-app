import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/address.dart';

part 'location-model.g.dart';

@JsonSerializable()
class LocationModel with EquatableMixin {
  @JsonKey(name: 'lat')
  final double? latitude;
  @JsonKey(name: 'long')
  final double? longitude;
  final String? city;
  final String? country;
  final String? county;
  final String? postalCode;

  String get locationString {
    String locationString = '-';
    final lPostalCode =
        postalCode != null && postalCode!.isNotEmpty ? '$postalCode, ' : '';
    final lCity = city != null && city!.isNotEmpty ? '$city, ' : '';
    final lCounty = county != null && county!.isNotEmpty ? '$county, ' : '';
    final lCountry = country != null && country!.isNotEmpty ? country! : '';
    locationString = lPostalCode + lCity + lCounty + lCountry;
    return locationString.isEmpty ? '-' : locationString;
  }

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.city,
    this.country,
    this.county,
    this.postalCode,
  });

  bool get isLocationPresent => latitude != null && longitude != null;
  bool get isAllDataPresent =>
      isLocationPresent &&
      (city?.isNotEmpty ?? false) &&
      (county?.isNotEmpty ?? false) &&
      (country?.isNotEmpty ?? false) &&
      (postalCode?.isNotEmpty ?? false);

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  factory LocationModel.fromPlacemark(
    Placemark placemark, {
    required double latitude,
    required double longitude,
  }) =>
      LocationModel(
        latitude: latitude,
        longitude: longitude,
        city: placemark.locality,
        county: placemark.administrativeArea,
        country: placemark.country,
        postalCode: placemark.postalCode,
      );

  factory LocationModel.fromAddress(
    Address address, {
    required double latitude,
    required double longitude,
  }) =>
      LocationModel(
        latitude: latitude,
        longitude: longitude,
        city: address.city,
        county: address.county,
        country: address.countryName,
        postalCode: address.postalCode,
      );

  @override
  List<Object?> get props =>
      [latitude, longitude, city, country, county, postalCode];

  bool isNot(LocationModel? lastLocation) {
    if (lastLocation == null) {
      return true;
    }
    final latDiff = (latitude! - lastLocation.latitude!).abs();
    final lonDiff = (longitude! - lastLocation.longitude!).abs();
    return latDiff > 0.005 || lonDiff > 0.005;
  }

  bool isA(LocationModel? lastLocation) {
    return !isNot(lastLocation);
  }
}
