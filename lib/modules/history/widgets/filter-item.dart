import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/divider.dart';
import 'package:nt_flutter_standalone/modules/history/models/history-filter.item.dart';

class FilterItem extends StatelessWidget {
  final HistoryFilterItem item;
  final bool isLast;
  final Function(HistoryFilterItem) onTap;

  FilterItem({
    required this.item,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(item),
      child: Column(
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.text,
                ),
                ConditionalContent(
                  conditional: item.active,
                  truthyBuilder: () =>
                      Icon(Icons.check, color: NTColors.primary),
                ),
              ],
            ),
          ),
          ConditionalContent(
            conditional: !isLast,
            truthyBuilder: () => ThinDivider(),
          ),
        ],
      ),
    );
  }
}