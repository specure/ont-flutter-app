import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/services/screen-config.service.dart';
import 'package:nt_flutter_standalone/core/store/core.state.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/network.service.dart';

class CoreCubit extends Cubit<CoreState> {
  final CMSService _cmsService = GetIt.I.get<CMSService>();
  final SharedPreferencesWrapper _preferences =
      GetIt.I.get<SharedPreferencesWrapper>();
  final NetworkService _networkService = GetIt.I.get<NetworkService>();
  final ConnectivityChangesHandler connectivityChangesHandler =
      CoreCubitConnectivityChangesHandler();

  StreamSubscription? _connectivitySubscription;

  CoreCubit() : super(CoreState());

  void init() async {
    _connectivitySubscription = await _networkService.subscribeToNetworkChanges(
        changesHandler: connectivityChangesHandler);
  }

  Future update({ConnectivityResult? connectivity}) async {
    if (connectivity == state.connectivity) {
      return;
    }
    if (connectivity == ConnectivityResult.none) {
      emit(state.copyWith(connectivity: connectivity));
      return;
    }
    final cmsProject = await _cmsService.getProject();
    final bool loopModeFeatureEnabled = cmsProject?.enableAppLoopMode ?? false;
    final bool languageSwitchEnabled =
        cmsProject?.enableAppLanguageSwitch ?? false;
    final bool netNeutralityTestsEnabled =
        cmsProject?.enableAppNetNeutralityTests ?? false;
    _preferences.setBool(
        StorageKeys.loopModeFeatureEnabled, loopModeFeatureEnabled);
    _preferences.setBool(
        StorageKeys.languageSwitchEnabled, languageSwitchEnabled);
    _preferences.setBool(
        StorageKeys.netNeutralityTestsEnabled, netNeutralityTestsEnabled);
    emit(state.copyWith(
      connectivity: connectivity,
      netNeutralityTestsEnabled: netNeutralityTestsEnabled,
      project: cmsProject,
    ));
  }

  void onItemTap(int index) {
    if (isClosed) {
      return;
    }
    final config = ScreenConfigService().config;
    if (index > (config.bottomBarScreens.length - 1)) {
      emit(state.copyWith(currentScreen: config.bottomBarScreens.length - 1));
    } else if (index < 0) {
      emit(state.copyWith(currentScreen: 0));
    } else {
      emit(state.copyWith(currentScreen: index));
    }
  }

  void goToScreen<T extends Widget>() {
    final index = ScreenConfigService().getScreenIndexByType<T>();
    onItemTap(index);
  }

  @override
  Future<void> close() async {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    return super.close();
  }
}

class CoreCubitConnectivityChangesHandler
    implements ConnectivityChangesHandler {
  @override
  process(ConnectivityResult connectivity) {
    GetIt.I.get<CoreCubit>().update(connectivity: connectivity);
  }
}
