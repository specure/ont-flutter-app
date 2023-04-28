import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/cell-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/signal-info.dart';

part 'radio-info.g.dart';

@JsonSerializable()
class RadioInfo {
  final List<CellInfoModel> cells;
  final List<SignalInfo> signals;

  RadioInfo({
    required this.cells,
    required this.signals,
  });

  factory RadioInfo.fromJson(Map<String, dynamic> json) =>
      _$RadioInfoFromJson(json);
  Map<String, dynamic> toJson() => _$RadioInfoToJson(this);
}