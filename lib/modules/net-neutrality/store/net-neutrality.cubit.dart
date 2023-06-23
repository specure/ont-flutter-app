import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/network.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-details.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-phase.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-result-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-result.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-measurement/net-neutrality-measurement.screen.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-result-details/net-neutrality-result-details.screen.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-result/net-neutrality-result.screen.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-api.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-measurement.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';
import 'package:permission_handler/permission_handler.dart';

class NetNeutralityCubit extends Cubit<NetNeutralityState>
    implements NetNeutralityProgressHandler {
  static final noSettingsException =
      Exception("Net neutrality settings were not found, nothing to test.");

  final _apiService = GetIt.I.get<NetNeutralityApiService>();
  final _testService = GetIt.I.get<NetNeutralityMeasurementService>();
  final _navigationService = GetIt.I.get<NavigationService>();
  final _networkService = GetIt.I.get<NetworkService>();
  final _location = GetIt.I.get<LocationService>();
  final _platform = GetIt.I.get<PlatformWrapper>();
  final _deviceInfoPlugin = GetIt.I.get<DeviceInfoPlugin>();
  List<StreamSubscription<NetNeutralityResultItem>?> _testSubscriptions = [];

  ErrorHandler? errorHandler;
  ConnectivityChangesHandler? connectivityChangesHandler;
  StreamSubscription? _connectivitySubscription;

  NetNeutralityCubit({
    ErrorHandler? errorHandler,
    ConnectivityChangesHandler? connectivityChangesHandler,
  }) : super(NetNeutralityState(interimResults: [], historyResults: [])) {
    this.errorHandler = errorHandler ?? NetNeutralityCubitErrorHandler();
    this.connectivityChangesHandler = connectivityChangesHandler ??
        NetNeutralityCubitConnectivityChangesHandler();
  }

  Future init() async {
    try {
      _connectivitySubscription?.cancel();
      _connectivitySubscription =
          await _networkService.subscribeToNetworkChanges(
        changesHandler: connectivityChangesHandler,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> close() async {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _testSubscriptions.forEach((element) {
      element?.cancel();
    });
    _testSubscriptions.clear();
    super.close();
  }

  handleError(Exception? error) {
    emit(state.copyWith(error: error, phase: NetNeutralityPhase.none));
  }

  startMeasurement() async {
    emit(state.copyWith(
      lastResultForCurrentPhase: 0,
      phase: NetNeutralityPhase.fetchingSettings,
      interimResults: [],
    ));
    _navigationService.pushNamed(NetNeutralityMeasurementScreen.route);
    final settings =
        await _apiService.getSettings(errorHandler: this.errorHandler);
    if (settings == null) {
      handleError(noSettingsException);
      return;
    }
    _testService.initWithSettings(settings);
    _testSubscriptions.addAll([
      _testService.runAllWebPageTests()?.listen((event) {
        updateProgress(resultItem: event);
      }),
      _testService.runAllDnsTests()?.listen((event) {
        updateProgress(resultItem: event);
      }),
    ]);
  }

  restartMeasurement() {
    stopMeasurement();
    startMeasurement();
  }

  stopMeasurement() {
    emit(state.copyWith(
      phase: NetNeutralityPhase.none,
    ));
    _navigationService.goBack();
  }

  updateConnectivity(ConnectivityResult connectivity) {
    if (connectivity != state.connectivity) {
      emit(state.copyWith(
        connectivity: connectivity,
        lastResultForCurrentPhase: 0,
        phase: NetNeutralityPhase.none,
      ));
    }
  }

  @override
  updateProgress({NetNeutralityResultItem? resultItem}) async {
    if (_testService.settings == null) {
      return;
    }
    final interimResults = resultItem != null
        ? [...state.interimResults, resultItem]
        : state.interimResults;
    final double progress = min(
      100,
      (state.lastResultForCurrentPhase +
              (1 / (_testService.settings!.totalTests)) * 100)
          .roundToDouble(),
    );
    if (interimResults.length < _testService.settings!.totalTests) {
      emit(state.copyWith(
        lastResultForCurrentPhase: progress,
        phase: NetNeutralityPhase.runningTests,
        interimResults: interimResults,
      ));
    } else {
      _testSubscriptions.forEach((element) {
        element?.cancel();
      });
      _testSubscriptions.clear();
      var result = NetNeutralityResult();
      int networkTypeId;
      int? signalStrength;
      String? networkBand;

      var networkInfoDetails = await _networkService.getAllNetworkDetails();
      var signals = networkInfoDetails.currentAllSignalInfo;
      networkTypeId = serverNetworkTypes[networkInfoDetails.type] ??
          serverNetworkTypes[unknown]!;
      if (signals.isNotEmpty) {
        var firstSignal = signals[0];
        networkTypeId = firstSignal.networkTypeId ?? networkTypeId;
        signalStrength = firstSignal.signal;
        networkBand = firstSignal.band;
      }
      var publicIPAddress = networkInfoDetails.ipV4PublicAddress;
      if (publicIPAddress == addressIsNotAvailable) {
        publicIPAddress = networkInfoDetails.ipV6PublicAddress;
      }
      if (publicIPAddress == addressIsNotAvailable) {
        publicIPAddress = '';
      }
      result.networkType = networkTypeId;
      result.networkBand = networkBand;
      result.signalStrength = signalStrength;
      result.localIpAddress = publicIPAddress;
      result.testResults = interimResults;
      if (_platform.isAndroid) {
        var androidInfo = await _deviceInfoPlugin.androidInfo;
        result.platform = 'Android';
        result.device = androidInfo.device;
        result.model = androidInfo.model;
        result.product = androidInfo.brand;
      } else if (_platform.isIOS) {
        var iosInfo = await _deviceInfoPlugin.iosInfo;
        result.platform = 'iOS';
        result.device = iosInfo.name;
        result.model = iosInfo.model;
        result.product = iosInfo.name;
      }

      result.dualSim = networkInfoDetails.isDualSim;
      result.telephonyNetworkSimOperatorName =
          networkInfoDetails.telephonyNetworkSimOperatorName;
      result.telephonyNetworkSimOperator =
          networkInfoDetails.telephonyNetworkSimOperator;
      result.telephonyNetworkSimCountry =
          networkInfoDetails.telephonyNetworkSimCountry;
      result.telephonyNetworkIsRoaming =
          networkInfoDetails.telephonyNetworkIsRoaming;
      result.telephonyNetworkOperatorName =
          networkInfoDetails.telephonyNetworkOperatorName;
      result.telephonyNetworkOperator =
          networkInfoDetails.telephonyNetworkOperator;
      result.telephonyNetworkCountry =
          networkInfoDetails.telephonyNetworkCountry;
      try {
        final locationServiceEnabled = await _location.isLocationServiceEnabled;
        final locationPermissionGranted =
            await Permission.location.status == PermissionStatus.granted;
        if (locationPermissionGranted && locationServiceEnabled) {
          result.location = await _location.latestLocation;
          if (result.location?.latitude != null &&
              result.location?.longitude != null)
            result.location = await _location.getAddressByLocation(
                result.location!.latitude!, result.location!.longitude!);
        }
      } catch (_) {}
      emit(state.copyWith(
        lastResultForCurrentPhase: progress,
        phase: NetNeutralityPhase.submittingResult,
        interimResults: interimResults,
        loading: true,
      ));
      _navigationService.pushReplacementRoute(
          NetNeutralityResultScreen.route, null);
      await _apiService.postResults(
        results: result,
        errorHandler: this.errorHandler,
      );
      final historyResults = await _apiService.getHistory(
        _testService.settings!.openTestUuid,
        errorHandler: this.errorHandler,
      );
      emit(state.copyWith(
        phase: NetNeutralityPhase.finish,
        loading: false,
        historyResults: historyResults,
      ));
    }
  }

  openResultDetails(NetNeutralityDetailsConfig detailsConfig,
      List<NetNeutralityHistoryItem> results) async {
    emit(state.copyWith(
      resultDetailsConfig: detailsConfig,
      resultDetailsItems: results,
    ));
    await _navigationService.pushNamed(NetNeutralityResultDetailScreen.route);
  }

  Future<void> loadResults(String openTestUuid) async {
    emit(state.copyWith(
      loading: true,
    ));
    _navigationService.pushNamed(NetNeutralityResultScreen.route);
    final historyResults = await _apiService.getHistory(
      openTestUuid,
      errorHandler: this.errorHandler,
    );
    emit(state.copyWith(
      phase: NetNeutralityPhase.finish,
      loading: false,
      historyResults: historyResults,
    ));
  }
}

class NetNeutralityCubitErrorHandler implements ErrorHandler {
  @override
  process(Exception? error) {
    GetIt.I.get<NetNeutralityCubit>().handleError(error);
  }
}

class NetNeutralityCubitConnectivityChangesHandler
    implements ConnectivityChangesHandler {
  @override
  process(ConnectivityResult connectivity) {
    GetIt.I.get<NetNeutralityCubit>().updateConnectivity(connectivity);
  }
}
