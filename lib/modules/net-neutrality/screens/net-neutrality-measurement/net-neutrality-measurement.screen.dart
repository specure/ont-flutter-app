import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/net-neutrality-measurement-box.widget.dart';

class NetNeutralityMeasurementScreen extends StatelessWidget {
  static const route = 'net-neutrality/measurement';

  const NetNeutralityMeasurementScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetNeutralityCubit, NetNeutralityState>(
      builder: (context, state) => Scaffold(
        appBar: NTAppBar(
          actions: [
            IconButton(
                onPressed: () {
                  GetIt.I.get<NetNeutralityCubit>().stopMeasurement();
                },
                icon: Icon(
                  Icons.close,
                  color: NTColors.primary,
                )),
          ],
          titleText: 'Net Neutrality',
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(36, 16, 36, 52),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [NetNeutralityMeasurementBox()],
            ),
          ),
        ),
      ),
    );
  }
}
