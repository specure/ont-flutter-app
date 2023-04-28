import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

import '../../../core/widgets/conditional-content.dart';

class MeasurementResultItem extends StatelessWidget {
  const MeasurementResultItem({
    Key? key,
    required this.name,
    required this.unit,
    this.value,
    this.medianValue,
    required this.showMedianValue,
  }) : super(key: key);

  final String name;
  final String unit;
  final String? value;
  final String? medianValue;
  final bool showMedianValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "${name.translated} (${unit.translated})",
              style: TextStyle(
                color: NTColors.progressItem,
                fontSize: NTDimensions.textS,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value ?? "-",
              textAlign: TextAlign.end,
              style: TextStyle(
                color: NTColors.progressItem,
                fontSize: NTDimensions.textS,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ConditionalContent(
              conditional: showMedianValue,
              truthyBuilder: () => Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    medianValue ?? "-",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: NTColors.pale,
                      fontSize: NTDimensions.textS,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}
