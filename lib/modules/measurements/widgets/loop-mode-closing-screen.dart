import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class LoopModeClosingWarning extends StatelessWidget {
  final String title;
  final String subtitle;
  final String negativeButtonText;
  final String positiveButtonText;
  final Function()? positiveButtonAction;
  final Function()? negativeButtonAction;

  LoopModeClosingWarning(
      {required this.title,
      required this.subtitle,
      required this.negativeButtonText,
      required this.positiveButtonText,
      this.positiveButtonAction,
      this.negativeButtonAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text(
                title.translated,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: NTDimensions.textL,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: Text(
                subtitle.translated,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: NTDimensions.textM,
                    fontWeight: FontWeight.w500,
                    height: 1.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: OutlinedButton(
                  onPressed: negativeButtonAction,
                  child: Text(
                    negativeButtonText.translated,
                    style: TextStyle(
                      fontSize: NTDimensions.textM,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      minimumSize: Size(206, 49),
                      foregroundColor: NTColors.primary,
                      side: BorderSide(color: NTColors.primary, width: 2))),
            ),
            FilledButton(
                onPressed: positiveButtonAction,
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: NTColors.primary,
                    minimumSize: Size(206, 49)),
                child: Text(
                  positiveButtonText.translated,
                  style: TextStyle(
                    fontSize: NTDimensions.textM,
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
