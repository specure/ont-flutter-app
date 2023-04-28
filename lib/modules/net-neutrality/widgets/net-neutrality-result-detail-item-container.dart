import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.state.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/web-net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/net-neutrality-dns-result-detail-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/net-neutrality-web-result-detail-item.dart';

class NetNeutralityTestItemContainerWidget<
        NetNeutralityTestType extends NetNeutralityHistoryItem>
    extends StatelessWidget {
  final NetNeutralityTestType item;
  NetNeutralityTestItemContainerWidget({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
        bloc: GetIt.I.get<HistoryCubit>(),
        builder: (context, state) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Column(children: [
                Container(
                  constraints: BoxConstraints(minHeight: 60),
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: _getCorrectType(),
                ),
                Container(
                  color: Colors.black12,
                  height: 1,
                )
              ]),
            ));
  }

  Widget _getCorrectType() {
    if (item is WebNetNeutralityHistoryItem) {
      return NetNeutralityWebTestItemWidget(
          item: item as WebNetNeutralityHistoryItem, flexFit: FlexFit.loose);
    } else if (item is DnsNetNeutralityHistoryItem) {
      return NetNeutralityDnsTestItemWidget(
          item: item as DnsNetNeutralityHistoryItem, flexFit: FlexFit.loose);
    }
    return Container();
  }
}
