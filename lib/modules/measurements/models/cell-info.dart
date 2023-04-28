import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cell-info.g.dart';

@JsonSerializable()
class CellInfoModel with EquatableMixin {
  @JsonKey(name: 'active')
  final bool active;
  @JsonKey(name: 'registered')
  final bool registered;
  @JsonKey(name: 'area_code')
  final int? areaCode;
  @JsonKey(name: 'channel_number')
  final int? channelNumber;
  @JsonKey(name: 'primary_data_subscription')
  final bool? primaryDataSubscription;
  @JsonKey(name: 'location_id')
  final int? locationId;
  @JsonKey(name: 'mcc')
  final int? mcc;
  @JsonKey(name: 'mnc')
  final int? mnc;
  @JsonKey(name: 'primary_scrambling_code')
  final int? primaryScramblingCode;
  @JsonKey(name: 'technology')
  final String? technology;
  @JsonKey(name: 'uuid')
  final String? uuid;

  CellInfoModel({
    required this.active,
    required this.registered,
    this.areaCode,
    this.channelNumber,
    this.primaryDataSubscription,
    this.locationId,
    this.mcc,
    this.mnc,
    this.primaryScramblingCode,
    this.technology,
    this.uuid,
  });

  factory CellInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CellInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$CellInfoModelToJson(this);

  @override
  List<Object?> get props => [
    this.active,
    this.registered,
    this.areaCode,
    this.channelNumber,
    this.primaryDataSubscription,
    this.locationId,
    this.mcc,
    this.mnc,
    this.primaryScramblingCode,
    this.technology,
    this.uuid,
  ];
}