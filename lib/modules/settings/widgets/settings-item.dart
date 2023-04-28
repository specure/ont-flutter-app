import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? value;
  final Function()? onTap;
  final bool showArrow;
  // -1: Do not show switch, 0: disabled, 1: enabled
  final int switchEnabled;
  final String? switchKey;
  final Function(bool)? onSwitchChange;

  SettingsItem(
      {required this.title,
      this.subtitle,
      this.value,
      this.onTap,
      this.showArrow = true,
      this.switchEnabled = -1,
      this.onSwitchChange,
      this.switchKey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          left: 20,
          right: 12,
          top: 16,
          bottom: 16,
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title.translated),
                    ConditionalContent(
                      conditional: subtitle != null,
                      truthyBuilder: () => Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle!.translated,
                          style: TextStyle(fontSize: NTDimensions.textXXS),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildArrowValue(),
              _buildSwitch(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArrowValue() {
    return Row(
      children: [
        Text(
          value?.translated ?? '',
          style: TextStyle(color: NTColors.primary),
        ),
        ConditionalContent(
          conditional: showArrow,
          truthyBuilder: () => Icon(
            Icons.keyboard_arrow_right,
            color: NTColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitch() {
    return ConditionalContent(
      conditional: switchEnabled != -1,
      truthyBuilder: () => CupertinoSwitch(
        activeColor: NTColors.primary,
        trackColor: Colors.black,
        value: switchEnabled == 1,
        onChanged: onSwitchChange,
        key: switchKey != null ? Key(switchKey!) : Key('value'),
      ),
    );
  }
}
