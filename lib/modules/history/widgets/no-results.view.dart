import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class NoResultsView extends StatelessWidget {
  const NoResultsView({
    Key? key,
    required this.title,
    this.linkText,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String? linkText;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
              minWidth: viewportConstraints.maxWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                    'config/${Environment.appSuffix}/images/empty_image.svg'),
                SizedBox(height: 40),
                Column(
                  children: [
                    Text(
                      title.translated,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: NTDimensions.textS,
                      ),
                    ),
                    SizedBox(height: 32),
                    ConditionalContent(
                        conditional: linkText != null,
                        truthyBuilder: () {
                          return GestureDetector(
                            onTap: () {
                              if (onTap != null) {
                                onTap!();
                              }
                            },
                            child: Text(
                              linkText!.translated,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: NTColors.primary,
                                fontSize: NTDimensions.textS,
                              ),
                            ),
                          );
                        }),
                    SizedBox(height: 40)
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
