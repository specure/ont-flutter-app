import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/address.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/geocoding-wrapper.dart';

class LocationService extends DioService {
  static const MethodChannel _channel = const MethodChannel("nettest/location");
  final GeocodingWrapper geocoding = GetIt.I.get<GeocodingWrapper>();

  LocationService({bool testing = false})
      : super(
          testing: testing,
          baseUrl: 'https://geocode.search.hereapi.com',
        );

  Future<bool> get isLocationServiceEnabled async {
    try {
      final retVal = await _channel.invokeMethod('isLocationServiceEnabled');
      return retVal ?? false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<LocationModel?> get latestLocation async {
    try {
      final response = await _channel.invokeMethod('getLatestLocation');
      if (response == null) {
        return null;
      }
      Map<String, dynamic> json = jsonDecode(response);
      final locationModel = LocationModel.fromJson(json);
      return locationModel;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<LocationModel?> getAddressByLocation(
      double latitude, double longitude) async {
    LocationModel? address;
    try {
      // Try using built-in geolocation services
      final placemarks =
          await geocoding.getPlaceMarksFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        address = LocationModel.fromPlacemark(
          placemarks.first,
          latitude: latitude,
          longitude: longitude,
        );
      } else {
        throw Exception("No placemarks found at the specified location");
      }
      if (!address.isAllDataPresent) {
        throw Exception("Not all data is avialable for the specified location");
      }
    } catch (e) {
      // Fallback to HERE API
      print(e);
      final locationString = '$latitude,$longitude';
      final response = await dio.get('/v1/discover', queryParameters: {
        'q': locationString,
        'at': locationString,
        'limit': 1,
        'apiKey': dotenv.env['HERE_API_TOKEN'],
        'lang': 'en-US',
      });
      final List<dynamic> data = response.data['items'];
      address = data.isNotEmpty
          ? LocationModel.fromAddress(
              Address.fromJson(data.first['address']),
              latitude: latitude,
              longitude: longitude,
            )
          : null;
    }
    return address;
  }

  Future<LatLng> getCoordinatesByName(String name) async {
    LatLng coordinates;
    try {
      // Try using built-in geolocation services
      final locations = await geocoding.getLocationFromAddress(name);
      if (locations.isNotEmpty) {
        coordinates = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );
      } else {
        throw Exception("Coordinates for the address not found");
      }
    } catch (e) {
      // Fallback to HERE API
      print(e);
      final response = await dio.get('/v1/geocode', queryParameters: {
        'q': name,
        'limit': 1,
        'apiKey': dotenv.env['HERE_API_TOKEN'],
        'lang': 'en-US',
      });
      final List<dynamic> data = response.data['items'];
      final Map<String, dynamic> position =
          data.isNotEmpty ? data.first['position'] : {};
      coordinates = LatLng(
        position['lat'] ?? 0,
        position['lng'] ?? 0,
      );
    }
    return coordinates;
  }
}
