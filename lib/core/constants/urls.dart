import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';

class NTUrls {
  static final Map<String, String> _map = {
    'cms_about_route': 'about',
    'cms_privacy_policy_route': 'privacy-policy',
    'cms_terms_of_use_route': 'terms-of-use',
    'cms_methodology_qos_route': 'methodology',
    'cms_methodology_qoe_route': 'methodology',
  };

  static String get cmsAboutRoute => _map['cms_about_route']!;
  static String get cmsPrivacyPolicyRoute => _map['cms_privacy_policy_route']!;
  static String get cmsTermsOfUseRoute => _map['cms_terms_of_use_route']!;
  static String get cmsMethodologyQosRoute =>
      _map['cms_methodology_qos_route']!;
  static String get cmsMethodologyQoeRoute =>
      _map['cms_methodology_qoe_route']!;

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
