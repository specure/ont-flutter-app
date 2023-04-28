import 'package:json_annotation/json_annotation.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-result-item.dart';

part 'unknown-net-neutrality-result-item.g.dart';

@JsonSerializable()
class UnknownNetNeutralityResultItem extends NetNeutralityResultItem {

  UnknownNetNeutralityResultItem() : super(
          id: 0,
          openTestUuid: '',
          clientUuid: '',
          durationNs: 0,
          timeoutExceeded: false,
          type: NetNeutralityType.UNKNOWN,
        );

  factory UnknownNetNeutralityResultItem.fromJson(Map<String, dynamic> json) =>
      _$UnknownNetNeutralityResultItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UnknownNetNeutralityResultItemToJson(this);
}
