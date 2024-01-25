import 'package:flutter/widgets.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';

abstract class MapScreenConfig {
  MapState state;
  MaplibreMap? map;

  MapScreenConfig({required this.state, this.map});

  Widget getContent(BuildContext context);
}
