import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/modules/map/models/technology.item.dart';

class TechnologyButton extends StatelessWidget {
  final TechnologyItem technology;
  final bool active;
  final Function(TechnologyItem)? onTechnologyTap;

  TechnologyButton({
    required this.technology,
    required this.active,
    this.onTechnologyTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTechnologyTap != null ? () => onTechnologyTap!(technology) : null,
      child: Container(
        height: 32,
        width: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? technology.color
              : NTColors.measurementBoxGradient1.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Text(
          technology.title.translated,
          style: TextStyle(
            fontSize: NTDimensions.textS,
            color: active ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
