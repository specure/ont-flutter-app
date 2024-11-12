import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';

class TextSection extends StatelessWidget {
  final String title;
  final String value;
  final String? valueUnit;
  final bool largeValueFont;
  final IconData? icon;
  final double? width;
  final bool allowCopy;

  TextSection({
    required this.title,
    required this.value,
    this.valueUnit,
    this.largeValueFont = false,
    this.icon,
    this.width,
    this.allowCopy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SectionTitle(title),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ConditionalContent(
                conditional: icon != null,
                truthyBuilder: () => Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(icon),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () async {
                    if (allowCopy) {
                      await Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Test ID copied to clipboard'.translated),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: value,
                      style: TextStyle(
                        fontSize: largeValueFont
                            ? NTDimensions.textS * 2
                            : NTDimensions.textS,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${valueUnit ?? ''}',
                          style: TextStyle(fontSize: NTDimensions.textS),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
