import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';

class HomeInfoBoxItem extends StatelessWidget {
  const HomeInfoBoxItem({
    Key? key,
    required this.title,
    required this.value,
    this.icon,
  }) : super(key: key);

  final String title;
  final String value;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title),
          SizedBox(
            height: 36,
            child: Row(
              children: [
                icon != null
                    ? Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: icon,
                      )
                    : Container(),
                Flexible(
                  child: Text(
                    value.translated,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: NTDimensions.textM,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
