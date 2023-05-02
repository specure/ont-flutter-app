import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';

class NTUrls {
  static final Map<String, String> _map = {
    'cms_about_route': 'cms_about_route',
    'cms_privacy_policy_route': 'cms_privacy_policy_route',
    'cms_terms_of_use_route': 'cms_terms_of_use_route',
    'cms_methodology_qos_route': 'cms_methodology_qos_route',
    'cms_methodology_qoe_route': 'cms_methodology_qoe_route',
    'cms_projects_route': '/cms_projects_route',
    'cms_pages_route': '/cms_pages_route',
    'cms_translations_route': '/cms_translations_route',
    'cs_speed_history_route': '/cs_speed_history_route',
    'cs_providers_route': '/cs_providers_route',
    'cs_results_route': '/cs_results_route',
    'cs_graphs_route': '/cs_graphs_route',
    'cs_ip_route': '/cs_ip_route',
    'cs_result_route': '/cs_result_route',
    'cs_measurement_server_route': '/cs_measurement_server_route',
    'cs_nn_request_route': '/cs_nn_request_route',
    'cs_nn_result_route': '/cs_nn_result_route',
    'cs_nn_history_route': '/cs_nn_history_route',
    'cs_settings_route': '/cs_settings_route'
  };

  static String get cmsAboutRoute => _map['cms_about_route']!;
  static String get cmsPrivacyPolicyRoute => _map['cms_privacy_policy_route']!;
  static String get cmsTermsOfUseRoute => _map['cms_terms_of_use_route']!;
  static String get cmsMethodologyQosRoute =>
      _map['cms_methodology_qos_route']!;
  static String get cmsMethodologyQoeRoute =>
      _map['cms_methodology_qoe_route']!;
  static String get cmsProjectsRoute => _map['cms_projects_route']!;
  static String get cmsPagesRoute => _map['cms_pages_route']!;
  static String get cmsTranslationsRoute => _map['cms_translations_route']!;

  static String get csSpeedHistoryRoute => _map['cs_speed_history_route']!;
  static String get csProvidersRoute => _map['cs_providers_route']!;
  static String get csResultsRoute => _map['cs_results_route']!;
  static String get csGraphsRoute => _map['cs_graphs_route']!;
  static String get csIpRoute => _map['cs_ip_route']!;
  static String get csResultRoute => _map['cs_result_route']!;
  static String get csMeasurementServerRoute =>
      _map['cs_measurement_server_route']!;
  static String get csNNRequestRoute => _map['cs_nn_request_route']!;
  static String get csNNResultRoute => _map['cs_nn_result_route']!;
  static String get csNNHistoryRoute => _map['cs_nn_history_route']!;
  static String get csSettingsRoute => _map['cs_settings_route']!;

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
