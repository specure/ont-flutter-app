import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class LoopModeExecutionWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      child: Container(
        height: 98,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Icon(
                Icons.warning_amber_outlined,
                color: NTColors.tertiary,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  "Due to operating system restrictions, the loop mode will stop if you navigate away from the screen or close the application."
                      .translated,
                  style: TextStyle(
                      fontSize: NTDimensions.textM,
                      fontWeight: FontWeight.w500,
                      height: 1.5),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
