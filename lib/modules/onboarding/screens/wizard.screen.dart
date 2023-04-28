import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/modules/onboarding/store/wizard.cubit.dart';
import 'package:nt_flutter_standalone/modules/onboarding/store/wizard.state.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/wizard-accuracy/wizard-accuracy.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/wizard-rotated-gradient-box.widget.dart';

class WizardScreen extends StatelessWidget {
  static const route = 'onboarding/wizard';

  const WizardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WizardCubit>(
      create: (context) => GetIt.I.get<WizardCubit>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: null,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            WizardRoratedGradientBox(),
            SafeArea(
              child: BlocBuilder<WizardCubit, WizardState>(
                builder: (context, state) => WizardAccuracy(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
