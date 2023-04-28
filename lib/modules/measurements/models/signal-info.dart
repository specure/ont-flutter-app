import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signal-info.g.dart';

@JsonSerializable()
class SignalInfo with EquatableMixin {
  @JsonKey(name: 'cell_uuid')
  final String? cellUuid;
  @JsonKey(name: 'network_type_id')
  final int? networkTypeId;
  @JsonKey(name: 'time_ns_last')
  final int? timeNsLast;
  @JsonKey(name: 'time_ns')
  final int? timeNs;
  @JsonKey(name: 'timing_advance')
  final int? timingAdvance;
  @JsonKey(name: 'lte_cqi')
  final int? lteCqi;
  @JsonKey(name: 'lte_rsrp')
  final double? lteRsrp;
  @JsonKey(name: 'lte_rsrq')
  final double? lteRsrq;
  @JsonKey(name: 'lte_rssnr')
  final double? lteRssnr;
  @JsonKey(name: 'signal')
  final int? signal;
  @JsonKey(name: 'band')
  final String? band;
  @JsonKey(name: 'technology')
  final String? technology;
  @JsonKey(name: 'isPrimaryCell')
  final bool? isPrimaryCell;

  SignalInfo({
    this.cellUuid,
    this.networkTypeId,
    this.timeNsLast,
    this.timeNs,
    this.timingAdvance,
    this.lteCqi,
    this.lteRsrp,
    this.lteRsrq,
    this.lteRssnr,
    this.signal,
    this.band,
    this.technology,
    this.isPrimaryCell,
  });

  SignalInfo copyWithTimeNs({
    int? timeNs,
    int? timeNsLast,
  }) {
    return SignalInfo(
      cellUuid: this.cellUuid,
      networkTypeId: this.networkTypeId,
      timeNsLast: timeNsLast ?? this.timeNsLast,
      timeNs: timeNs ?? this.timeNs,
      timingAdvance: this.timingAdvance,
      lteCqi: this.lteCqi,
      lteRsrp: this.lteRsrp,
      lteRsrq: this.lteRsrq,
      lteRssnr: this.lteRssnr,
      signal: this.signal,
      band: this.band,
      technology: this.technology,
      isPrimaryCell: this.isPrimaryCell,
    );
  }

  factory SignalInfo.fromJson(Map<String, dynamic> json) =>
      _$SignalInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SignalInfoToJson(this);

  @override
  List<Object?> get props => [
    this.cellUuid,
    this.networkTypeId,
    this.timeNsLast,
    this.timeNs,
    this.timingAdvance,
    this.lteCqi,
    this.lteRsrp,
    this.lteRsrq,
    this.lteRssnr,
    this.signal,
    this.band,
    this.technology,
    this.isPrimaryCell,
  ];
}