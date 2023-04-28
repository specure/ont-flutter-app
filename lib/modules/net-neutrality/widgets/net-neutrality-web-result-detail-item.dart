import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/web-net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/net-neutrality-status-icon.widget.dart';
import 'package:sprintf/sprintf.dart';

class NetNeutralityWebTestItemWidget extends StatelessWidget {
  final WebNetNeutralityHistoryItem item;
  final FlexFit flexFit;

  NetNeutralityWebTestItemWidget({
    required this.item,
    required this.flexFit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetNeutralityStatusIcon(item: item),
            Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Text(
                  item.url,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: NTDimensions.textXS,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  sprintf("%s ms", [(item.durationNs ~/ 1000000)]),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: NTDimensions.textM,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  _getStatusCode(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: NTDimensions.textM,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            Container(
              width: 16,
            )
          ],
        ),
        ConditionalContent(
          conditional: item.testStatus != NetNeutralityTestStatus.SUCCEED,
          truthyBuilder: () => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              NetNeutralityStatusIcon(item: null),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    "Expected".translated,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: NTDimensions.textXXS,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Text(
                    sprintf("< %s ms", [(item.timeout * 1000)]),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: NTDimensions.textXXS,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Text(
                    item.expectedStatusCode.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: NTDimensions.textXXS,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              Container(
                width: 16,
              )
            ],
          ),
        ),
      ],
    );
  }

  String _getStatusCode() {
    if (item.actualStatusCode != null) {
      return item.actualStatusCode.toString();
    } else {
      return "-";
    }
  }
}
