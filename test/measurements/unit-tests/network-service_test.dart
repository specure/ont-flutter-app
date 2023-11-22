import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/signal-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/wrappers/carrier-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/wrappers/cell-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/wrappers/wifi-for-iot-plugin.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/ip-info.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurements.api.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/network.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/signal.service.dart';

import '../../di/service-locator.dart';

const _ipV4PublicAddress = '192.168.0.0';
const _ipV4PrivateAddress = '192.168.0.1';
const _ipV6Address = '2001:0db8:85a3:0000:0000:8a2e:0370:7334';
const _ssid = 'SSID';
const _frequency = 2400;
const _signalStrength = -50;
const _carrierName = 'Provider';
const _radioType = 'LTE';
const _networkGeneration = '4g';
const _cellInfoJsonString =
    '{"primaryCellList":[{"lte":{"bandLTE":{"downlinkEarfcn":1600,"channelNumber":1600,"name":"1800","number":3},"cid":3,"eci":179271427,"pci":496,"signalLTE":{"cqi":0,"rsrp":-98.0,"rsrq":-11.0,"rssi":-67,"snr":12.0,"timingAdvance":1,"dbm":-67},"tac":206,"connectionStatus":"PrimaryConnection()","network":{"iso":"BY","mcc":"257","mnc":"02"},"subscriptionId":2,"type":"LTE"},"type":"LTE"}]}';
var _cellInfoDualSim5gNrNsaFromLteNrJsonString =
    File('test/measurements/unit-tests/data/dualSim5gNrNsaFromLteNr.json')
        .readAsStringSync();
var _cellInfoDualSim5gNrNsaFromLteCaNrJsonString =
    File('test/measurements/unit-tests/data/dualSim5gNrNsaFromLteCaNr.json')
        .readAsStringSync();
var _cellInfoDualSim4gPlus5gJsonString =
    File('test/measurements/unit-tests/data/dualSim4gPlus5g.json')
        .readAsStringSync();
var _cellInfoDualSim4gLteCaJsonString =
    File('test/measurements/unit-tests/data/dualSim4gLteCa.json')
        .readAsStringSync();
var _cellInfoDualSim3gHspaJsonString =
    File('test/measurements/unit-tests/data/dualSim3gHspa.json')
        .readAsStringSync();
var _cellInfoDualSim2gEdgeJsonString =
    File('test/measurements/unit-tests/data/dualSim2gEdge.json')
        .readAsStringSync();
