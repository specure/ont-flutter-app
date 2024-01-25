import 'package:maplibre_gl/maplibre_gl.dart';

class MapSearchItem {
  final String title;
  final String address;
  final double latitude;
  final double longitude;
  final LatLngBounds? bounds;

  MapSearchItem({
    required this.title,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.bounds,
  });
}
