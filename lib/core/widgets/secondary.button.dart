import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final double? width;

  SecondaryButton({
    required this.title,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: NTColors.primary),
          color: Colors.white,
        ),
        child: Text(
          title.translated,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: NTColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
