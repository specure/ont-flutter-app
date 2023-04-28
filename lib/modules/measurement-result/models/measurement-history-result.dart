import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/core/extensions/double.ext.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-quality.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/technology-signal.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';

part 'measurement-history-result.g.dart';

@JsonSerializable()
class MeasurementHistoryResult with EquatableMixin {
  static const String networkTypeField = 'networkType';
  static const String deviceField = 'device';

  @JsonKey(name: 'test_uuid')
  final String testUuid;
  @JsonKey(name: 'speed_upload')
  final double uploadKbps;
  @JsonKey(name: 'speed_download')
  final double downloadKbps;
  @JsonKey(name: 'ping')
  final double pingMs;
  @JsonKey(name: 'network_type')
  final String? networkType;
  final String? networkName;
  @JsonKey(name: 'measurement_date')
  final String measurementDate;
  final String? device;
  @JsonKey(name: 'loop_mode_uuid')
  final String? loopModeUuid;
  final List<MeasurementQuality> userExperienceMetrics;
  @JsonKey(name: 'voip_result_jitter_millis')
  final double? jitterMs;
  @JsonKey(name: 'voip_result_packet_loss_percents')
  final double? packetLossPercents;
  final List<TechnologySignal>? radioSignals;
  final LocationModel? location;
  final String? measurementServerName;
  final String? measurementServerCity;
  final String? operator;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<double> downloadSpeedDetails;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<double> uploadSpeedDetails;

  MeasurementHistoryResult({
    required this.testUuid,
    required this.uploadKbps,
    required this.downloadKbps,
    required this.pingMs,
    required this.measurementDate,
    this.networkType,
    this.networkName,
    this.device,
    this.loopModeUuid,
    this.userExperienceMetrics = const [],
    this.jitterMs,
    this.packetLossPercents,
    this.radioSignals,
    this.location,
    this.measurementServerName,
    this.measurementServerCity,
    this.operator,
    this.downloadSpeedDetails = const [],
    this.uploadSpeedDetails = const [],
  });

  String get pingMsFormatted => pingMs.toInt().toString();

  String get uploadSpeedMbpsFormatted => uploadKbps.roundSpeed();

  String get downloadSpeedMbpsFormatted => downloadKbps.roundSpeed();

  String resolveNetworkInfo() {
    var networkInfo = "";
    if (networkType != null) {
      networkInfo += "$networkType";
      if (networkName != null &&
          networkName?.toLowerCase() != "wlan" &&
          networkName?.toLowerCase() != "unknown" &&
          networkName?.toLowerCase() != "mobile" &&
          networkName?.toLowerCase() != "cellular_any" &&
          (networkInfo != nrSignallingOnly &&
              networkInfo != nrSignallingOnlyAlt)) {
        networkInfo += " ($networkName)";
      }
      return networkInfo;
    } else {
      return '-';
    }
  }

  String? getFieldByType(String type) {
    return type == networkTypeField ? networkType : device;
  }

  MeasurementHistoryResult withSpeedDetails(
    List<double> downloadSpeedDetails,
    List<double> uploadSpeedDetails,
  ) {
    return MeasurementHistoryResult(
      testUuid: this.testUuid,
      uploadKbps: this.uploadKbps,
      downloadKbps: this.downloadKbps,
      pingMs: this.pingMs,
      measurementDate: this.measurementDate,
      networkType: this.networkType,
      networkName: this.networkName,
      device: this.device,
      loopModeUuid: this.loopModeUuid,
      userExperienceMetrics: this.userExperienceMetrics,
      packetLossPercents: this.packetLossPercents,
      jitterMs: this.jitterMs,
      radioSignals: this.radioSignals,
      location: this.location,
      measurementServerName: this.measurementServerName,
      measurementServerCity: this.measurementServerCity,
      operator: this.operator,
      downloadSpeedDetails: downloadSpeedDetails,
      uploadSpeedDetails: uploadSpeedDetails,
    );
  }

  factory MeasurementHistoryResult.fromJson(Map<String, dynamic> json) =>
      _$MeasurementHistoryResultFromJson(json);

  Map<String, dynamic> toJson() => _$MeasurementHistoryResultToJson(this);

  @override
  List<Object?> get props => [
        testUuid,
        uploadKbps,
        downloadKbps,
        pingMs,
        networkType,
        networkName,
        measurementDate,
        device,
        loopModeUuid,
        userExperienceMetrics,
        jitterMs,
        packetLossPercents
      ];
}
