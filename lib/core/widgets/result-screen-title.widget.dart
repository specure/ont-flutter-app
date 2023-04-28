import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';

class ResultScreenTitle extends StatelessWidget {
  final String units;
  final String value;

  ResultScreenTitle({
    Key? key,
    required this.value,
    required this.units,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(
              child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              value,
              style: TextStyle(fontSize: NTDimensions.textS * 4),
            ),
          )),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                units,
                style: TextStyle(fontSize: NTDimensions.textM * 2),
              ),
            ),
          ),
        ]);
  }
}
