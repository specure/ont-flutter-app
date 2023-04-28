import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'dart:math';

class WizardRoratedGradientBox extends StatelessWidget {
  const WizardRoratedGradientBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -34,
      right: -78,
      child: Transform.rotate(
        angle: pi / 6,
        child: Container(
          height: 146,
          width: 304,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                NTColors.startTestButtonGradient1,
                NTColors.startTestButtonGradient2,
              ],
            ),
            borderRadius: BorderRadius.circular(73),
          ),
        ),
      ),
    );
  }
}
