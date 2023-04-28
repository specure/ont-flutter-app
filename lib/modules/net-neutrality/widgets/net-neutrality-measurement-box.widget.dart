import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-box.widget.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';

class NetNeutralityMeasurementBox extends MeasurementBox {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetNeutralityCubit, NetNeutralityState>(
      builder: builder,
    );
  }

  @override
  Widget getBoxText(state, boxSideLength) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: getSpeedWidgets(state),
      );
}
