import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.borderRadius,
    this.height = 60,
    this.width = 245,
    this.colors,
    this.rippleColor,
  }) : super(key: key);

  final double? borderRadius;
  final void Function()? onPressed;
  final Widget child;
  final double? height;
  final double? width;
  final List<Color>? colors;
  final Color? rippleColor;

  BorderRadius get _borderRadius =>
      BorderRadius.circular(borderRadius ?? height! / 2);

  List<Color> get _colors {
    if (colors == null) {
      return [
        NTColors.startTestButtonGradient1,
        NTColors.startTestButtonGradient2,
      ];
    }
    if (colors!.length == 1) {
      return [colors![0], colors![0]];
    }
    return colors!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: _colors),
          borderRadius: _borderRadius,
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Center(
            child: child,
          ),
          style: TextButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: _borderRadius,
            ),
            foregroundColor: rippleColor ?? NTColors.primary.withOpacity(.033),
          ),
        ),
      ),
    );
  }
}
