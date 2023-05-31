import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/store/core.state.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/mno-isp-radio-group.widget.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/providers.button.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/technology.button.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class TechnologyBar extends StatelessWidget {
  TechnologyBar();

  @override
  Widget build(BuildContext context) {
    final disclaimerStyle = TextStyle(
      fontSize: NTDimensions.textXXS,
      color: Colors.black87,
    );
    return BlocBuilder<MapCubit, MapState>(builder: (context, state) {
      return InkWell(
        onTap: () => GetIt.I.get<MapCubit>().onTechnologyBarTap(),
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
            conditional: state.isTechnologyBarExpanded,
            truthyBuilder: () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      state.technologies.length,
                      (index) => TechnologyButton(
                            onTechnologyTap: (tech) =>
                                GetIt.I.get<MapCubit>().onTechnologyTap(tech),
                            technology: state.technologies[index],
                            active: state.currentTechnologyIndex == index,
                          )),
                ),
                BlocBuilder<CoreCubit, CoreState>(
                    builder: (coreContext, coreState) {
                  return ConditionalContent(
                    conditional:
                        coreState.project?.enableMapMnoIspSwitch == true,
                    truthyBuilder: () => Container(
                      padding: EdgeInsets.only(top: NTDimensions.textXL),
                      child: MnoIspRadioGroup(),
                    ),
                  );
                }),
                ProvidersButton(
                  operators: state.providers,
                  currentOperatorIndex: state.currentProviderIndex,
                  onTap: () => GetIt.I.get<MapCubit>().onProvidersTap(),
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
                  technology: state.technologies[state.currentTechnologyIndex],
                  active: true,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      state.currentProviderIndex == 0
                          ? _allProvidersTitle(state.isIspActive)
                          : state.providers[state.currentProviderIndex],
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
    });
  }

  _allProvidersTitle(bool isIspActive) => isIspActive
      ? 'All Fixed-Line Providers'.translated
      : 'All Mobile Network Operators'.translated;
}
