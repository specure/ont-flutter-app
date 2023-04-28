import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/results-metadata/impl/nn-results-metadata-landscape-config.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/results-metadata/impl/nn-results-metadata-portrait-config.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/results-metadata/nn-results-metadata-config.dart';

class NetNeutralityResultsMetadataView extends StatelessWidget {
  final bool navFinished;

  const NetNeutralityResultsMetadataView({required this.navFinished});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetNeutralityCubit, NetNeutralityState>(
        builder: (context, state) =>
            NTOrientationBuilder<NetNeutralityResultsMetadataConfig>(
              portraitConfig: NetNeutralityResultsMetadataPortraitConfig(state),
              landscapeConfig: NetNeutralityResultsMetadataLandscapeConfig(state),
              builder: (config) => config.getContent(navFinished),
            ));
  }
}
