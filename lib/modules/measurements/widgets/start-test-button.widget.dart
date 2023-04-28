import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/gradient-button.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';

class StartTestButton extends StatelessWidget {
  const StartTestButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementsBloc, MeasurementsState>(
        builder: (context, state) {
      return ConditionalContent(
        conditional: state.isInitializing || state.isContinuing,
        truthyBuilder: () => Container(
          padding: EdgeInsets.only(top: 18, bottom: 18),
          height: 60,
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: NTColors.measurementCircularProgress,
              strokeWidth: 2,
            ),
          ),
        ),
        falsyBuilder: () => GradientButton(
          child: Text(
            "Run speed measurements".translated,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: NTDimensions.textM,
            ),
          ),
          onPressed: () {
            if (!(state.isInitializing || state.isContinuing)) {
              GetIt.I.get<MeasurementsBloc>().add(StartMeasurement());
            }
          },
        ),
      );
    });
  }
}
