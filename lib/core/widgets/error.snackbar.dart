import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class NTErrorSnackbar extends SnackBar {
  NTErrorSnackbar(String text)
      : super(
          content: SizedBox(
            height: 42,
            child: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.redAccent,
                ),
                Container(width: 14),
                Expanded(
                  child: Text(
                    text.translated,
                    style: TextStyle(fontSize: NTDimensions.textS),
                  ),
                ),
              ],
            ),
          ),
          margin: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
        );
}
