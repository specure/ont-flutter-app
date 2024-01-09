import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class NTAppBar extends AppBar {
  NTAppBar({
    Widget? leading,
    String? titleText,
    List<Widget>? actions,
    Color? color,
    double height = 72,
    PreferredSizeWidget? bottom,
  }) : super(
          actions: [
            ...actions ?? [],
            Container(
              width: 14,
            ),
          ],
          backgroundColor: color ?? Colors.transparent,
          surfaceTintColor: color ?? Colors.transparent,
          centerTitle: true,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 18),
            child: leading ?? Container(),
          ),
          title: Text((titleText ?? "").translated),
          titleTextStyle: Environment.appSuffix == '.no'
              ? TextStyle(
                  color: Colors.black,
                  fontSize: NTDimensions.textL,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'NewAtten',
                )
              : TextStyle(
                  color: Colors.black,
                  fontSize: NTDimensions.textL,
                  fontWeight: FontWeight.w500,
                ),
          toolbarHeight: height,
          bottom: bottom,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        );
}
