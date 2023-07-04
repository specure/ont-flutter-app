import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/locales.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/wrappers/date-time.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/firebase-analytics.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/in-app-review.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/internet-address.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/core/services/localization.service.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/url-launcher-wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/wakelock.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/services/api/history.api.service.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/net-neutrality-history.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/services/api/map-search.api.service.dart';
import 'package:nt_flutter_standalone/modules/map/services/api/technology.api.service.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/services/measurement-result.service.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/carrier-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/cell-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/geocoding-wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/wifi-for-iot-plugin.wrapper.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/dns-test.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/ip-info.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/loop.mode.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurements.api.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurement.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/permissions.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/network.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/signal.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-api.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-measurement.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/onboarding/store/wizard.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/app.review.service.dart';
import 'package:nt_flutter_standalone/modules/settings/services/settings.service.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';

class ServiceLocator {
  static registerInstances() {
    //Plugins and wrappers
    _registerLazySingleton<WifiForIoTPluginWrapper>(
        () => WifiForIoTPluginWrapper());
    _registerLazySingleton<CarrierInfoWrapper>(() => CarrierInfoWrapper());
    _registerLazySingleton<CellInfoWrapper>(() => CellInfoWrapper());
    _registerLazySingleton<Connectivity>(() => Connectivity());
    _registerLazySingleton<PlatformWrapper>(() => PlatformWrapper());
    _registerLazySingleton<GeocodingWrapper>(() => GeocodingWrapper());
    _registerLazySingleton<Geolocator>(() => Geolocator());
    _registerLazySingleton<SharedPreferencesWrapper>(
        () => SharedPreferencesWrapper());
    _registerLazySingleton<FirebaseAnalyticsWrapper>(
        () => FirebaseAnalyticsWrapper());
    _registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());
    _registerLazySingleton<RouteObserver>(
      () => RouteObserver<ModalRoute<void>>(),
    );
    _registerLazySingleton<InternetAddressWrapper>(
        () => InternetAddressWrapper());
    _registerLazySingleton<InAppReviewWrapper>(() => InAppReviewWrapper());
    _registerLazySingleton<DateTimeWrapper>(() => DateTimeWrapper());
    _registerLazySingleton<UrlLauncherWrapper>(() => UrlLauncherWrapper());
    _registerLazySingleton<WakelockWrapper>(() => WakelockWrapper());
    // End plugins and wrappers

    //Components
    _registerFactory<Dio>(() => Dio());
    _registerLazySingleton<NTLocales>(() => NTLocales.instance);
    // End components

    //Services
    _registerLazySingleton<NavigationService>(() => NavigationService());
    _registerLazySingleton<LocalizationService>(() => LocalizationService());
    _registerLazySingleton<MeasurementsApiService>(
        () => MeasurementsApiService());
    _registerLazySingleton<TechnologyApiService>(() => TechnologyApiService());
    _registerLazySingleton<MapSearchApiService>(() => MapSearchApiService());
    _registerLazySingleton<HistoryApiService>(() => HistoryApiService());
    _registerLazySingleton<SettingsService>(() => SettingsService());
    _registerLazySingleton<MeasurementService>(() => MeasurementService());
    _registerLazySingleton<MeasurementResultService>(
        () => MeasurementResultService());
    _registerLazySingleton<CMSService>(() => CMSService());
    _registerLazySingleton<IPInfoService>(() => IPInfoService());
    _registerLazySingleton<NetworkService>(() => NetworkService());
    _registerLazySingleton<SignalService>(() => SignalService());
    _registerLazySingleton<LocationService>(() => LocationService());
    _registerLazySingleton<PermissionsService>(() => PermissionsService());
    _registerLazySingleton<AppReviewService>(() => AppReviewService());
    _registerLazySingleton<LoopModeService>(() => LoopModeService());
    _registerLazySingleton<DnsTestService>(() => DnsTestService());
    _registerLazySingleton<NetNeutralityApiService>(
        () => NetNeutralityApiService());
    _registerLazySingleton<NetNeutralityMeasurementService>(
        () => NetNeutralityMeasurementService());
    // End services

    //Blocs and Cubits
    _registerSingleton<MeasurementsBloc>(MeasurementsBloc());
    _registerLazySingleton<MeasurementResultCubit>(
        () => MeasurementResultCubit());
    _registerLazySingleton<CoreCubit>(() => CoreCubit());
    _registerLazySingleton<MapCubit>(() => MapCubit());
    _registerLazySingleton<HistoryCubit>(() => HistoryCubit());
    _registerLazySingleton<NetNeutralityHistoryCubit>(
        () => NetNeutralityHistoryCubit());
    _registerLazySingleton<SettingsCubit>(() => SettingsCubit());
    _registerLazySingleton<WizardCubit>(() => WizardCubit());
    _registerLazySingleton<NetNeutralityCubit>(() => NetNeutralityCubit());
    // End blocs and cubits
  }

  static _registerSingleton<T extends Object>(T instance) {
    if (!GetIt.I.isRegistered<T>()) {
      GetIt.I.registerSingleton(instance);
    }
  }

  static _registerLazySingleton<T extends Object>(T Function() register) {
    if (!GetIt.I.isRegistered<T>()) {
      GetIt.I.registerLazySingleton(register);
    }
  }

  static _registerFactory<T extends Object>(FactoryFunc<T> register) {
    if (!GetIt.I.isRegistered<T>()) {
      GetIt.I.registerFactory(register);
    }
  }

  ServiceLocator._();
}
