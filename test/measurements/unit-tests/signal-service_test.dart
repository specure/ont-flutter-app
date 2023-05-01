import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/cell-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/permissions-map.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/signal-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/carrier-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/cell-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/wifi-for-iot-plugin.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/ip-info.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurements.api.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/permissions.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/signal.service.dart';

import '../../di/service-locator.dart';

const _ipV4PublicAddress = 'Address is not available';
const _ipV4PrivateAddress = 'Address is not available';
const _ipV6Address = 'Address is not available';
const _ssid = 'SSID';
const _frequency = 2400;
const _signalStrength = -50;
const _carrierName = 'Provider';
const _radioType = 'LTE';
const _networkGeneration = '4g';
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
            'test/measurements/unit-tests/data/allPrimaryDataCellSignalInfo3gHspa.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();
List<SignalInfo> _allSignals2gEdge = (jsonDecode(File(
            'test/measurements/unit-tests/data/allPrimaryDataCellSignalInfo2gEdge.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();
List<SignalInfo> _primarySignals5gNrNsaFromLteNr = (jsonDecode(File(
            'test/measurements/unit-tests/data/primaryPrimaryDataCellSignalInfoNrLte.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();
List<SignalInfo> _primarySignals5gNrNsaFromLteNrCa = (jsonDecode(File(
            'test/measurements/unit-tests/data/primaryPrimaryDataCellSignalInfoNrLteCa.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();
List<SignalInfo> _primarySignals4gPlus5g = (jsonDecode(File(
            'test/measurements/unit-tests/data/primaryPrimaryDataCellSignalInfo4gPlus5g.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();
List<SignalInfo> _primarySignals4gLteCa = (jsonDecode(File(
            'test/measurements/unit-tests/data/primaryPrimaryDataCellSignalInfo4gLteCa.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();
List<SignalInfo> _primarySignals3gHspa = (jsonDecode(File(
            'test/measurements/unit-tests/data/primaryPrimaryDataCellSignalInfo3gHspa.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();
List<SignalInfo> _primarySignals2gEdge = (jsonDecode(File(
            'test/measurements/unit-tests/data/primaryPrimaryDataCellSignalInfo2gEdge.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();

CellInfoModel _cellInfoModel4g = CellInfoModel.fromJson(jsonDecode(
    File('test/measurements/unit-tests/data/cellInfoModel4g.json')
        .readAsStringSync()));
CellInfoModel _cellInfoModel4gOnly = CellInfoModel.fromJson(jsonDecode(
    File('test/measurements/unit-tests/data/cellInfoModel4gOnly.json')
        .readAsStringSync()));
CellInfoModel _cellInfoModel3g = CellInfoModel.fromJson(jsonDecode(
    File('test/measurements/unit-tests/data/cellInfoModel3g.json')
        .readAsStringSync()));
CellInfoModel _cellInfoModel2g = CellInfoModel.fromJson(jsonDecode(
    File('test/measurements/unit-tests/data/cellInfoModel2g.json')
        .readAsStringSync()));

const _dualSimInfo =
    '{"simInfoList":[{"carrierName":"O2 - SK","displayName":"Orange","countryIso":"UK","roaming":true,"isDefaultDataSubscription":true,"mcc":231,"mnc":5,"subscriptionId":2,"subscriptionInfoNumber":""},{"carrierName":"Orange SK","displayName":"A1","isDefaultDataSubscription":false,"mcc":232,"mnc":1,"subscriptionId":1,"subscriptionInfoNumber":""}]}';
const _singleSimInfo =
    '{"simInfoList":[{"carrierName":"O2 - SK","displayName":"Orange","countryIso":"UK","roaming":true,"isDefaultDataSubscription":true,"mcc":231,"mnc":5,"subscriptionId":2,"subscriptionInfoNumber":""}]}';
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

CarrierInfoWrapper _carrierInfo = CarrierInfoWrapper();
WifiForIoTPluginWrapper _wifiPlugin = WifiForIoTPluginWrapper();
IPInfoService _networkInterface = IPInfoService();
late final SignalService signalService;

@GenerateMocks([
  MeasurementsApiService,
  WifiForIoTPluginWrapper,
  CarrierInfoWrapper,
  CellInfoWrapper,
  IPInfoService,
  Connectivity,
  PlatformWrapper,
])
void main() {
  setUpAll(() {
    TestingServiceLocator.registerInstances();
    signalService = SignalService();
    when(GetIt.I.get<PermissionsService>().permissionsMap).thenReturn(
      PermissionsMap(
        locationPermissionsGranted: true,
        readPhoneStatePermissionsGranted: true,
        preciseLocationPermissionsGranted: true,
      ),
    );
  });

  group('Android mobile network tests', () {
    test('Test 5G NSA with LTE Details with Mobile', () async {
      await _testAndroid5gNsaFromLteNetworkDetails(
          signalService, ConnectivityResult.mobile);
    });
    test('Test 5G NSA with LTE CA Details with Mobile', () async {
      await _testAndroid5gNsaFromLteCaNetworkDetails(
          signalService, ConnectivityResult.mobile);
    });
    test('Test 4G+5G Details with Mobile', () async {
      await _testAndroid4gPlus5gNetworkDetails(
          signalService, ConnectivityResult.mobile);
    });
    test('Test 4G LTE CA Details with Mobile', () async {
      await _testAndroid4gLteCaNetworkDetails(
          signalService, ConnectivityResult.mobile);
    });
    test('Test 3G HSPDA+ Details with Mobile', () async {
      await _testAndroid3gHspaNetworkDetails(
          signalService, ConnectivityResult.mobile);
    });
    test('Test 2G EDGE Details with Mobile', () async {
      await _testAndroid2gEdgeNetworkDetails(
          signalService, ConnectivityResult.mobile);
    });
    test('Test Single sim 2G EDGE Details with Mobile', () async {
      await _testAndroid2gEdgeSingleSimNetworkDetails(
          signalService, ConnectivityResult.mobile);
    });
    test('Get primary cell 2G', () async {
      await _testGetPrimaryCell2G(signalService, ConnectivityResult.mobile);
    });
    test('Get primary cell 3G', () async {
      await _testGetPrimaryCell3G(signalService, ConnectivityResult.mobile);
    });
    test('Get primary cell 4G', () async {
      await _testGetPrimaryCell4G(signalService, ConnectivityResult.mobile);
    });
    test('Get primary cell 4G+5G', () async {
      await _testGetPrimaryCell4GPlus5G(
          signalService, ConnectivityResult.mobile);
    });
    test('Get primary cell 5G NSA (with LTE)', () async {
      await _testGetPrimaryCell5GLte(signalService, ConnectivityResult.mobile);
    });
    test('Get primary cell 5G NSA (with LTE CA)', () async {
      await _testGetPrimaryCell5GLteCa(
          signalService, ConnectivityResult.mobile);
    });
    test('Test current signal info 2G', () async {
      await _testCurrentSignalInfo2g(signalService);
    });
    test('Test current signal info 3G', () async {
      await _testCurrentSignalInfo3g(signalService);
    });
    test('Test current signal info 4G', () async {
      await _testCurrentSignalInfo4g(signalService);
    });
    test('Test current signal info 4G+5G', () async {
      await _testCurrentSignalInfo4g5g(signalService);
    });
    test('Test current signal info 5G LTE', () async {
      await _testCurrentSignalInfo5gLte(signalService);
    });
    test('Test current signal info 5G LTE CA', () async {
      await _testCurrentSignalInfo5gLteCa(signalService);
    });
  });
}

Future _testGetPrimaryCell2G(
    SignalService signalService, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid2gEdgeCellDataStub();
  var cellInfo = await signalService.getPrimaryCellInfo();
  expect(cellInfo, _cellInfoModel2g);
}

Future _testGetPrimaryCell3G(
    SignalService signalService, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid3gHspaCellDataStub();
  var cellInfo = await signalService.getPrimaryCellInfo();
  expect(cellInfo, _cellInfoModel3g);
}

Future _testGetPrimaryCell4G(
    SignalService signalService, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid4gLteCaCellDataStub();
  var cellInfo = await signalService.getPrimaryCellInfo();
  expect(cellInfo, _cellInfoModel4gOnly);
}

Future _testGetPrimaryCell4GPlus5G(
    SignalService signalService, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid4gPlus5gCellDataStub();
  var cellInfo = await signalService.getPrimaryCellInfo();
  expect(cellInfo, _cellInfoModel4g);
}

Future _testGetPrimaryCell5GLte(
    SignalService signalService, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid5gNsaFromLteCellDataStub();
  var cellInfo = await signalService.getPrimaryCellInfo();
  expect(cellInfo, _cellInfoModel4g);
}

Future _testGetPrimaryCell5GLteCa(
    SignalService signalService, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid5gNsaFromLteCaCellDataStub();
  var cellInfo = await signalService.getPrimaryCellInfo();
  expect(cellInfo, _cellInfoModel4g);
}

Future _testAndroid5gNsaFromLteNetworkDetails(
    SignalService signalService, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid5gNsaFromLteCellDataStub();
  var allNetworkDetails = await signalService.getCurrentMobileNetworkDetails();
  var networkDetails = allNetworkDetails.copyWith(currentAllSignalInfo: []);
  expect(
    networkDetails,
    NetworkInfoDetails(
        type: networkType == ConnectivityResult.wifi ? wifi : _radioTypeNSA,
        name: networkType == ConnectivityResult.wifi
            ? _ssid
            : _androidCarrierName,
        mobileNetworkGeneration: networkType == ConnectivityResult.wifi
            ? unknown
            : _networkGeneration5G,
        ipV4PrivateAddress: _ipV4PrivateAddress,
        ipV4PublicAddress: _ipV4PublicAddress,
        ipV6PrivateAddress: _ipV6Address,
        ipV6PublicAddress: _ipV6Address,
        isDualSim: true,
        telephonyNetworkCountry: "SK",
        telephonyNetworkOperator: "231-06",
        telephonyNetworkOperatorName: "O2 - SK",
        telephonyNetworkSimOperator: "231-05",
        telephonyNetworkSimOperatorName: "Orange",
        telephonyNetworkSimCountry: "UK",
        telephonyNetworkIsRoaming: true),
  );
}

Future _testAndroid5gNsaFromLteCaNetworkDetails(
    SignalService service, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid5gNsaFromLteCaCellDataStub();
  final allNetworkDetails = await service.getCurrentMobileNetworkDetails();
  var networkDetails = allNetworkDetails.copyWith(currentAllSignalInfo: []);
  expect(
    networkDetails,
    NetworkInfoDetails(
        type: networkType == ConnectivityResult.wifi ? wifi : _radioTypeNSA,
        name: networkType == ConnectivityResult.wifi
            ? _ssid
            : _androidCarrierName,
        mobileNetworkGeneration: networkType == ConnectivityResult.wifi
            ? unknown
            : _networkGeneration5G,
        ipV4PrivateAddress: _ipV4PrivateAddress,
        ipV4PublicAddress: _ipV4PublicAddress,
        ipV6PrivateAddress: _ipV6Address,
        ipV6PublicAddress: _ipV6Address,
        isDualSim: true,
        telephonyNetworkCountry: "SK",
        telephonyNetworkOperator: "231-06",
        telephonyNetworkOperatorName: "O2 - SK",
        telephonyNetworkSimOperator: "231-05",
        telephonyNetworkSimOperatorName: "Orange",
        telephonyNetworkSimCountry: "UK",
        telephonyNetworkIsRoaming: true),
  );
}

Future _testAndroid4gLteCaNetworkDetails(
    SignalService service, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid4gLteCaCellDataStub();
  final allNetworkDetails = await service.getCurrentMobileNetworkDetails();
  var networkDetails = allNetworkDetails.copyWith(currentAllSignalInfo: []);
  expect(
    networkDetails,
    NetworkInfoDetails(
        type: networkType == ConnectivityResult.wifi ? wifi : _radioTypeLTE,
        name: networkType == ConnectivityResult.wifi
            ? _ssid
            : _androidCarrierName,
        mobileNetworkGeneration: networkType == ConnectivityResult.wifi
            ? unknown
            : _networkGeneration4G,
        ipV4PrivateAddress: _ipV4PrivateAddress,
        ipV4PublicAddress: _ipV4PublicAddress,
        ipV6PrivateAddress: _ipV6Address,
        ipV6PublicAddress: _ipV6Address,
        isDualSim: true,
        telephonyNetworkCountry: "SK",
        telephonyNetworkOperator: "231-06",
        telephonyNetworkOperatorName: "O2 - SK",
        telephonyNetworkSimOperator: "231-05",
        telephonyNetworkSimOperatorName: "Orange",
        telephonyNetworkSimCountry: "UK",
        telephonyNetworkIsRoaming: true),
  );
}

Future _testAndroid4gPlus5gNetworkDetails(
    SignalService service, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid4gPlus5gCellDataStub();
  final allNetworkDetails = await service.getCurrentMobileNetworkDetails();
  var networkDetails = allNetworkDetails.copyWith(currentAllSignalInfo: []);
  expect(
    networkDetails,
    NetworkInfoDetails(
        type: networkType == ConnectivityResult.wifi ? wifi : _radioTypeLTENR,
        name: networkType == ConnectivityResult.wifi
            ? _ssid
            : _androidCarrierName,
        mobileNetworkGeneration: networkType == ConnectivityResult.wifi
            ? unknown
            : _networkGeneration4G5G,
        ipV4PrivateAddress: _ipV4PrivateAddress,
        ipV4PublicAddress: _ipV4PublicAddress,
        ipV6PrivateAddress: _ipV6Address,
        ipV6PublicAddress: _ipV6Address,
        isDualSim: true,
        telephonyNetworkCountry: "SK",
        telephonyNetworkOperator: "231-06",
        telephonyNetworkOperatorName: "O2 - SK",
        telephonyNetworkSimOperator: "231-05",
        telephonyNetworkSimOperatorName: "Orange",
        telephonyNetworkSimCountry: "UK",
        telephonyNetworkIsRoaming: true),
  );
}

Future _testAndroid3gHspaNetworkDetails(
    SignalService service, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid3gHspaCellDataStub();
  final allNetworkDetails = await service.getCurrentMobileNetworkDetails();
  var networkDetails = allNetworkDetails.copyWith(currentAllSignalInfo: []);
  expect(
    networkDetails,
    NetworkInfoDetails(
        type: networkType == ConnectivityResult.wifi ? wifi : _radioTypeHSPA,
        name: networkType == ConnectivityResult.wifi
            ? _ssid
            : _androidCarrierName,
        mobileNetworkGeneration: networkType == ConnectivityResult.wifi
            ? unknown
            : _networkGeneration3G,
        ipV4PrivateAddress: _ipV4PrivateAddress,
        ipV4PublicAddress: _ipV4PublicAddress,
        ipV6PrivateAddress: _ipV6Address,
        ipV6PublicAddress: _ipV6Address,
        isDualSim: true,
        telephonyNetworkCountry: "SK",
        telephonyNetworkOperator: "231-06",
        telephonyNetworkOperatorName: "O2 - SK",
        telephonyNetworkSimOperator: "231-05",
        telephonyNetworkSimOperatorName: "Orange",
        telephonyNetworkSimCountry: "UK",
        telephonyNetworkIsRoaming: true),
  );
}

Future _testAndroid2gEdgeNetworkDetails(
    SignalService service, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid2gEdgeCellDataStub();
  final allNetworkDetails = await service.getCurrentMobileNetworkDetails();
  var networkDetails = allNetworkDetails.copyWith(currentAllSignalInfo: []);
  expect(
    networkDetails,
    NetworkInfoDetails(
        type: networkType == ConnectivityResult.wifi ? wifi : _radioTypeEdge,
        name: networkType == ConnectivityResult.wifi
            ? _ssid
            : _androidCarrierName,
        mobileNetworkGeneration: networkType == ConnectivityResult.wifi
            ? unknown
            : _networkGeneration2G,
        ipV4PrivateAddress: _ipV4PrivateAddress,
        ipV4PublicAddress: _ipV4PublicAddress,
        ipV6PrivateAddress: _ipV6Address,
        ipV6PublicAddress: _ipV6Address,
        isDualSim: true,
        telephonyNetworkCountry: "SK",
        telephonyNetworkOperator: "231-06",
        telephonyNetworkOperatorName: "O2 - SK",
        telephonyNetworkSimOperator: "231-05",
        telephonyNetworkSimOperatorName: "Orange",
        telephonyNetworkSimCountry: "UK",
        telephonyNetworkIsRoaming: true),
  );
}

Future _testAndroid2gEdgeSingleSimNetworkDetails(
    SignalService service, ConnectivityResult networkType) async {
  _setUpStubs(isAndroid: true, result: networkType);
  _setUpAndroid2gEdgeCellSingleSimDataStub();
  when(_carrierInfo.getIsDualSim()).thenAnswer((_) async => false);
  final allNetworkDetails = await service.getCurrentMobileNetworkDetails();
  var networkDetails = allNetworkDetails.copyWith(currentAllSignalInfo: []);
  expect(
    networkDetails,
    NetworkInfoDetails(
        type: networkType == ConnectivityResult.wifi ? wifi : _radioTypeEdge,
        name: networkType == ConnectivityResult.wifi
            ? _ssid
            : _androidCarrierName,
        mobileNetworkGeneration: networkType == ConnectivityResult.wifi
            ? unknown
            : _networkGeneration2G,
        ipV4PrivateAddress: _ipV4PrivateAddress,
        ipV4PublicAddress: _ipV4PublicAddress,
        ipV6PrivateAddress: _ipV6Address,
        ipV6PublicAddress: _ipV6Address,
        isDualSim: false,
        telephonyNetworkCountry: "SK",
        telephonyNetworkOperator: "231-06",
        telephonyNetworkOperatorName: "O2 - SK",
        telephonyNetworkSimOperator: "231-05",
        telephonyNetworkSimOperatorName: "Orange",
        telephonyNetworkSimCountry: "UK",
        telephonyNetworkIsRoaming: true),
  );
}

Future _testCurrentSignalInfo2g(SignalService signalService) async {
  _setUpStubs(
    isAndroid: true,
    result: ConnectivityResult.mobile,
  );
  _setUpAndroid2gEdgeCellDataStub();
  final signals = await signalService.getCurrentSignalInfo(0);
  final signalsAll = await signalService.getPrimaryDataSignalInfo(CellType.ALL);
  final signalsPrimaryOnly =
      await signalService.getPrimaryDataSignalInfo(CellType.CONNECTED_ONLY);
  expect(signals, _primarySignals2gEdge);
  expect(signalsAll, _allSignals2gEdge);
  expect(signalsPrimaryOnly, _primarySignals2gEdge);
}

Future _testCurrentSignalInfo3g(SignalService signalService) async {
  _setUpStubs(
    isAndroid: true,
    result: ConnectivityResult.mobile,
  );
  _setUpAndroid3gHspaCellDataStub();
  final signals = await signalService.getCurrentSignalInfo(0);
  final signalsAll = await signalService.getPrimaryDataSignalInfo(CellType.ALL);
  final signalsPrimaryOnly =
      await signalService.getPrimaryDataSignalInfo(CellType.CONNECTED_ONLY);
  expect(signals, _primarySignals3gHspa);
  expect(signalsAll, _allSignals3gHspa);
  expect(signalsPrimaryOnly, _primarySignals3gHspa);
}

Future _testCurrentSignalInfo4g(SignalService signalService) async {
  _setUpStubs(
    isAndroid: true,
    result: ConnectivityResult.mobile,
  );
  _setUpAndroid4gLteCaCellDataStub();
  final signals = await signalService.getCurrentSignalInfo(0);
  final signalsAll = await signalService.getPrimaryDataSignalInfo(CellType.ALL);
  final signalsPrimaryOnly =
      await signalService.getPrimaryDataSignalInfo(CellType.CONNECTED_ONLY);
  expect(signals, _primarySignals4gLteCa);
  expect(signalsAll, _allSignals4gLteCa);
  expect(signalsPrimaryOnly, _primarySignals4gLteCa);
}

Future _testCurrentSignalInfo4g5g(SignalService signalService) async {
  _setUpStubs(
    isAndroid: true,
    result: ConnectivityResult.mobile,
  );
  _setUpAndroid4gPlus5gCellDataStub();
  final signals = await signalService.getCurrentSignalInfo(0);
  final signalsAll = await signalService.getPrimaryDataSignalInfo(CellType.ALL);
  final signalsPrimaryOnly =
      await signalService.getPrimaryDataSignalInfo(CellType.CONNECTED_ONLY);
  expect(signals, _primarySignals4gPlus5g);
  expect(signalsAll, _allSignals4gPlus5g);
  expect(signalsPrimaryOnly, _primarySignals4gPlus5g);
}

Future _testCurrentSignalInfo5gLte(SignalService signalService) async {
  _setUpStubs(
    isAndroid: true,
    result: ConnectivityResult.mobile,
  );
  _setUpAndroid5gNsaFromLteCellDataStub();
  final signals = await signalService.getCurrentSignalInfo(0);
  final signalsAll = await signalService.getPrimaryDataSignalInfo(CellType.ALL);
  final signalsPrimaryOnly =
      await signalService.getPrimaryDataSignalInfo(CellType.CONNECTED_ONLY);
  expect(signals, _primarySignals5gNrNsaFromLteNr);
  expect(signalsAll, _allSignals5gNrNsaFromLteNr);
  expect(signalsPrimaryOnly, _primarySignals5gNrNsaFromLteNr);
}

Future _testCurrentSignalInfo5gLteCa(SignalService signalService) async {
  _setUpStubs(
    isAndroid: true,
    result: ConnectivityResult.mobile,
  );
  _setUpAndroid5gNsaFromLteCaCellDataStub();
  final signals = await signalService.getCurrentSignalInfo(0);
  final signalsAll = await signalService.getPrimaryDataSignalInfo(CellType.ALL);
  final signalsPrimaryOnly =
      await signalService.getPrimaryDataSignalInfo(CellType.CONNECTED_ONLY);
  expect(signals, _primarySignals5gNrNsaFromLteNrCa);
  expect(signalsAll, _allSignals5gNrNsaFromLteNrCa);
  expect(signalsPrimaryOnly, _primarySignals5gNrNsaFromLteNrCa);
}

_setUpAndroid5gNsaFromLteCellDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getSimInfo()).thenAnswer((_) async => _dualSimInfo);
  when(cellInfo.getCellInfo())
      .thenAnswer((_) async => _cellInfoDualSim5gNrNsaFromLteNrJsonString);
}

_setUpAndroid5gNsaFromLteCaCellDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getSimInfo()).thenAnswer((_) async => _dualSimInfo);
  when(cellInfo.getCellInfo())
      .thenAnswer((_) async => _cellInfoDualSim5gNrNsaFromLteCaNrJsonString);
}

_setUpAndroid4gPlus5gCellDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getSimInfo()).thenAnswer((_) async => _dualSimInfo);
  when(cellInfo.getCellInfo())
      .thenAnswer((_) async => _cellInfoDualSim4gPlus5gJsonString);
}

_setUpAndroid4gLteCaCellDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getSimInfo()).thenAnswer((_) async => _dualSimInfo);
  when(cellInfo.getCellInfo())
      .thenAnswer((_) async => _cellInfoDualSim4gLteCaJsonString);
}

_setUpAndroid3gHspaCellDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getSimInfo()).thenAnswer((_) async => _dualSimInfo);
  when(cellInfo.getCellInfo())
      .thenAnswer((_) async => _cellInfoDualSim3gHspaJsonString);
}

_setUpAndroid2gEdgeCellDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getSimInfo()).thenAnswer((_) async => _dualSimInfo);
  when(cellInfo.getCellInfo())
      .thenAnswer((_) async => _cellInfoDualSim2gEdgeJsonString);
}

_setUpAndroid2gEdgeCellSingleSimDataStub() {
  final cellInfo = GetIt.I.get<CellInfoWrapper>();
  when(cellInfo.getSimInfo()).thenAnswer((_) async => _singleSimInfo);
  when(cellInfo.getCellInfo())
      .thenAnswer((_) async => _cellInfoDualSim2gEdgeJsonString);
}

_setUpStubs({
  bool isAndroid = true,
  required ConnectivityResult result,
}) {
  _wifiPlugin = GetIt.I.get<WifiForIoTPluginWrapper>();
  _carrierInfo = GetIt.I.get<CarrierInfoWrapper>();
  _networkInterface = GetIt.I.get<IPInfoService>();

  when(GetIt.I.get<LocationService>().isLocationServiceEnabled)
      .thenAnswer((_) async => true);
  when(_networkInterface.getPublicAddress(IPVersion.v4))
      .thenAnswer((_) async => _ipV4PublicAddress);
  when(_networkInterface.getPublicAddress(IPVersion.v6))
      .thenAnswer((_) async => _ipV6Address);
  when(_networkInterface.getPrivateAddress(IPVersion.v4))
      .thenAnswer((_) async => _ipV4PrivateAddress);
  when(_networkInterface.getPrivateAddress(IPVersion.v6))
      .thenAnswer((_) async => _ipV6Address);
  when(_wifiPlugin.getSSID()).thenAnswer((_) async => _ssid);
  when(_wifiPlugin.getFrequency()).thenAnswer((_) async => _frequency);
  when(_wifiPlugin.getCurrentSignalStrength())
      .thenAnswer((_) async => _signalStrength);
  when(_carrierInfo.getCarrierName()).thenAnswer((_) async => _carrierName);
  when(_carrierInfo.getRadioType()).thenAnswer((_) async => _radioType);
  when(_carrierInfo.getNetworkGeneration())
      .thenAnswer((_) async => _networkGeneration);
  when(_carrierInfo.getIsDualSim()).thenAnswer((_) async => true);
  when(GetIt.I.get<Connectivity>().onConnectivityChanged)
      .thenAnswer((_) => Stream.empty());
  when(GetIt.I.get<Connectivity>().checkConnectivity())
      .thenAnswer((_) async => result);
  when(GetIt.I.get<PlatformWrapper>().isAndroid).thenAnswer((_) => isAndroid);
  when(GetIt.I.get<PermissionsService>().isPhonePermissionGranted)
      .thenAnswer((_) async => true);
}
