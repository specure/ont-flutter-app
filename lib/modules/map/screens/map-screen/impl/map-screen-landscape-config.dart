import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/map/screens/map-screen/map-screen-config.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/period.badge.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/search.bar.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/technology.bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapScreenLandscapeConfig extends MapScreenConfig {
  MapScreenLandscapeConfig(MapState state, MapboxMap? map)
      : super(state: state, map: map);

  @override
  Widget getContent(BuildContext context) {
    final double paddingTop = 8 + MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          map!,
          Container(
            alignment: Alignment.topRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, paddingTop, 10, 0),
                child: MapSearchBar(
                  textFieldFocusNode:
                      context.read<MapCubit>().mapSearchFocusNode,
                  onSearchTap: () => context.read<MapCubit>().onSearchTap(),
                  onCancelSearchTap: () =>
                      context.read<MapCubit>().onCancelSearchTap(),
                  onSearchEdit: (q) => context.read<MapCubit>().onSearchEdit(q),
                  isSearchActive: state.isSearchActive,
                  searchResults: state.searchResults,
                  onSearchResultTap: (i) =>
                      context.read<MapCubit>().onSearchResultTap(i),
                ),
              ),
            ),
          ),
          ConditionalContent(
            conditional: !state.isSearchActive,
            truthyBuilder: () => Positioned(
              // left: 10,
              right: 10,
              top: paddingTop + mapSearchBarHeight + 8,
              width: MediaQuery.of(context).size.width / 2 - 10,
              child: TechnologyBar(
                allTechnologies: technologies,
                operators: state.mobileNetworkOperators,
                currentTechnologyIndex: state.currentTechnologyIndex,
                currentOperatorIndex: state.currentOperatorIndex,
                expanded: state.isTechnologyBarExpanded,
                onTap: () => context.read<MapCubit>().onTechnologyBarTap(),
                onTechnologyTap: (tech) =>
                    context.read<MapCubit>().onTechnologyTap(tech),
                onProvidersTap: () => context.read<MapCubit>().onProvidersTap(),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 12),
            child: PeriodBadge(
              currentPeriod: state.currentPeriod!,
              onBadgeTap: () => context.read<MapCubit>().onPeriodBadgeTap(),
            ),
          ),
        ],
      ),
    );
  }
}
