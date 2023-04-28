import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';

class NTUrls {
  static final Map<String, String> _map = {
    'cms_***REMOVED***_route': '***REMOVED***',
    'cms_privacy_policy_route': '***REMOVED***',
    'cms_terms_of_use_route': '***REMOVED***',
    'cms_***REMOVED***_qos_route': '***REMOVED***',
    'cms_***REMOVED***_qoe_route': '***REMOVED***',
  };

  static String get cmsAboutRoute => _map['cms_***REMOVED***_route']!;
  static String get cmsPrivacyPolicyRoute => _map['cms_privacy_policy_route']!;
  static String get cmsTermsOfUseRoute => _map['cms_terms_of_use_route']!;
  static String get cmsMethodologyQosRoute =>
      _map['cms_***REMOVED***_qos_route']!;
  static String get cmsMethodologyQoeRoute =>
      _map['cms_***REMOVED***_qoe_route']!;

  NTUrls._();

  static loadConfig() async {
    try {
      String jsonString = await rootBundle
          .loadString('config/${Environment.appSuffix}/urls.json');
      Map<String, dynamic> json = jsonDecode(jsonString);
      json.forEach((key, value) {
        _map[key] = value;
      });
    } catch (err) {
      print(err);
    }
  }
}
