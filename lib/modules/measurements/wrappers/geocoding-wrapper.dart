import 'package:geocoding/geocoding.dart';

//Geocoding is wrapped in order to be able to mock its top level functions
class GeocodingWrapper {
  Future<List<Placemark>> getPlaceMarksFromCoordinates(
      double lat, double lng) async {
    return await placemarkFromCoordinates(
      lat,
      lng,
    );
  }

  Future<List<Location>> getLocationFromAddress(String address) async {
    return await locationFromAddress(address);
  }
}
