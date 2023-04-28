import 'package:equatable/equatable.dart';

class MapSearchRequest with EquatableMixin {
  final String query;
  final double lat;
  final double lng;
  final String countryCode;

  MapSearchRequest(
    this.query,
    this.lat,
    this.lng,
    this.countryCode,
  );

  @override
  List<Object?> get props => [query, lat, lng, countryCode];
}