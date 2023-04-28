import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.state.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/results-metadata/results-metadata-config.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/results-metadata/impl/results-metadata-landscape-config.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/results-metadata/impl/results-metadata-portrait-config.dart';

class ResultsMetadataView extends StatelessWidget {
  final bool navFinished;

  const ResultsMetadataView({required this.navFinished});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementResultCubit, MeasurementResultState>(
        builder: (context, state) =>
            NTOrientationBuilder<ResultsMetadataConfig>(
              portraitConfig: ResultsMetadataPortraitConfig(state),
              landscapeConfig: ResultsMetadataLandscapeConfig(state),
              builder: (config) => config.getContent(navFinished),
            ));
  }
}
