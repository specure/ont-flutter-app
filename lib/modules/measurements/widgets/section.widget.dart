import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';

class Section extends StatelessWidget {
  final List<String> titles;
  final List<List<String>> values;
  final List<Widget> icons;
  final List<int> widths;

  Section({
    required this.titles,
    required this.values,
    this.icons = const [],
    this.widths = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: titles
          .asMap()
          .entries
          .map(
            (e) => Flexible(
              flex: widths.length > 1 ? widths[e.key] : 1,
              child: _buildSubSection(e.key),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSubSection(int subSectionNum) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: values.length > 1 ? 14 : 0),
            child: SectionTitle(titles[subSectionNum]),
          ),
          ...List.generate(
            values.length,
            (index) => Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ConditionalContent(
                    conditional: icons.length - 1 >= subSectionNum,
                    truthyBuilder: () => Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: icons[subSectionNum],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      values[index][subSectionNum],
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: NTDimensions.textS,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
