import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';

class NTColors {
  static final Map<String, Color> _map = {
    'primary': Color(0xFF0958BD),
    'pale': Color(0x80000000),
    'secondary': Color(0xFF00ACB1),
    'tertiary': Color(0xFFFFCC00),
    'disabled': Color(0xFF888888),
    'startTestButtonGradient1': Color(0xFF0958BD),
    'startTestButtonGradient2': Color(0xFF00ACB1),
    'measurementBoxGradient1': Color(0xFF0958BD),
    'measurementBoxGradient2': Color(0xFF00ACB1),
    'measurementBoxText': Color(0xFF0958BD),
    'measurementCircularProgress': Color(0xFF0958BD),
    'measurementProgressBar': Color(0xFF00ACB1),
    'lightBackground': Color(0xFFEFEFEF),
    'network2g': Color(0xFFF7B500),
    'network3g': Color(0xFF6DD400),
    'network4g': Color(0xFF44D7B6),
    'network5g': Color(0xFF6236FF),
    'title': Color(0xFF212222),
    'subtitle': Colors.black54,
    'progressItem': Colors.black,
  };

  static Color get primary => _map['primary']!;
  static Color get pale => _map['pale']!;
  static Color get secondary => _map['secondary']!;
  static Color get tertiary => _map['tertiary']!;
  static Color get startTestButtonGradient1 =>
      _map['startTestButtonGradient1']!;
  static Color get startTestButtonGradient2 =>
      _map['startTestButtonGradient2']!;
  static Color get measurementBoxGradient1 => _map['measurementBoxGradient1']!;
  static Color get measurementBoxGradient2 => _map['measurementBoxGradient2']!;
  static Color get measurementBoxText => _map['measurementBoxText']!;
  static Color get measurementCircularProgress =>
      _map['measurementCircularProgress']!;
  static Color get measurementProgressBar => _map['measurementProgressBar']!;
  static Color get lightBackground => _map['lightBackground']!;
  static Color get network2g => _map['network2g']!;
  static Color get network3g => _map['network3g']!;
  static Color get network4g => _map['network4g']!;
  static Color get network5g => _map['network5g']!;
  static Color get title => _map['title']!;
  static Color get subtitle => _map['subtitle']!;
  static Color get progressItem => _map['progressItem']!;

  static Color getNetworkTechnologyColor(String technology) {
    var color = primary;
    switch (technology.toUpperCase()) {
      case '2G':
        color = NTColors.network2g;
        break;
      case '3G':
        color = NTColors.network3g;
        break;
      case '4G':
        color = NTColors.network4g;
        break;
      case '5G':
        color = NTColors.network5g;
        break;
    }
    return color;
  }

  NTColors._();

  static loadConfig() async {
    try {
      String jsonString = await rootBundle
          .loadString('config/${Environment.appSuffix}/colors.json');
      Map<String, dynamic> json = jsonDecode(jsonString);
      json.forEach((key, value) {
        _map[key] = Color(int.parse(value));
      });
    } catch (err) {
      print(err);
    }
  }
}
