import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/api-errors.dart';
import 'package:nt_flutter_standalone/core/constants/mapbox.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
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

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  MapLibreMap? _map;
  UniqueKey? _mapKey;
  CoreState? _coreState;
  StreamSubscription? _styleSub;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _mapKey = UniqueKey();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _mapKey = UniqueKey();
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      key: _mapKey,
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
    _map = MapLibreMap(
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
    );
  }
}
