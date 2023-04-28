import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-item.dart';

class NetNeutralityStatusIcon extends StatelessWidget {
  const NetNeutralityStatusIcon({
    Key? key,
    required this.item,
  }) : super(key: key);

  final NetNeutralityHistoryItem? item;

  @override
  Widget build(BuildContext context) {
    Widget icon = Container(
      width: 16,
      height: 16,
    );
    if (item?.testStatus == NetNeutralityTestStatus.SUCCEED) {
      icon = Icon(Icons.check_circle, color: Colors.lightGreen, size: 16);
    } else if (item != null) {
      icon =
          Icon(Icons.highlight_remove_rounded, color: Colors.black38, size: 16);
    }
    return Padding(
      padding: EdgeInsets.only(right: 4),
      child: icon,
    );
  }
}
