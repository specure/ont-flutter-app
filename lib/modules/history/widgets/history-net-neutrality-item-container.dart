import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/widgets/history-net-neutrality-item.widget.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.state.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-measurement.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';

class HistoryNetNeutralityItemContainerWidget extends StatelessWidget {
  final NetNeutralityHistoryMeasurement item;

  HistoryNetNeutralityItemContainerWidget({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      bloc: GetIt.I.get<HistoryCubit>(),
      builder: (context, state) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            GetIt.I.get<NetNeutralityCubit>().loadResults(item.openTestUuid);
          },
          child: HistoryNetNeutralityItemWidget(
              item: item, flexFit: FlexFit.loose)),
    );
  }
}
