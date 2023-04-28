import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.item.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.request.dart';

class MapSearchApiService extends DioService {
  MapSearchApiService({bool testing = false})
      : super(
          testing: testing,
          baseUrl: 'https://geocode.search.hereapi.com',
        );

  Future<List<MapSearchItem>> search(MapSearchRequest request) async {
    try {
      final response = await dio.get('/v1/geocode', queryParameters: {
        'q': request.query,
        'at': '${request.lat.toString()},${request.lng.toString()}',
        'in': 'countryCode:${request.countryCode}',
        'limit': 10,
        'apiKey': dotenv.env['HERE_API_TOKEN'],
      });
      List<dynamic> data = response.data['items'];
      List<MapSearchItem> items = data.map((item) {
        final mapView = item['mapView'];
        final southwest = mapView?['south'] != null && mapView?['west'] != null
            ? LatLng(mapView['south'], mapView['west'])
            : null;
        final northeast = mapView?['north'] != null && mapView?['east'] != null
            ? LatLng(mapView['north'], mapView['east'])
            : null;
        final bounds = southwest != null && northeast != null
            ? LatLngBounds(
                southwest: southwest,
                northeast: northeast,
              )
            : null;
        return MapSearchItem(
          title: item['title'],
          address: item['address']['label'],
          latitude: item['position']['lat'],
          longitude: item['position']['lng'],
          bounds: bounds,
        );
      }).toList();
      return items;
    } on DioError catch (e) {
      print(e);
      return [];
    }
  }
}
