import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'measurement-history-result.dart';

part 'measurement-history-results.g.dart';

@JsonSerializable()
class MeasurementHistoryResults with EquatableMixin {

  double? _calculatedMedianJitterMs;
  double? _calculatedMedianPacketLossPercents;
  double? _calculatedMedianDownloadKbps;
  double? _calculatedMedianUploadKbps;
  double? _calculatedMedianPingMs;

  final List<MeasurementHistoryResult> tests;

  MeasurementHistoryResults(
    this.tests
  );

  get isLoopMeasurement => tests.length > 1 && tests[0].loopModeUuid != null;

  String? get measurementDate => tests.isNotEmpty ? tests[0].measurementDate : null;

  get jitterMs {
    if (_calculatedMedianJitterMs == null) {
      List<double> values = tests.expand((element) => {element.jitterMs}).toList().whereType<double>().toList();
      values.sort();
      _calculatedMedianJitterMs = _calculateMedian(values);
    }
    return _calculatedMedianJitterMs;
  }

  double? get packetLossPercents {
    if (_calculatedMedianPacketLossPercents == null) {
      List<double> values = tests.expand((element) => {element.packetLossPercents}).toList().whereType<double>().toList();
      values.sort();
      _calculatedMedianPacketLossPercents = _calculateMedian(values);
    }
    return _calculatedMedianPacketLossPercents;
  }

  double? get downloadKbps {
    if (_calculatedMedianDownloadKbps == null) {
      List<double> values = tests.expand((element) => {element.downloadKbps}).toList().whereType<double>().toList();
      values.sort();
      _calculatedMedianDownloadKbps = _calculateMedian(values);
    }
    return _calculatedMedianDownloadKbps;
  }

  double? get uploadKbps {
    if (_calculatedMedianUploadKbps == null) {
      List<double> values = tests.expand((element) => {element.uploadKbps}).toList().whereType<double>().toList();
      values.sort();
      _calculatedMedianUploadKbps = _calculateMedian(values);
    }
    return _calculatedMedianUploadKbps;
  }

  double? get pingMs {
    if (_calculatedMedianPingMs == null) {
      List<double> values = tests.expand((element) => {element.pingMs}).toList().whereType<double>().toList();
      values.sort();
      _calculatedMedianPingMs = _calculateMedian(values);
    }
    return _calculatedMedianPingMs;
  }

  double? _calculateMedian(List values) {
    if (values.isNotEmpty) {
      if (values.length % 2 == 0) {
        int lowerIndex = (values.length / 2 - 1).toInt();
        return (values[lowerIndex] + values[lowerIndex + 1]) / 2;
      } else {
        int middleIndex = values.length ~/ 2;
        return values[middleIndex];
      }
    } else {
      return null;
    }
  }

  factory MeasurementHistoryResults.fromJson(Map<String, dynamic> json) =>
      _$MeasurementHistoryResultsFromJson(json);

  Map<String, dynamic> toJson() => _$MeasurementHistoryResultsToJson(this);

  @override
  List<Object?> get props => [
       tests
      ];
}
