import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign alignment;

  const SectionTitle(
    this.text, {
    this.color = Colors.black26,
    this.alignment = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.translated.toUpperCase(),
      textAlign: alignment,
      maxLines: 1,
      overflow: TextOverflow.fade,
      softWrap: false,
      style: TextStyle(
        fontSize: NTDimensions.textXS,
        color: Colors.black26,
      ),
    );
  }
}
