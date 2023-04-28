import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/carrier-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/cell-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/wifi-for-iot-plugin.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/services***REMOVED***-info.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/signal.service.dart';

abstract class ConnectivityChangesHandler {
  process(ConnectivityResult connectivity);
}

class NetworkService {
  final IPInfoService ipInfoService = GetIt.I.get<IPInfoService>();
  final WifiForIoTPluginWrapper wifiPlugin =
      GetIt.I.get<WifiForIoTPluginWrapper>();
  final CarrierInfoWrapper carrierPlugin = GetIt.I.get<CarrierInfoWrapper>();
  final CellInfoWrapper cellPlugin = GetIt.I.get<CellInfoWrapper>();
  final PlatformWrapper platform = GetIt.I.get<PlatformWrapper>();
  final SignalService signalService = GetIt.I.get<SignalService>();
  final Connectivity connectivity = GetIt.I.get<Connectivity>();
  final LocationService _locationService = GetIt.I.get<LocationService>();

  Future<StreamSubscription> subscribeToNetworkChanges(
      {ConnectivityChangesHandler? changesHandler}) async {
    changesHandler?.process(await connectivity.checkConnectivity());
    return connectivity.onConnectivityChanged.listen((result) {
      changesHandler?.process(result);
    });
  }

  Future<NetworkInfoDetails> getBasicNetworkDetails() async {
    final currentNetwork = await connectivity.checkConnectivity();
    var networkInfoDetails = await _getNetworkIpAddresses();
    switch (currentNetwork) {
      case ConnectivityResult.wifi:
        networkInfoDetails = networkInfoDetails.copyWith(
          type: wifi,
          mobileNetworkGeneration: unknown,
          name: unknown,
        );
        break;
      case ConnectivityResult.mobile:
        networkInfoDetails = networkInfoDetails.copyWith(
          type: mobile,
          mobileNetworkGeneration: unknown,
          name: unknown,
        );
        break;
      default:
        networkInfoDetails = _getUnknownNetworkInfo(networkInfoDetails);
    }
    return networkInfoDetails;
  }

  Future<NetworkInfoDetails> getAllNetworkDetails() async {
    var locationServiceEnabled =
        await _locationService.isLocationServiceEnabled;
    var networkInfoDetails = await _getNetworkIpAddresses();
    final currentNetwork = await connectivity.checkConnectivity();
    switch (currentNetwork) {
      case ConnectivityResult.wifi:
        networkInfoDetails = networkInfoDetails.copyWith(
          type: wifi,
          mobileNetworkGeneration: unknown,
          name: await wifiPlugin.getSSID(),
        );
        break;
      case ConnectivityResult.mobile:
        var mobileNetworkInfoDetails =
            await signalService.getCurrentMobileNetworkDetails();
        networkInfoDetails = networkInfoDetails.copyWith(
          type: mobileNetworkInfoDetails.type,
          mobileNetworkGeneration:
              mobileNetworkInfoDetails.mobileNetworkGeneration,
          name: mobileNetworkInfoDetails.name,
          isDualSim: mobileNetworkInfoDetails.isDualSim,
          telephonyNetworkIsRoaming:
              mobileNetworkInfoDetails.telephonyNetworkIsRoaming,
          telephonyNetworkCountry:
              mobileNetworkInfoDetails.telephonyNetworkCountry,
          telephonyNetworkOperator:
              mobileNetworkInfoDetails.telephonyNetworkOperator,
          telephonyNetworkOperatorName:
              mobileNetworkInfoDetails.telephonyNetworkOperatorName,
          telephonyNetworkSimCountry:
              mobileNetworkInfoDetails.telephonyNetworkSimCountry,
          telephonyNetworkSimOperator:
              mobileNetworkInfoDetails.telephonyNetworkSimOperator,
          telephonyNetworkSimOperatorName:
              mobileNetworkInfoDetails.telephonyNetworkSimOperatorName,
        );
        break;
      default:
        networkInfoDetails = _getUnknownNetworkInfo(networkInfoDetails);
    }
    if ((platform.isAndroid) && (locationServiceEnabled)) {
      var signalInfo =
          await signalService.getPrimaryDataSignalInfo(CellType.ALL);
      networkInfoDetails =
          networkInfoDetails.copyWith(currentAllSignalInfo: signalInfo);
    }
    return networkInfoDetails;
  }

  NetworkInfoDetails _getUnknownNetworkInfo(NetworkInfoDetails networkInfo) {
    return networkInfo.copyWith(
      type: unknown,
      mobileNetworkGeneration: unknown,
      name: unknown,
    );
  }

  Future<NetworkInfoDetails> _getNetworkIpAddresses() async {
    var ipV4PublicAddress = addressIsNotAvailable;
    var ipV6PublicAddress = addressIsNotAvailable;
    final currentNetwork = await connectivity.checkConnectivity();
    if (currentNetwork != ConnectivityResult.none) {
      ipV4PublicAddress = await ipInfoService.getPublicAddress(IPVersion.v4);
      ipV6PublicAddress = await ipInfoService.getPublicAddress(IPVersion.v6);
    }
    final ipV4Address = await ipInfoService.getPrivateAddress(IPVersion.v4);
    final ipV6Address = await ipInfoService.getPrivateAddress(IPVersion.v6);
    var details = NetworkInfoDetails(
      ipV4PrivateAddress: ipV4Address,
      ipV4PublicAddress: ipV4PublicAddress,
      ipV6PrivateAddress: ipV6Address,
      ipV6PublicAddress: ipV6PublicAddress,
    );
    return details;
  }
}
