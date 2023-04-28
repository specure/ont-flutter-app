import 'dart:convert';

import 'package:flutter/services.dart';

import 'environment.dart';

class MapBoxConsts {
  static final Map<String, dynamic> _map = {
    'styleUrl': 'mapbox://styles/mapbox/light-v10',
    'initialLat': 0.0,
    'initialLng': 0.0,
    'initialZoom': 1.0,
    'countryCode': 'UNKNOWN',
    'zoomLevelC': 5.0,
    'zoomLevelM': 7.5,
    'zoomLevelH10': 10.0,
    'zoomLevelH1': 12.0,
    'zoomLevelH01': 14.0,
  };

  static String get styleUrl => _map['styleUrl']!;
  static double get initialLat => _map['initialLat']!;
  static double get initialLng => _map['initialLng']!;
  static double get initialZoom => _map['initialZoom']!;
  static String get countryCode => _map['countryCode']!;
  static double get zoomLevelC => _map['zoomLevelC'];
  static double get zoomLevelM => _map['zoomLevelM'];
  static double get zoomLevelH10 => _map['zoomLevelH10'];
  static double get zoomLevelH1 => _map['zoomLevelH1'];
  static double get zoomLevelH01 => _map['zoomLevelH01'];

  MapBoxConsts._();

  static loadConfig() async {
    try {
      String jsonString = await rootBundle
          .loadString('config/${Environment.appSuffix}/mapbox.json');
      Map<String, dynamic> json = jsonDecode(jsonString);
      json.forEach((key, value) {
        _map[key] = value;
      });
    } catch (err) {
      print(err);
    }
  }
}
