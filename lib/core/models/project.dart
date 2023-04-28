import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class NTProject extends Equatable {
  @JsonKey(name: 'mapbox_actual_date')
  final String? mapboxActualDate;
  @JsonKey(name: 'enable_app_results_sharing')
  final bool enableAppResultsSharing;
  @JsonKey(name: 'enable_app_results_synchronization')
  final bool enableAppResultsSynchronization;
  @JsonKey(name: 'enable_app_loop_mode')
  final bool enableAppLoopMode;
  @JsonKey(name: 'enable_app_in_app_review')
  final bool enableAppInAppReview;
  @JsonKey(name: 'enable_app_private_ip')
  final bool enableAppPrivateIp;
  @JsonKey(name: 'enable_app_ip_color_coding')
  final bool enableAppIpColorCoding;
  @JsonKey(name: 'enable_app_language_switch')
  final bool enableAppLanguageSwitch;
  @JsonKey(name: 'enable_app_net_neutrality_tests')
  final bool enableAppNetNeutralityTests;
  @JsonKey(name: 'enable_app_jitter_and_packet_loss')
  final bool enableAppJitterAndPacketLoss;
  @JsonKey(name: 'enable_app_qos_result_explanation')
  final bool enableAppQosResultExplanation;
  @JsonKey(name: 'enable_app_qoe_result_explanation')
  final bool enableAppQoeResultExplanation;

  NTProject({
    this.mapboxActualDate,
    this.enableAppResultsSharing = false,
    this.enableAppResultsSynchronization = false,
    this.enableAppLoopMode = false,
    this.enableAppInAppReview = false,
    this.enableAppPrivateIp = false,
    this.enableAppIpColorCoding = false,
    this.enableAppLanguageSwitch = false,
    this.enableAppNetNeutralityTests = false,
    this.enableAppJitterAndPacketLoss = false,
    this.enableAppQosResultExplanation = false,
    this.enableAppQoeResultExplanation = false,
  });

  Map<String, dynamic> toJson() => _$NTProjectToJson(this);
  factory NTProject.fromJson(Map<String, dynamic> json) =>
      _$NTProjectFromJson(json);

  @override
  List<Object?> get props => [
        mapboxActualDate,
        enableAppResultsSharing,
        enableAppResultsSynchronization,
        enableAppLoopMode,
        enableAppInAppReview,
        enableAppPrivateIp,
        enableAppIpColorCoding,
        enableAppLanguageSwitch,
        enableAppNetNeutralityTests,
        enableAppJitterAndPacketLoss,
        enableAppQosResultExplanation,
        enableAppQoeResultExplanation,
      ];
}