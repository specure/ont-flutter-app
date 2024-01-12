import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nt_flutter_standalone/core/widgets/basic.bottom-sheet.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/bottom-sheet/bottom-sheet-config.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/bottom-sheet/impl/bottom-sheet-landscape-config.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/bottom-sheet/impl/bottom-sheet-portrait-config.dart';

class HomeBottomSheet extends DraggableScrollableSheet {
  static double _estimateMaxHeight(
      BuildContext context, MeasurementsState state) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return 1;
    }
    final estimatedHeightInPx =
        state.project?.enableAppPrivateIp == true ? 580 : 366;
    final screenHeight = MediaQuery.of(context).size.height;
    return min(1, estimatedHeightInPx / screenHeight);
  }

  static double _estimateMinHeight(
      BuildContext context, MeasurementsState state) {
    return min(0.2, HomeBottomSheet._estimateMaxHeight(context, state) - 0.1);
  }

  static Widget _build(_, controller) {
    return BasicBottomSheet(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: BlocBuilder<MeasurementsBloc, MeasurementsState>(
        builder: (context, state) => NTOrientationBuilder<BottomSheetConfig>(
          portraitConfig: BottomSheetPortraitConfig(state, context),
          landscapeConfig: BottomSheetLandscapeConfig(state, context),
          builder: (config) => SingleChildScrollView(
            child: config.getContent(),
          ),
        ),
      ),
    );
  }

  HomeBottomSheet(context, state)
      : super(
          initialChildSize: HomeBottomSheet._estimateMaxHeight(context, state),
          minChildSize: HomeBottomSheet._estimateMinHeight(context, state),
          maxChildSize: HomeBottomSheet._estimateMaxHeight(context, state),
          expand: false,
          builder: HomeBottomSheet._build,
        );
}
