import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/loop-mode-execution-warning.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-body/impl/measurement-body-landscape.config.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-body/impl/measurement-body-portrait.config.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-body/measurement-body.config.dart';

class MeasurementBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementsBloc, MeasurementsState>(
        builder: (context, state) =>
            NTOrientationBuilder<MeasurementBodyConfig>(
                portraitConfig: MeasurementBodyPortraitConfig(state),
                landscapeConfig: MeasurementBodyLandscapeConfig(state),
                builder: (config) => Column(
                      children: [
                        Expanded(
                          child: config.getContent(),
                        ),
                        ConditionalContent(
                          conditional: state.loopModeDetails.isLoopModeActive,
                          truthyBuilder: () => LoopModeExecutionWarning(),
                        )
                      ],
                    )));
  }
}
