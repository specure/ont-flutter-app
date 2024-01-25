import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/map/screens/map-screen/map-screen-config.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/period.badge.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/search.bar.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/technology.bar.dart';

import 'package:flutter/material.dart';

class MapScreenPortraitConfig extends MapScreenConfig {
  MapScreenPortraitConfig(MapState state, MaplibreMap? map)
      : super(state: state, map: map);

  @override
  Widget getContent(BuildContext context) {
    final paddingTop = 8 + MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          map!,
          Positioned(
            left: 10,
            right: 10,
            top: paddingTop,
            child: MapSearchBar(),
          ),
          ConditionalContent(
            conditional: !state.isSearchActive,
            truthyBuilder: () => Positioned(
              left: 10,
              right: 10,
              top: paddingTop + mapSearchBarHeight + 8,
              child: TechnologyBar(),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 12),
            child: PeriodBadge(),
          ),
        ],
      ),
    );
  }
}
