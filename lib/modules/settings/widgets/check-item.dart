import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class CheckItem extends StatelessWidget {
  final String text;

  CheckItem({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 8),
              child: Icon(
                Icons.check_circle_outline,
              ),
            ),
            Flexible(
              child: Text(
                text.translated,
                style: TextStyle(fontSize: NTDimensions.textL, height: 1.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
