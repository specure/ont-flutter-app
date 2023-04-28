// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NTProject _$NTProjectFromJson(Map<String, dynamic> json) => NTProject(
      mapboxActualDate: json['mapbox_actual_date'] as String?,
      enableAppResultsSharing:
          json['enable_app_results_sharing'] as bool? ?? false,
      enableAppResultsSynchronization:
          json['enable_app_results_synchronization'] as bool? ?? false,
      enableAppLoopMode: json['enable_app_loop_mode'] as bool? ?? false,
      enableAppInAppReview: json['enable_app_in_app_review'] as bool? ?? false,
      enableAppPrivateIp: json['enable_app_private_ip'] as bool? ?? false,
      enableAppIpColorCoding:
          json['enable_app_ip_color_coding'] as bool? ?? false,
      enableAppLanguageSwitch:
          json['enable_app_language_switch'] as bool? ?? false,
      enableAppNetNeutralityTests:
          json['enable_app_net_neutrality_tests'] as bool? ?? false,
      enableAppJitterAndPacketLoss:
          json['enable_app_jitter_and_packet_loss'] as bool? ?? false,
      enableAppQosResultExplanation:
          json['enable_app_qos_result_explanation'] as bool? ?? false,
      enableAppQoeResultExplanation:
          json['enable_app_qoe_result_explanation'] as bool? ?? false,
    );

Map<String, dynamic> _$NTProjectToJson(NTProject instance) => <String, dynamic>{
      'mapbox_actual_date': instance.mapboxActualDate,
      'enable_app_results_sharing': instance.enableAppResultsSharing,
      'enable_app_results_synchronization':
          instance.enableAppResultsSynchronization,
      'enable_app_loop_mode': instance.enableAppLoopMode,
      'enable_app_in_app_review': instance.enableAppInAppReview,
      'enable_app_private_ip': instance.enableAppPrivateIp,
      'enable_app_ip_color_coding': instance.enableAppIpColorCoding,
      'enable_app_language_switch': instance.enableAppLanguageSwitch,
      'enable_app_net_neutrality_tests': instance.enableAppNetNeutralityTests,
      'enable_app_jitter_and_packet_loss':
          instance.enableAppJitterAndPacketLoss,
      'enable_app_qos_result_explanation':
          instance.enableAppQosResultExplanation,
      'enable_app_qoe_result_explanation':
          instance.enableAppQoeResultExplanation,
    };
