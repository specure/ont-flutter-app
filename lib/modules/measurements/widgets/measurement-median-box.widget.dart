import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/models/basic-measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';

import 'measurement-box.widget.dart';

class MeasurementMedianBox extends MeasurementBox {
  @override
  final frameColors = [
    Colors.black.withOpacity(0.1),
    Colors.black.withOpacity(0.1),
  ];
  @override
  final backgroundColor = Colors.black.withOpacity(0.1);
  @override
  final progressColor = Colors.black.withOpacity(0.1);
  @override
  final textColor = NTColors.title;

  MeasurementMedianBox({
    Key? key,
  }) : super(key: key);

  @override
  String getPhaseName(BasicMeasurementState state) {
    return "Median".translated.toUpperCase();
  }

  @override
  String getFormattedState(BasicMeasurementState state) {
    return state.formattedMedianPhaseResult;
  }

  @override
  bool isSpeedPhase(MeasurementsState state) {
    return true;
  }

  @override
  String getPhaseUnits(BasicMeasurementState state) {
    return state.medianPhaseUnits;
  }
}