List<SignalInfo> _allSignals5gNrNsaFromLteNr = (jsonDecode(File(
            'test/measurements/unit-tests/data/allPrimaryDataCellSignalInfoNrLte.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();
List<SignalInfo> _allSignals5gNrNsaFromLteNrCa = (jsonDecode(File(
            'test/measurements/unit-tests/data/allPrimaryDataCellSignalInfoNrLteCa.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();
List<SignalInfo> _allSignals4gPlus5g = (jsonDecode(File(
            'test/measurements/unit-tests/data/allPrimaryDataCellSignalInfo4gPlus5g.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();
List<SignalInfo> _allSignals4gLteCa = (jsonDecode(File(
            'test/measurements/unit-tests/data/allPrimaryDataCellSignalInfo4gLteCa.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();
List<SignalInfo> _allSignals3gHspa = (jsonDecode(File(
            'test/measurements/unit-tests/data/allPrimaryDataCellSignalInfoNrLte.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();
List<SignalInfo> _allSignals2gEdge = (jsonDecode(File(
            'test/measurements/unit-tests/data/allPrimaryDataCellSignalInfoNrLte.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();
const _dualSimInfo =
    '{"simInfoList":[{"carrierName":"O2 - SK","displayName":"O2 - SK","isDefaultDataSubscription":true,"mcc":231,"mnc":6,"subscriptionId":2,"subscriptionInfoNumber":""},{"carrierName":"Orange SK","displayName":"A1","isDefaultDataSubscription":false,"mcc":232,"mnc":1,"subscriptionId":1,"subscriptionInfoNumber":""}]}';
const _androidCarrierName = 'O2 - SK';
const _radioTypeNSA = 'NSA';
const _radioTypeLTE = 'LTE';
const _radioTypeLTENR = 'LTE NR';
const _radioTypeEdge = 'EDGE';
const _radioTypeHSPA = 'HSPA';
const _networkGeneration4G5G = '4G+(5G)';
const _networkGeneration4G = '4G';
const _networkGeneration5G = '5G';
const _networkGeneration3G = '3G';
const _networkGeneration2G = '2G';
final signalService = GetIt.I.get<SignalService>();

@GenerateMocks([
  MeasurementsApiService,
  WifiForIoTPluginWrapper,
  CarrierInfoWrapper,
  CellInfoWrapper,
  IPInfoService,
  Connectivity,
  SignalService,
  PlatformWrapper
])
void main() {
  group('Wifi network tests', () {
    TestingServiceLocator.registerInstances();
    final networkService = NetworkService();
    test('Test all network Details with Wifi', () async {
      await _testIosNetworkDetails(networkService, ConnectivityResult.wifi);
    });
  });

  group('iOS mobile network tests', () {
    TestingServiceLocator.registerInstances();
    final networkService = NetworkService();
    test('Test all network Details with Mobile', () async {
      await _testIosNetworkDetails(networkService, ConnectivityResult.mobile);
    });
  });

  group('Android mobile network tests', () {
    TestingServiceLocator.registerInstances();
    final networkService = NetworkService();
    test('Test 5G NSA with LTE Details with Mobile', () async {
      await _testAndroid5gNsaFromLteNetworkDetails(
          networkService, ConnectivityResult.mobile);
    });
    test('Test 5G NSA with LTE CA Details with Mobile', () async {
      await _testAndroid5gNsaFromLteCaNetworkDetails(
          networkService, ConnectivityResult.mobile);
    });
    test('Test 4G+5G Details with Mobile', () async {
      await _testAndroid4gPlus5gNetworkDetails(
          networkService, ConnectivityResult.mobile);
    });
    test('Test 4G LTE CA Details with Mobile', () async {
      await _testAndroid4gLteCaNetworkDetails(
          networkService, ConnectivityResult.mobile);
    });
    test('Test 3G HSPDA+ Details with Mobile', () async {
      await _testAndroid3gHspaNetworkDetails(
          networkService, ConnectivityResult.mobile);
    });
    test('Test 2G EDGE Details with Mobile', () async {
      await _testAndroid2gEdgeNetworkDetails(
          networkService, ConnectivityResult.mobile);
    });
  });
}

Future _testIosNetworkDetails(
    NetworkService service, ConnectivityResult networkType) async {
  _setUpStubs(result: networkType);
  _setUpIosCellDataStub();
  await service.subscribeToNetworkChanges();
  expect(
    await service.getAllNetworkDetails(),
    NetworkInfoDetails(
      type: networkType == ConnectivityResult.wifi ? wifi : _radioType,
      name: networkType == ConnectivityResult.wifi ? _ssid : _carrierName,
      mobileNetworkGeneration:
          networkType == ConnectivityResult.wifi ? unknown : _networkGeneration,
      ipV4PrivateAddress: _ipV4PrivateAddress,
      ipV4PublicAddress: _ipV4PublicAddress,
      ipV6PrivateAddress: _ipV6Address,
      ipV6PublicAddress: _ipV6Address,
    ),
  );
}

Future _testAndroid5gNsaFromLteNetworkDetails(
    NetworkService service, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid5gNsaFromLteCellDataStub();
  await service.subscribeToNetworkChanges();
  final allNetworkDetails = await service.getAllNetworkDetails();
  var signals = allNetworkDetails.currentAllSignalInfo;
  var networkDetails = allNetworkDetails.copyWith(currentAllSignalInfo: []);
  expect(
    networkDetails,
    NetworkInfoDetails(
      type: networkType == ConnectivityResult.wifi ? wifi : _radioTypeNSA,
      name:
          networkType == ConnectivityResult.wifi ? _ssid : _androidCarrierName,
      mobileNetworkGeneration: networkType == ConnectivityResult.wifi
          ? unknown
          : _networkGeneration5G,
      ipV4PrivateAddress: _ipV4PrivateAddress,
      ipV4PublicAddress: _ipV4PublicAddress,
      ipV6PrivateAddress: _ipV6Address,
      ipV6PublicAddress: _ipV6Address,
    ),
  );
  expect(signals, _allSignals5gNrNsaFromLteNr);
}

Future _testAndroid5gNsaFromLteCaNetworkDetails(
    NetworkService service, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid5gNsaFromLteCaCellDataStub();
  await service.subscribeToNetworkChanges();
  final allNetworkDetails = await service.getAllNetworkDetails();
  var signals = allNetworkDetails.currentAllSignalInfo;
  var networkDetails = allNetworkDetails.copyWith(currentAllSignalInfo: []);
  expect(
    networkDetails,
    NetworkInfoDetails(
      type: networkType == ConnectivityResult.wifi ? wifi : _radioTypeNSA,
      name:
          networkType == ConnectivityResult.wifi ? _ssid : _androidCarrierName,
      mobileNetworkGeneration: networkType == ConnectivityResult.wifi
          ? unknown
          : _networkGeneration5G,
      ipV4PrivateAddress: _ipV4PrivateAddress,
      ipV4PublicAddress: _ipV4PublicAddress,
      ipV6PrivateAddress: _ipV6Address,
      ipV6PublicAddress: _ipV6Address,
    ),
  );
  expect(signals, _allSignals5gNrNsaFromLteNrCa);
}

Future _testAndroid4gLteCaNetworkDetails(
    NetworkService service, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid4gLteCaCellDataStub();
  await service.subscribeToNetworkChanges();
  final allNetworkDetails = await service.getAllNetworkDetails();
  var signals = allNetworkDetails.currentAllSignalInfo;
  var networkDetails = allNetworkDetails.copyWith(currentAllSignalInfo: []);
  expect(
    networkDetails,
    NetworkInfoDetails(
      type: networkType == ConnectivityResult.wifi ? wifi : _radioTypeLTE,
      name:
          networkType == ConnectivityResult.wifi ? _ssid : _androidCarrierName,
      mobileNetworkGeneration: networkType == ConnectivityResult.wifi
          ? unknown
          : _networkGeneration4G,
      ipV4PrivateAddress: _ipV4PrivateAddress,
      ipV4PublicAddress: _ipV4PublicAddress,
      ipV6PrivateAddress: _ipV6Address,
      ipV6PublicAddress: _ipV6Address,
    ),
  );
  expect(signals, _allSignals4gLteCa);
}

Future _testAndroid4gPlus5gNetworkDetails(
    NetworkService service, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid4gPlus5gCellDataStub();
  await service.subscribeToNetworkChanges();
  final allNetworkDetails = await service.getAllNetworkDetails();
  var signals = allNetworkDetails.currentAllSignalInfo;
  var networkDetails = allNetworkDetails.copyWith(currentAllSignalInfo: []);
  expect(
    networkDetails,
    NetworkInfoDetails(
      type: networkType == ConnectivityResult.wifi ? wifi : _radioTypeLTENR,
      name:
          networkType == ConnectivityResult.wifi ? _ssid : _androidCarrierName,
      mobileNetworkGeneration: networkType == ConnectivityResult.wifi
          ? unknown
          : _networkGeneration4G5G,
      ipV4PrivateAddress: _ipV4PrivateAddress,
      ipV4PublicAddress: _ipV4PublicAddress,
      ipV6PrivateAddress: _ipV6Address,
      ipV6PublicAddress: _ipV6Address,
    ),
  );
  expect(signals, _allSignals4gPlus5g);
}

Future _testAndroid3gHspaNetworkDetails(
    NetworkService service, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid3gHspaCellDataStub();
  await service.subscribeToNetworkChanges();
  final allNetworkDetails = await service.getAllNetworkDetails();
  var signals = allNetworkDetails.currentAllSignalInfo;
  var networkDetails = allNetworkDetails.copyWith(currentAllSignalInfo: []);
  expect(
    networkDetails,
    NetworkInfoDetails(
      type: networkType == ConnectivityResult.wifi ? wifi : _radioTypeHSPA,
      name:
          networkType == ConnectivityResult.wifi ? _ssid : _androidCarrierName,
      mobileNetworkGeneration: networkType == ConnectivityResult.wifi
          ? unknown
          : _networkGeneration3G,
      ipV4PrivateAddress: _ipV4PrivateAddress,
      ipV4PublicAddress: _ipV4PublicAddress,
      ipV6PrivateAddress: _ipV6Address,
      ipV6PublicAddress: _ipV6Address,
    ),
  );
  expect(signals, _allSignals3gHspa);
}

Future _testAndroid2gEdgeNetworkDetails(
    NetworkService service, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid2gEdgeCellDataStub();
  await service.subscribeToNetworkChanges();
  final allNetworkDetails = await service.getAllNetworkDetails();
  var signals = allNetworkDetails.currentAllSignalInfo;
  var networkDetails = allNetworkDetails.copyWith(currentAllSignalInfo: []);
  expect(
    networkDetails,
    NetworkInfoDetails(
      type: networkType == ConnectivityResult.wifi ? wifi : _radioTypeEdge,
      name:
          networkType == ConnectivityResult.wifi ? _ssid : _androidCarrierName,
      mobileNetworkGeneration: networkType == ConnectivityResult.wifi
          ? unknown
          : _networkGeneration2G,
      ipV4PrivateAddress: _ipV4PrivateAddress,
      ipV4PublicAddress: _ipV4PublicAddress,
      ipV6PrivateAddress: _ipV6Address,
      ipV6PublicAddress: _ipV6Address,
    ),
  );
  expect(signals, _allSignals2gEdge);
}

_setUpIosCellDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getCellInfo()).thenAnswer((_) async => _cellInfoJsonString);
  when(signalService.getCurrentMobileNetworkDetails()).thenAnswer((_) async =>
      NetworkInfoDetails().copyWith(
          type: _radioType,
          mobileNetworkGeneration: _networkGeneration,
          name: _carrierName));
}

_setUpAndroid5gNsaFromLteCellDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getSimInfo()).thenAnswer((_) async => _dualSimInfo);
  when(cellInfo.getCellInfo())
      .thenAnswer((_) async => _cellInfoDualSim5gNrNsaFromLteNrJsonString);
  when(signalService.getCurrentMobileNetworkDetails()).thenAnswer((_) async =>
      NetworkInfoDetails().copyWith(
          type: _radioTypeNSA,
          mobileNetworkGeneration: _networkGeneration5G,
          name: _androidCarrierName));
  when(signalService.getPrimaryDataSignalInfo(CellType.ALL))
      .thenAnswer((_) async => _allSignals5gNrNsaFromLteNr);
}

_setUpAndroid5gNsaFromLteCaCellDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getSimInfo()).thenAnswer((_) async => _dualSimInfo);
  when(cellInfo.getCellInfo())
      .thenAnswer((_) async => _cellInfoDualSim5gNrNsaFromLteCaNrJsonString);
  when(signalService.getCurrentMobileNetworkDetails()).thenAnswer((_) async =>
      NetworkInfoDetails().copyWith(
          type: _radioTypeNSA,
          mobileNetworkGeneration: _networkGeneration5G,
          name: _androidCarrierName));
  when(signalService.getPrimaryDataSignalInfo(CellType.ALL))
      .thenAnswer((_) async => _allSignals5gNrNsaFromLteNrCa);
}

_setUpAndroid4gPlus5gCellDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getSimInfo()).thenAnswer((_) async => _dualSimInfo);
  when(cellInfo.getCellInfo())
      .thenAnswer((_) async => _cellInfoDualSim4gPlus5gJsonString);
  when(signalService.getCurrentMobileNetworkDetails()).thenAnswer((_) async =>
      NetworkInfoDetails().copyWith(
          type: _radioTypeLTENR,
          mobileNetworkGeneration: _networkGeneration4G5G,
          name: _androidCarrierName));
  when(signalService.getPrimaryDataSignalInfo(CellType.ALL))
      .thenAnswer((_) async => _allSignals4gPlus5g);
}

_setUpAndroid4gLteCaCellDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getSimInfo()).thenAnswer((_) async => _dualSimInfo);
  when(cellInfo.getCellInfo())
      .thenAnswer((_) async => _cellInfoDualSim4gLteCaJsonString);
  when(signalService.getCurrentMobileNetworkDetails()).thenAnswer((_) async =>
      NetworkInfoDetails().copyWith(
          type: _radioTypeLTE,
          mobileNetworkGeneration: _networkGeneration4G,
          name: _androidCarrierName));
  when(signalService.getPrimaryDataSignalInfo(CellType.ALL))
      .thenAnswer((_) async => _allSignals4gLteCa);
}

_setUpAndroid3gHspaCellDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getSimInfo()).thenAnswer((_) async => _dualSimInfo);
  when(cellInfo.getCellInfo())
      .thenAnswer((_) async => _cellInfoDualSim3gHspaJsonString);
  when(signalService.getCurrentMobileNetworkDetails()).thenAnswer((_) async =>
      NetworkInfoDetails().copyWith(
          type: _radioTypeHSPA,
          mobileNetworkGeneration: _networkGeneration3G,
          name: _androidCarrierName));
  when(signalService.getPrimaryDataSignalInfo(CellType.ALL))
      .thenAnswer((_) async => _allSignals3gHspa);
}

_setUpAndroid2gEdgeCellDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getSimInfo()).thenAnswer((_) async => _dualSimInfo);
  when(cellInfo.getCellInfo())
      .thenAnswer((_) async => _cellInfoDualSim2gEdgeJsonString);
  when(signalService.getCurrentMobileNetworkDetails()).thenAnswer((_) async =>
      NetworkInfoDetails().copyWith(
          type: _radioTypeEdge,
          mobileNetworkGeneration: _networkGeneration2G,
          name: _androidCarrierName));
  when(signalService.getPrimaryDataSignalInfo(CellType.ALL))
      .thenAnswer((_) async => _allSignals2gEdge);
}

_setUpStubs({
  bool isAndroid = false,
  required ConnectivityResult result,
}) {
  final wifiPlugin = GetIt.I.get<WifiForIoTPluginWrapper>();
  final carrierInfo = GetIt.I.get<CarrierInfoWrapper>();

  final networkInterface = GetIt.I.get<IPInfoService>();
  when(GetIt.I.get<LocationService>().isLocationServiceEnabled)
      .thenAnswer((_) async => true);
  when(networkInterface.getPublicAddress(IPVersion.v4))
      .thenAnswer((_) async => _ipV4PublicAddress);
  when(networkInterface.getPublicAddress(IPVersion.v6))
      .thenAnswer((_) async => _ipV6Address);
  when(networkInterface.getPrivateAddress(IPVersion.v4))
      .thenAnswer((_) async => _ipV4PrivateAddress);
  when(networkInterface.getPrivateAddress(IPVersion.v6))
      .thenAnswer((_) async => _ipV6Address);
  when(wifiPlugin.getSSID()).thenAnswer((_) async => _ssid);
  when(wifiPlugin.getFrequency()).thenAnswer((_) async => _frequency);
  when(wifiPlugin.getCurrentSignalStrength())
      .thenAnswer((_) async => _signalStrength);
  when(carrierInfo.getCarrierName()).thenAnswer((_) async => _carrierName);
  when(carrierInfo.getRadioType()).thenAnswer((_) async => _radioType);
  when(carrierInfo.getNetworkGeneration())
      .thenAnswer((_) async => _networkGeneration);
  when(GetIt.I.get<Connectivity>().onConnectivityChanged)
      .thenAnswer((_) => Stream.empty());
  when(GetIt.I.get<Connectivity>().checkConnectivity())
      .thenAnswer((_) async => result);
  when(GetIt.I.get<PlatformWrapper>().isAndroid).thenAnswer((_) => isAndroid);
}
