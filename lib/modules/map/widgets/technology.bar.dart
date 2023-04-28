import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/map/models/technology.item.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/providers.button.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/technology.button.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class TechnologyBar extends StatelessWidget {
  final List<TechnologyItem> allTechnologies;
  final List<String> operators;
  final bool expanded;
  final Function? onTap;
  final Function(TechnologyItem)? onTechnologyTap;
  final Function? onProvidersTap;
  final int currentTechnologyIndex;
  final int currentOperatorIndex;

  TechnologyBar({
    required this.allTechnologies,
    required this.operators,
    required this.expanded,
    this.onTap,
    this.onTechnologyTap,
    this.onProvidersTap,
    required this.currentTechnologyIndex,
    required this.currentOperatorIndex,
  });

  @override
  Widget build(BuildContext context) {
    final disclaimerStyle = TextStyle(
      fontSize: NTDimensions.textXXS,
      color: Colors.black87,
    );
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(blurRadius: 8, color: Colors.black26),
          ],
        ),
        child: ConditionalContent(
          conditional: expanded,
          truthyBuilder: () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    allTechnologies.length,
                    (index) => TechnologyButton(
                          onTechnologyTap: (tech) =>
                              onTechnologyTap?.call(tech),
                          technology: allTechnologies[index],
                          active: currentTechnologyIndex == index,
                        )),
              ),
              ProvidersButton(
                operators: operators,
                currentOperatorIndex: currentOperatorIndex,
                onTap: () => onProvidersTap?.call(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The map shows measurements done through the Nettfart apps.'
                        .translated,
                    style: disclaimerStyle,
                  ),
                  Text(
                    'It is not a coverage map.'.translated,
                    style: disclaimerStyle,
                  ),
                ],
              ),
            ],
          ),
          falsyBuilder: () => Row(
            children: [
              TechnologyButton(
                technology: allTechnologies[currentTechnologyIndex],
                active: true,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    currentOperatorIndex == 0
                        ? 'All Mobile Network Operators'.translated
                        : operators[currentOperatorIndex],
                    style: TextStyle(
                      fontSize: NTDimensions.textS,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Icon(Icons.info_outline),
            ],
          ),
        ),
      ),
    );
  }
}
