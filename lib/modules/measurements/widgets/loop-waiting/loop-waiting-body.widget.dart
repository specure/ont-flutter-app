import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';

import 'impl/loop-waiting-body-landscape.config.dart';
import 'impl/loop-waiting-body-portrait.config.dart';
import 'loop-waiting-body.config.dart';

class LoopWaitingBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementsBloc, MeasurementsState>(
        builder: (context, state) =>
            NTOrientationBuilder<LoopWaitingBodyConfig>(
                portraitConfig: LoopWaitingBodyPortraitConfig(state),
                landscapeConfig: LoopWaitingBodyLandscapeConfig(state),
                builder: (config) => config.getContent()));
  }
}
