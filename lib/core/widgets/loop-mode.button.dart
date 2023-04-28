import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';

class LoopModeButton extends StatelessWidget {
  final String? title;
  final Function()? onPressed;
  final double? width;
  final double? iconSize;
  final bool enabled;

  LoopModeButton({
    this.title,
    this.onPressed,
    this.width,
    this.iconSize,
    this.enabled = false
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed != null ? onPressed : null,
      child: Container(
        width: width,
        height: this.iconSize != null ? this.iconSize! * 1.5 : 40,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: this.iconSize != null ? 0 : 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: enabled ? NTColors.tertiary : Colors.black26,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
              alignment: Alignment.center,
              transformHitTests: false,
              child: Icon(Icons.autorenew, size: iconSize, color: Colors.black)),
            ConditionalContent(
              conditional: title != null && title?.isNotEmpty == true,
              truthyBuilder: () {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    title?.translated ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              })
          ],
        ),
      ),
    );
  }
}
