import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';

class WizardAccuracyItem extends StatelessWidget {
  const WizardAccuracyItem({
    Key? key,
    required this.iconData,
    this.title = "",
    this.lead = "",
    this.leadColor = Colors.black54,
    this.hasSwitch = false,
    this.switchValue = false,
    this.onSwitchChange,
  }) : super(key: key);

  final IconData iconData;
  final String title;
  final String lead;
  final Color leadColor;
  final bool hasSwitch;
  final bool switchValue;
  final void Function(bool)? onSwitchChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Icon(iconData),
                ),
                ConditionalContent(
                  conditional: title.isNotEmpty,
                  truthyBuilder: () => Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 7),
                    child: Text(
                      title.translated,
                      style: TextStyle(
                        fontSize: NTDimensions.textL,
                      ),
                    ),
                  ),
                ),
                ConditionalContent(
                  conditional: lead.isNotEmpty,
                  truthyBuilder: () => Text(
                    lead.translated,
                    style: TextStyle(
                      fontSize: NTDimensions.textM,
                      color: leadColor,
                      height: 1.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ConditionalContent(
          conditional: hasSwitch,
          truthyBuilder: () => Padding(
            padding: const EdgeInsets.only(top: 28),
            child: CupertinoSwitch(
              activeColor: NTColors.primary,
              trackColor: Colors.black,
              value: switchValue,
              onChanged: onSwitchChange,
            ),
          ),
        )
      ],
    );
  }
}
