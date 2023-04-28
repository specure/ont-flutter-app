import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';

import '../../measurement-result/models/measurement-history-results.dart';

part 'history.g.dart';

@JsonSerializable()
class History {
  List<MeasurementHistoryResults> content;
  final int totalElements;
  final int totalPages;
  final bool last;

  History({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  List<MeasurementHistoryResult> getFlatResult() {
    List<MeasurementHistoryResult> singleTests = <MeasurementHistoryResult>[];
    singleTests = content.expand((element) => [...element.tests]).toList();
    return singleTests;
  }

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}