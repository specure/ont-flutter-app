import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';

class LearnMoreButton extends StatelessWidget {
  final String title;

  LearnMoreButton({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton(
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: NTDimensions.textS,
                color: NTColors.primary,
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Icon(Icons.info_outline, color: NTColors.primary))
          ],
        ),
        onPressed: () {},
        style: TextButton.styleFrom(textStyle: TextStyle(color: Colors.white)),
      ),
    );
  }
}
