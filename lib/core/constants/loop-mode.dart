import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';

class LoopMode {
  static final Map<String, int> _map = {
    'loop_mode_default_measurement_count': 10,
    'loop_mode_default_waiting_time_minutes': 5,
    'loop_mode_default_distance_meters': 250,
    'loop_mode_measurement_count_min': 2,
    'loop_mode_measurement_count_max': 100,
    'loop_mode_waiting_time_minutes_min': 0,
    'loop_mode_waiting_time_minutes_max': 1440,
    'loop_mode_distance_meters_min': 250,
    'loop_mode_distance_meters_max': 10000
  };
  static int get loopModeDefaultMeasurementCount =>
      _map['loop_mode_default_measurement_count']!;
  static int get loopModeDefaultWaitingTimeMinutes =>
      _map['loop_mode_default_waiting_time_minutes']!;
  static int get loopModeDefaultDistanceMeters =>
      _map['loop_mode_default_distance_meters']!;
  static int get loopModeMeasurementCountMin =>
      _map['loop_mode_measurement_count_min']!;
  static int get loopModeMeasurementCountMax =>
      _map['loop_mode_measurement_count_max']!;
  static int get loopModeWaitingTimeMinutesMin =>
      _map['loop_mode_waiting_time_minutes_min']!;
  static int get loopModeWaitingTimeMinutesMax =>
      _map['loop_mode_waiting_time_minutes_max']!;
  static int get loopModeDistanceMetersMin =>
      _map['loop_mode_distance_meters_min']!;
  static int get loopModeDistanceMetersMax =>
      _map['loop_mode_distance_meters_max']!;

  LoopMode._();

  static loadConfig() async {
    try {
      String jsonString = await rootBundle
          .loadString('config/${Environment.appSuffix}/loop_mode_consts.json');
      Map<String, dynamic> json = jsonDecode(jsonString);
      json.forEach((key, value) {
        _map[key] = value;
      });
    } catch (err) {
      print(err);
    }
  }
}
