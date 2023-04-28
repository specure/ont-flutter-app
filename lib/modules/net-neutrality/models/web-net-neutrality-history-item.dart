import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-item.dart';

part 'web-net-neutrality-history-item.g.dart';

@JsonSerializable()
class WebNetNeutralityHistoryItem extends NetNeutralityHistoryItem {
  final String url;
  final num timeout;
  final int? actualStatusCode;
  final int expectedStatusCode;
  final bool timeoutExceeded;

  WebNetNeutralityHistoryItem(
      {required this.url,
      required this.timeout,
      this.actualStatusCode,
      required this.expectedStatusCode,
      required this.timeoutExceeded,
      required String clientUuid,
      required int durationNs,
      required String measurementDate,
      required String openTestUuid,
      required String testStatus,
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

  factory WebNetNeutralityHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$WebNetNeutralityHistoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$WebNetNeutralityHistoryItemToJson(this);

  @override
  List<Object?> get props => [
        url,
        timeout,
        actualStatusCode,
        expectedStatusCode,
        timeoutExceeded,
        clientUuid,
        durationNs,
        measurementDate,
        openTestUuid,
        testStatus,
        type,
        uuid,
        device,
        networkName,
        networkType,
        operator,
        location
      ];
}
