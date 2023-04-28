import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final double? width;
  final bool enabled;

  PrimaryButton({
    required this.title,
    required this.onPressed,
    this.width,
    this.enabled = true
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      child: Container(
        width: width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: enabled ? NTColors.primary : NTColors.lightBackground,
        ),
        child: Text(
          title.translated,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
