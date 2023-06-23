import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/locales.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/wrappers/date-time.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/firebase-analytics.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/in-app-review.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/internet-address.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/services/localization.service.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/url-launcher-wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/wakelock.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/services/api/history.api.service.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/services/api/map-search.api.service.dart';
import 'package:nt_flutter_standalone/modules/map/services/api/technology.api.service.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/services/measurement-result.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/carrier-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/cell-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/geocoding-wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/wifi-for-iot-plugin.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/ip-info.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/loop.mode.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurement.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurements.api.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/network.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/permissions.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/signal.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/app.review.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/dns-test.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-api.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-measurement.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/services/settings.service.dart';

import '../core/unit-tests/dio-service_test.mocks.dart';
import '../history/unit-tests/history-api-service_test.mocks.dart';
import '../history/unit-tests/history-cubit_test.dart';
import '../history/unit-tests/history-cubit_test.mocks.dart';
import '../history/widget-tests/history-screen_test.mocks.dart';
import '../map/unit-tests/map-cubit_test.dart';
import '../map/unit-tests/map-cubit_test.mocks.dart';
import '../measurement-result/unit-tests/measurement-result-cubit_test.mocks.dart';
import '../measurement-result/widget-tests/results-qos-view-widget_test.mocks.dart';
import '../measurements/unit-tests/app-review-service_test.mocks.dart';
import '../measurements/unit-tests/location-service_test.mocks.dart';
import '../measurements/unit-tests/measurements-api-service_test.mocks.dart';
import '../measurements/unit-tests/measurements-bloc_test.mocks.dart';
import '../measurements/unit-tests/network-service_test.mocks.dart';
import '../measurements/widgets-tests/start-test.widget_test.mocks.dart';
import '../net-neutrality/unit-tests/net-neutrality-cubit_test.mocks.dart';
import '../net-neutrality/unit-tests/net-neutrality-measurement-service_test.mocks.dart';
import '../settings/unit-tests/settings-cubit_test.mocks.dart';
import 'core-mocks.dart';

class TestingServiceLocator {
  static registerInstances({bool withRealLocalization = false}) {
    //Services
    _registerLazySingleton<MeasurementsApiService>(
        () => MockMeasurementsApiService());
    _registerLazySingleton<TechnologyApiService>(
        () => MockTechnologyApiService());
    _registerLazySingleton<NavigationService>(() => MockNavigationService());
    _registerLazySingleton<MapSearchApiService>(
        () => MockMapSearchApiService());
    _registerLazySingleton<HistoryApiService>(() => MockHistoryApiService());
    _registerLazySingleton<MeasurementService>(() => MockMeasurementService());
    _registerLazySingleton<MeasurementResultService>(
        () => MockMeasurementResultService());
    _registerLazySingleton<PermissionsService>(() => MockPermissionsService());
    _registerLazySingleton<SettingsService>(() => MockSettingsService());
    _registerLazySingleton<LocationService>(() => MockLocationService());
    _registerLazySingleton<IPInfoService>(() => MockIPInfoService());
    _registerLazySingleton<NetworkService>(() => MockNetworkService());
    _registerLazySingleton<SignalService>(() => MockSignalService());
    _registerLazySingleton<CMSService>(() => MockCMSService());
    _registerLazySingleton<AppReviewService>(() => MockAppReviewService());
    _registerLazySingleton<LoopModeService>(() => MockLoopModeService());
    _registerLazySingleton<NetNeutralityApiService>(
        () => MockNetNeutralityApiService());
    _registerLazySingleton<NetNeutralityMeasurementService>(
        () => MockNetNeutralityMeasurementService());
    _registerLazySingleton<DnsTestService>(() => MockDnsTestService());

    // Required when you test a widget that has a translated text:
    if (withRealLocalization) {
      _registerLazySingleton<LocalizationService>(
          () => LocalizationService(testing: true));
    } else {
      _registerLazySingleton<LocalizationService>(
          () => MockLocalizationService());
    }
    // End services

    //Plugins and wrappers
    _registerLazySingleton<WifiForIoTPluginWrapper>(
        () => MockWifiForIoTPluginWrapper());
    _registerLazySingleton<CarrierInfoWrapper>(() => MockCarrierInfoWrapper());
    _registerLazySingleton<CellInfoWrapper>(() => MockCellInfoWrapper());
    _registerLazySingleton<Connectivity>(() => MockConnectivity());
    _registerLazySingleton<PlatformWrapper>(() => MockPlatformWrapper());
    when(GetIt.I.get<PlatformWrapper>().localeName).thenReturn('en_US');
    _registerLazySingleton<GeocodingWrapper>(() => (MockGeocodingWrapper()));
    _registerLazySingleton<SharedPreferencesWrapper>(
        () => MockSharedPreferencesWrapper());
    _registerLazySingleton<FirebaseAnalyticsWrapper>(
        () => MockFirebaseAnalyticsWrapper());
    _registerLazySingleton<DeviceInfoPlugin>(() => MockDeviceInfoPlugin());
    _registerLazySingleton<RouteObserver>(
      () => MockRouteObserver<ModalRoute<void>>(),
    );
    _registerLazySingleton<InternetAddressWrapper>(
        () => MockInternetAddressWrapper());
    _registerLazySingleton<InAppReviewWrapper>(() => MockInAppReviewWrapper());
    _registerLazySingleton<DateTimeWrapper>(() => MockDateTimeWrapper());
    _registerLazySingleton<UrlLauncherWrapper>(() => MockUrlLauncherWrapper());
    _registerLazySingleton<WakelockWrapper>(() => MockWakelockWrapper());
    // End plugin wrappers

    //Components
    _registerLazySingleton<Dio>(() => MockDio());
    _registerLazySingleton<NTLocales>(() => MockNTLocales());
    // End components

    // Cubits
    _registerLazySingleton<CoreCubit>(() => MockCoreCubitCalls());
    _registerLazySingleton<HistoryCubit>(() => MockHistoryCubit());
    _registerLazySingleton<NetNeutralityCubit>(() => MockNetNeutralityCubit());
    _registerLazySingleton<MapCubit>(() => MockMapCubit());
    // End cubits
  }

  static _registerLazySingleton<T extends Object>(T Function() register) {
    if (!GetIt.I.isRegistered<T>()) {
      GetIt.I.registerLazySingleton(register);
    }
  }

  static swapLazySingleton<T extends Object>(T Function() register) {
    if (GetIt.I.isRegistered<T>()) {
      GetIt.I.unregister<T>();
    }
    GetIt.I.registerLazySingleton(register);
  }

  TestingServiceLocator._();
}
