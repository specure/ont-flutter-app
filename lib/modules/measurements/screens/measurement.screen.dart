import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/loop-mode.button.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/loop-mode-closing-screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-body/measurement-body.widget.dart';
import 'package:sprintf/sprintf.dart';

import '../widgets/loop-waiting/loop-waiting-body.widget.dart';

class MeasurementScreen extends StatefulWidget {
  static const route = 'measurements/measurement';
  static const defaultTestDuration = 7;

  const MeasurementScreen({Key? key}) : super(key: key);

  @override
  _MeasurementScreenState createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  late StreamSubscription _continuationSub;
  final MeasurementsBloc _bloc = GetIt.I.get<MeasurementsBloc>();

  @override
  void dispose() {
    _continuationSub.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _continuationSub = _bloc.stream
        .distinct((a, b) => a.isContinuing == b.isContinuing)
        .listen((state) {
      if (!state.isContinuing) {
        _bloc.add(SetMeasurmentScreenOpen(false));
        GetIt.I.get<NavigationService>().goBack();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementsBloc, MeasurementsState>(
        builder: (context, state) => WillPopScope(
              onWillPop: () async {
                onClosePressed(state);
                return false;
              },
              child: Stack(
                children: [
                  Scaffold(
                      appBar: NTAppBar(
                        actions: [
                          ConditionalContent(
                              conditional:
                                  state.loopModeDetails.isLoopModeActive,
                              truthyBuilder: () => Container(
                                  margin: EdgeInsets.only(top: 24, bottom: 24),
                                  child: LoopModeButton(
                                      enabled: true, width: 24, iconSize: 16))),
                          IconButton(
                              onPressed: () {
                                onClosePressed(state);
                              },
                              icon: Icon(
                                Icons.close,
                                color: NTColors.primary,
                              )),
                        ],
                        titleText: state.loopModeDetails.isLoopModeActive
                            ? sprintf("Loop Measurement %d of %d".translated, [
                                state.loopModeDetails
                                    .currentNumberOfTestsStarted,
                                state.loopModeDetails.targetNumberOfTests
                              ])
                            : 'Speed Measurement',
                      ),
                      body: ConditionalContent(
                        conditional: state.loopModeDetails.isLoopModeActive &&
                            !state.loopModeDetails.isLoopModeFinished &&
                            !state.loopModeDetails.isTestRunning,
                        truthyBuilder: () => LoopWaitingBody(),
                        falsyBuilder: () => MeasurementBody(),
                      )),
                  ConditionalContent(
                      conditional: state.leavingScreenShown,
                      truthyBuilder: () => Scaffold(
                            body: LoopModeClosingWarning(
                                title: "Are you sure?",
                                subtitle:
                                    "Are you sure you want to stop the loop mode measurement? Unfinished measurements will not be saved to your results.",
                                positiveButtonText: "Yes, abort measurement",
                                negativeButtonText: "No, continue",
                                positiveButtonAction:
                                    GetIt.I<MeasurementsBloc>().stopMeasurement,
                                negativeButtonAction: () => {
                                      GetIt.I<MeasurementsBloc>()
                                          .setCloseDialogVisible(false),
                                    }),
                          ))
                ],
              ),
            ));
  }

  void onClosePressed(MeasurementsState state) {
    if (state.loopModeDetails.isLoopModeActive) {
      GetIt.I<MeasurementsBloc>().setCloseDialogVisible(true);
    } else {
      GetIt.I.get<MeasurementsBloc>().add(StopMeasurement());
    }
  }
}
