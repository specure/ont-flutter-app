import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/models/basic-measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class MeasurementBox extends StatelessWidget {
  final frameColors = [
    NTColors.measurementBoxGradient1,
    NTColors.measurementBoxGradient2,
  ];
  final backgroundColor = Colors.white;
  final progressColor = NTColors.measurementCircularProgress;
  final textColor = NTColors.measurementBoxText;

  MeasurementBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementsBloc, MeasurementsState>(builder: builder);
  }

  Widget builder(context, state) {
    var boxSideLength = _getBoxSideLength(context);
    double padding = min(24, boxSideLength / 6);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: frameColors,
        ),
      ),
      height: boxSideLength,
      width: boxSideLength,
      child: Padding(
          padding: EdgeInsets.all(1),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                top: 0,
                right: 0,
                child: Container(
                  color: backgroundColor,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(height: padding),
                  ),
                  getBoxText(state, padding),
                  Flexible(
                    child: Container(height: padding),
                  ),
                ],
              )
            ],
          )),
    );
  }

  double _getBoxSideLength(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return min(144, (size.width / 2) - 44);
  }

  Widget getBoxText(state, double boxSideLength) => Column(
        mainAxisAlignment: isSpeedPhase(state)
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: isSpeedPhase(state)
            ? getSpeedWidgets(state)
            : getInitWidgets(state, boxSideLength),
      );

  bool isSpeedPhase(MeasurementsState state) {
    return [
      MeasurementPhase.down,
      MeasurementPhase.up,
      MeasurementPhase.latency,
      MeasurementPhase.jitter,
      MeasurementPhase.packLoss,
    ].contains(state.phase);
  }

  List<Widget> getInitWidgets(
      BasicMeasurementState state, double boxSideLength) {
    return [
      Container(
        margin: EdgeInsets.only(bottom: boxSideLength),
        child: Text(
          getPhaseName(state),
          textAlign: TextAlign.center,
        ),
      ),
      Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: progressColor,
            strokeWidth: 1,
          ),
        ),
      ),
    ];
  }

  String getPhaseName(BasicMeasurementState state) {
    return state.phaseName;
  }

  String getValue(BasicMeasurementState state) {
    return "Median".translated.toUpperCase();
  }

  String getPhaseUnits(BasicMeasurementState state) {
    return state.phaseUnits;
  }

  String getFormattedState(BasicMeasurementState state) {
    return state.formattedPhaseResult;
  }

  List<Widget> getSpeedWidgets(BasicMeasurementState state) {
    return [
      _getColoredText(getPhaseName(state)),
      _getColoredText(
        getFormattedState(state),
        fontSize: NTDimensions.textS * 3,
      ),
      _getColoredText(getPhaseUnits(state)),
    ];
  }

  Widget _getColoredText(String text, {double? fontSize}) {
    if (fontSize == null) {
      fontSize = NTDimensions.textM;
    }
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text.translated,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
        ),
      ),
    );
  }
}
