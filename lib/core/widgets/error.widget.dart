import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class NTErrorWidget extends StatelessWidget {
  final String text;

  const NTErrorWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Colors.redAccent,
              size: 42,
            ),
            Container(
              height: 18,
            ),
            Text(
              text.translated,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: NTDimensions.textS,
              ),
            )
          ],
        ),
      ),
    );
  }
}
