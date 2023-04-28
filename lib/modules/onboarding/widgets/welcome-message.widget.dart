import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({
    Key? key,
    this.title = "",
    this.lead = "",
  }) : super(key: key);

  final String title;
  final String lead;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                title.translated,
                style: TextStyle(
                  fontSize: NTDimensions.title,
                  color: NTColors.title,
                ),
              ),
            ),
          ),
          Flexible(
            child: Text(
              lead.translated,
              style: TextStyle(
                fontSize: NTDimensions.textL,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}
