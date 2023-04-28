import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/gradient-button.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/screens/wizard.screen.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GradientButton(
        child: Text(
          "Next".translated,
          style: TextStyle(
            color: Colors.white,
            fontSize: NTDimensions.textM,
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, WizardScreen.route);
        },
        width: 125,
      ),
    );
  }
}
