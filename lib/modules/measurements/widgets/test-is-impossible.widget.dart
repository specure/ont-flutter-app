import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class TestIsImpossible extends StatelessWidget {
  const TestIsImpossible({Key? key, this.message = "No internet connection"})
      : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message.translated,
          style: TextStyle(
            fontSize: NTDimensions.title,
            color: NTColors.title,
            height: 1.67,
          ),
        ),
        Text(
          "No test is possible".translated,
          style: TextStyle(
            fontSize: NTDimensions.textL,
            color: NTColors.subtitle,
            height: 1.5,
          ),
        )
      ],
    );
  }
}
