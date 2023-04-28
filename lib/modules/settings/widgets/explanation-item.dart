import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class ExplanationItem extends StatelessWidget {
  final String title;
  final String text;

  ExplanationItem({
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.translated.toUpperCase(),
                style: TextStyle(
                  fontSize: NTDimensions.textL,
                ),
              ),
              Text(
                text.translated,
                style: TextStyle(
                    fontSize: NTDimensions.textL,
                    color: Colors.black26,
                    height: 1.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
