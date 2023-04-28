import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/int.ext.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:sprintf/sprintf.dart';

class MeasurementLoopNextTestInfo extends StatelessWidget {
  const MeasurementLoopNextTestInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementsBloc, MeasurementsState>(
        builder: (context, state) => SizedBox(
              width: 300,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text(
                          "Time to next test".translated.toUpperCase(),
                          style: TextStyle(
                            color: NTColors.pale,
                            fontSize: NTDimensions.textS,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "Movement".translated.toUpperCase(),
                        style: TextStyle(
                          color: NTColors.pale,
                          fontSize: NTDimensions.textS,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            sprintf("%s min", [
                              state
                                  .loopModeDetails.currentTimeToNextTestSeconds.formatSecondsToMinutesAndSeconds()
                            ]),
                            style: TextStyle(
                              color: NTColors.progressItem,
                              fontSize: NTDimensions.textS,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            sprintf("%d/%dm", [
                              state.loopModeDetails
                                  .currentDistanceMetersPassedFromLastTest,
                              state.loopModeDetails.targetDistanceMetersToNextTest
                            ]),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: NTColors.progressItem,
                              fontSize: NTDimensions.textS,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
