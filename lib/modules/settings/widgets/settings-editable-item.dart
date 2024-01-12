import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class SettingsEditableItem extends StatelessWidget {
  final String title;
  final Key key;
  final String? subtitle;
  final String? value;
  final Function(String text) onFieldSubmitted;
  final Function(String? value) validator;

  SettingsEditableItem({
    required this.title,
    required this.onFieldSubmitted,
    required this.validator,
    required this.key,
    this.subtitle,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
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
          Container(
            width: 50,
            child: TextFormField(
              key: key,
              decoration: InputDecoration(
                helperText: " ",
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              validator: (value) => validator(value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: onFieldSubmitted,
              initialValue: value,
              autofocus: true,
              style: TextStyle(
                fontSize: NTDimensions.textL,
                color: NTColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
