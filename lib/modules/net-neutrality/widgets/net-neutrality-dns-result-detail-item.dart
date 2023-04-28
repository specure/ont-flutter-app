import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/net-neutrality-status-icon.widget.dart';
import 'package:sprintf/sprintf.dart';

class NetNeutralityDnsTestItemWidget extends StatelessWidget {
  final DnsNetNeutralityHistoryItem item;
  final FlexFit flexFit;

  NetNeutralityDnsTestItemWidget({
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.target ?? "-",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: NTDimensions.textXS,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Resolver".translated +
                          ": " +
                          (item.actualResolver ?? "-"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: NTDimensions.textXS,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                flex: 2,
                fit: FlexFit.tight,
                child: Text(
                  _getFirstResolvedAddress(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: NTDimensions.textXS,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                _dnsResultStatusToUI(item.actualDnsStatus),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: NTDimensions.textS,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
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
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    _getExpectedAddress(),
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
                    _dnsResultStatusToUI(item.expectedDnsStatus),
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

  String _dnsResultStatusToUI(String? dnsResult) {
    switch (dnsResult) {
      case "NOERROR":
        return "No error".translated;
      case "NXDOMAIN":
        return "Does not exist".translated;
      default:
        return "-";
    }
  }

  String _getFirstResolvedAddress() {
    if (item.actualDnsResultEntriesFound?.isNotEmpty == true) {
      var addresses = item.actualDnsResultEntriesFound?.split(';');
      if (addresses?.isNotEmpty == true) {
        return addresses?.first ?? "-";
      } else {
        return "-";
      }
    } else {
      return "-";
    }
  }

  String _getExpectedAddress() {
    if (item.expectedDnsResultEntriesFound?.isNotEmpty == true) {
      var addresses = item.expectedDnsResultEntriesFound?.split(';');
      var firstResolved = _getFirstResolvedAddress();
      if (addresses?.isNotEmpty == true) {
        if (item.failReason == DnsTestFailReason.DIFFERENT_IP_ADDRESS) {
          return addresses!.firstWhere(
            (element) => element != firstResolved,
            orElse: () => addresses.first,
          );
        } else {
          return addresses!.firstWhere(
            (element) => element == firstResolved,
            orElse: () => addresses.first,
          );
        }
      } else {
        return "-";
      }
    } else {
      return "-";
    }
  }
}
