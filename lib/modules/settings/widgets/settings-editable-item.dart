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
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 20,
        right: 12,
        top: 16,
        bottom: 16,
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            SizedBox(
              width: 50,
              child: TextFormField(
                textAlign: TextAlign.center,
                key: key,
                decoration: InputDecoration(
                    helperText: " ",
                    hintStyle: const TextStyle(fontSize: 0.01),
                    labelStyle: const TextStyle(fontSize: 0.01),
                    helperStyle: const TextStyle(fontSize: 0.01),
                    errorStyle: const TextStyle(fontSize: 0.01)),
                textAlignVertical: TextAlignVertical.bottom,
                maxLines: 1,
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                onFieldSubmitted: ((text) => onFieldSubmitted(text)),
                initialValue: value,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => validator(value),
                style: TextStyle(
                    fontSize: NTDimensions.textL, color: NTColors.primary),
              ),
            )
            //
          ],
        ),
      ),
    );
  }
}
