import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/error.snackbar.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/loop-measurement-result/loop-measurement-result-config.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.state.dart';

import '../../models/measurement-history-results.dart';
import 'impl/loop-measurement-result-landscape-config.dart';
import 'impl/loop-measurement-result-portrait-config.dart';

class LoopMeasurementResultScreen extends StatefulWidget {
  static const route = 'measurements/loop-result';
  static const argumentTestUuid = 'loopUuid';
  static const argumentResult = 'result';

  const LoopMeasurementResultScreen({Key? key}) : super(key: key);

  @override
  State<LoopMeasurementResultScreen> createState() =>
      _LoopMeasurementResultScreenState();
}

class _LoopMeasurementResultScreenState extends State<LoopMeasurementResultScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    GetIt.I.get<MeasurementResultCubit>().init(
          result: arguments?[LoopMeasurementResultScreen.argumentResult],
          testUuid: arguments?[LoopMeasurementResultScreen.argumentTestUuid],
        );
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<MeasurementResultCubit, MeasurementResultState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          current.errorMessage!.isNotEmpty &&
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
            .showSnackBar(NTErrorSnackbar(state.errorMessage!));
      },
      builder: (context, state) => Scaffold(
        appBar: NTAppBar(
          actions: [],
          leading: IconButton(
            onPressed: () => GetIt.I.get<NavigationService>().goBack(),
            icon: Icon(Icons.arrow_back, color: NTColors.primary),
          ),
          titleText: "Loop measurements",
        ),
        body: SafeArea(
          child: ConditionalContent(
            conditional: state.loading == false,
            truthyBuilder: () => _buildLoopResultDetails(state.loopResult, state.project?.enableAppJitterAndPacketLoss ?? false),
            falsyBuilder: () => Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: NTColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  NTOrientationBuilder<LoopMeasurementResultConfig> _buildLoopResultDetails(
      MeasurementHistoryResults? result, bool enabledJitterAndPacketLoss) {
    return NTOrientationBuilder<LoopMeasurementResultConfig>(
        portraitConfig: LoopMeasurementResultPortraitConfig(result, enabledJitterAndPacketLoss),
        landscapeConfig: LoopMeasurementResultLandscapeConfig(result, enabledJitterAndPacketLoss),
        builder: (config) => config.getContent());
  }
}

