import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';

import '../screens/measurement.screen.dart';

class MeasurementProgressBar extends StatefulWidget {
  const MeasurementProgressBar({Key? key}) : super(key: key);

  @override
  _MeasurementProgressBarState createState() => _MeasurementProgressBarState();
}

class _MeasurementProgressBarState extends State<MeasurementProgressBar>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<MeasurementsState> _progressSub;
  late final AnimationController _controller;
  Animation<double>? _progressAnimation;

  @override
  void dispose() {
    _progressSub.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: MeasurementScreen.defaultTestDuration),
    );
    _progressSub = GetIt.I
        .get<MeasurementsBloc>()
        .stream
        .distinct((a, b) => a.phase == b.phase)
        .listen(_updateProgressTween);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 54,
      ),
      child: SizedBox(
        height: 2,
        child: LinearProgressIndicator(
          color: NTColors.measurementProgressBar,
          backgroundColor: Colors.black.withOpacity(0.1),
          value: _progressAnimation?.value ?? 0,
        ),
      ),
    );
  }

  _updateProgressTween(MeasurementsState? state) {
    _controller.reset();
    if (state != null &&
        state.phase != MeasurementPhase.none &&
        state.phase != MeasurementPhase.fetchingTestParams) {
      double beginProgress = state.prevPhase.progress;
      double endProgress = state.phase.progress;
      // When opened from background:
      if (state.prevPhase == state.phase) {
        beginProgress = state.phase.index / MeasurementPhase.values.length;
        endProgress = (state.phase.index + 1) / MeasurementPhase.values.length;
      }
      _progressAnimation = Tween<double>(
        begin: beginProgress,
        end: endProgress,
      ).animate(_controller)
        ..addListener(() {
          setState(() {});
        });
      _controller.forward();
    }
  }
}
