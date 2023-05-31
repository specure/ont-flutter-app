import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/api-errors.dart';
import 'package:nt_flutter_standalone/core/constants/mapbox.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/store/core.state.dart';
import 'package:nt_flutter_standalone/core/widgets/error.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/modules/map/screens/map-screen/impl/map-screen-landscape-config.dart';
import 'package:nt_flutter_standalone/modules/map/screens/map-screen/impl/map-screen-portrait-config.dart';
import 'package:nt_flutter_standalone/modules/map/screens/map-screen/map-screen-config.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? _map;
  CoreState? _coreState;
  StreamSubscription? _styleSub;

  @override
  void initState() {
    super.initState();
    _coreState = GetIt.I.get<CoreCubit>().state;
    if (_coreState?.connectivity == null ||
        _coreState?.connectivity == ConnectivityResult.none) {
      return;
    }
    GetIt.I.get<MapCubit>().init();
    _styleSub = GetIt.I
        .get<MapCubit>()
        .stream
        .distinct((a, b) => a.isIspActive == b.isIspActive)
        .map((state) => state.isIspActive)
        .listen(_setMap);
  }

  @override
  void dispose() {
    _styleSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      bloc: GetIt.I.get<MapCubit>(),
      builder: (context, state) {
        if (_map == null) {
          return Container();
        }
        if (_coreState?.connectivity == null ||
            _coreState?.connectivity == ConnectivityResult.none) {
          return NTErrorWidget(ApiErrors.noInternetConnection);
        }
        return NTOrientationBuilder<MapScreenConfig>(
          portraitConfig: MapScreenPortraitConfig(state, _map),
          landscapeConfig: MapScreenLandscapeConfig(state, _map),
          builder: (config) => config.getContent(context),
        );
      },
    );
  }

  _setMap(bool isIspActive) {
    _map = MapboxMap(
      onMapCreated: GetIt.I.get<MapCubit>().onMapCreated,
      onStyleLoadedCallback: GetIt.I.get<MapCubit>().onMapStyleLoaded,
      onMapClick: GetIt.I.get<MapCubit>().onMapClick,
      myLocationEnabled: false,
      trackCameraPosition: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(MapBoxConsts.initialLat, MapBoxConsts.initialLng),
        zoom: MapBoxConsts.initialZoom,
      ),
      styleString:
          isIspActive ? MapBoxConsts.ispStyleUrl : MapBoxConsts.styleUrl,
      accessToken: dotenv.env['MAPBOX_TOKEN']!,
    );
  }
}
