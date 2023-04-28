import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-item.dart';

part 'dns-net-neutrality-history-item.g.dart';

@JsonSerializable()
class DnsNetNeutralityHistoryItem extends NetNeutralityHistoryItem {
  final num timeout;
  final String? actualDnsStatus;
  final String? expectedDnsStatus;
  final String? entryType;
  final String? actualResolver;
  final String? expectedResolver;
  final String? target;
  final String? actualDnsResultEntriesFound;
  final String? expectedDnsResultEntriesFound;
  final bool timeoutExceeded;
  final String? failReason;

  DnsNetNeutralityHistoryItem(
      {required this.timeout,
      required this.entryType,
      required this.actualDnsStatus,
      required this.expectedDnsStatus,
      required this.expectedResolver,
      required this.actualResolver,
      required this.target,
      required this.actualDnsResultEntriesFound,
      required this.expectedDnsResultEntriesFound,
      required this.timeoutExceeded,
      required this.failReason,
      required String measurementDate,
      required String testStatus,
      required int durationNs,
      required String clientUuid,
      required String openTestUuid,
      required String type,
      required String uuid,
      required String? device,
      required String? networkType,
      required String? networkName,
      required LocationModel? location,
      required String? operator})
      : super(
            clientUuid: clientUuid,
            durationNs: durationNs,
            measurementDate: measurementDate,
            openTestUuid: openTestUuid,
            testStatus: testStatus,
            type: type,
            uuid: uuid,
            device: device,
            networkType: networkType,
            networkName: networkName,
            location: location,
            operator: operator);

  factory DnsNetNeutralityHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$DnsNetNeutralityHistoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$DnsNetNeutralityHistoryItemToJson(this);

  @override
  List<Object?> get props => [
        timeout,
        entryType,
        actualDnsStatus,
        expectedDnsStatus,
        actualResolver,
        expectedResolver,
        target,
        actualDnsResultEntriesFound,
        expectedDnsResultEntriesFound,
        timeoutExceeded,
        measurementDate,
        testStatus,
        failReason,
        durationNs,
        clientUuid,
        openTestUuid,
        type,
        uuid,
        device,
        networkName,
        networkType,
        operator,
        location
      ];
}
