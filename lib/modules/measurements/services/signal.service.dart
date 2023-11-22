import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/cell-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/signal-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/wrappers/carrier-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/wrappers/cell-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/wrappers/wifi-for-iot-plugin.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/permissions.service.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';

enum CellType { ALL, CONNECTED_ONLY }

class SignalService {
  static const UNKNOWN = -1;

  final CellInfoWrapper cellPlugin = GetIt.I.get<CellInfoWrapper>();
  final PlatformWrapper platform = GetIt.I.get<PlatformWrapper>();
  final PermissionsService permission = GetIt.I.get<PermissionsService>();
  final CarrierInfoWrapper carrierPlugin = GetIt.I.get<CarrierInfoWrapper>();
  final Connectivity connectivity = GetIt.I.get<Connectivity>();
  final WifiForIoTPluginWrapper wifiPlugin =
      GetIt.I.get<WifiForIoTPluginWrapper>();
  final LocationService _locationService = GetIt.I.get<LocationService>();

  Future<NetworkInfoDetails> getCurrentMobileNetworkDetails() async {
    var networkInfoDetails = NetworkInfoDetails();
    String? networkGeneration = await carrierPlugin.getNetworkGeneration();
    String? radioType = await carrierPlugin.getRadioType();
    String? carrierName = await carrierPlugin.getCarrierName();
    var isDualSim = await carrierPlugin.getIsDualSim();
    if (await isEnoughPermissionGranted()) {
      final cellsInfoData = await cellPlugin.getCellInfo();
      final simsInfoData = await cellPlugin.getSimInfo();
      var subscriptionId = _getPrimaryDataSubscriptionId(simsInfoData);
      final primarySimInfoData = _getPrimaryDataSimInfo(simsInfoData);
      networkInfoDetails = networkInfoDetails.copyWith(
        telephonyNetworkSimOperatorName: primarySimInfoData?['displayName'],
        telephonyNetworkSimCountry: primarySimInfoData?['countryIso'],
        telephonyNetworkIsRoaming: primarySimInfoData?['roaming'],
        telephonyNetworkOperatorName: primarySimInfoData?['carrierName'],
      );
      if (primarySimInfoData?['mcc'] != null &&
          primarySimInfoData?['mnc'] != null) {
        networkInfoDetails = networkInfoDetails.copyWith(
          telephonyNetworkSimOperator:
              "${primarySimInfoData['mcc']}-${sprintf("%02d", [
                primarySimInfoData['mnc']
              ])}",
        );
      }
      final primaryConnectedCellData =
          await _getConnectedCellInfosForSubscription(
              subscriptionId, cellsInfoData);
      if (primaryConnectedCellData.isNotEmpty &&
          primaryConnectedCellData[0]
                  [primaryConnectedCellData[0]['type']?.toLowerCase()] !=
              null &&
          primaryConnectedCellData[0]
                      [primaryConnectedCellData[0]['type']?.toLowerCase()]
                  ['network'] !=
              null) {
        networkInfoDetails = networkInfoDetails.copyWith(
          telephonyNetworkCountry: primaryConnectedCellData[0]
                  [primaryConnectedCellData[0]['type']?.toLowerCase()]
              ['network']['iso'],
          telephonyNetworkOperator:
              "${primaryConnectedCellData[0][primaryConnectedCellData[0]['type']?.toLowerCase()]['network']['mcc']}-${primaryConnectedCellData[0][primaryConnectedCellData[0]['type']?.toLowerCase()]['network']['mnc']}",
        );
        carrierName = _getPrimaryDataSubscriptionCarrierName(simsInfoData);
        networkGeneration = _getMobileTechnologyGenerationForSubscription(
            cellsInfoData, subscriptionId);
        radioType = _getMobileTechnologyForSubscriptionId(
            cellsInfoData, subscriptionId);
        if (networkGeneration == '5G') {
          if (radioType != 'NR') {
            radioType = 'NSA';
          }
        }
      }
    }
    networkInfoDetails = networkInfoDetails.copyWith(
      type: radioType == unknown ? mobile : radioType,
      mobileNetworkGeneration: networkGeneration,
      name: carrierName,
      isDualSim: isDualSim,
    );
    return networkInfoDetails;
  }

  Future<List<SignalInfo>?>? getCurrentSignalInfo(int startTime) async {
    List<SignalInfo>? signalInfo;
    if (await isEnoughPermissionGranted()) {
      signalInfo = await getPrimaryDataSignalInfo(CellType.CONNECTED_ONLY);
      signalInfo.forEach((element) {
        element.copyWithTimeNs(
          timeNs: DateTime.now().millisecondsSinceEpoch - startTime,
        );
      });
    }
    return signalInfo;
  }

  Future<CellInfoModel?> getPrimaryCellInfo() async {
    if (await isEnoughPermissionGranted()) {
      final simsInfoData = await cellPlugin.getSimInfo();
      final primaryDataSubscriptionId =
          _getPrimaryDataSubscriptionId(simsInfoData);
      final cellsInfoData = await cellPlugin.getCellInfo();
      final list = await _getConnectedCellInfosForSubscription(
          primaryDataSubscriptionId, cellsInfoData);
      final cell = list.isNotEmpty ? list.first : null;
      var cellTechnology;
      if (platform.isAndroid) {
        cellTechnology = _getTechnologyGenerationFromCell(cell)?.toLowerCase();
      } else {
        cellTechnology = await carrierPlugin.getNetworkGeneration();
      }
      final currentNetwork = await connectivity.checkConnectivity();
      CellInfoModel? cellInfo;
      if (cell?['type'] != null) {
        String networkType = (cell['type'] as String).toLowerCase();
        cellInfo = CellInfoModel(
          active: true,
          registered: true,
          areaCode: _getAreaCode(cell, networkType),
          channelNumber: cell[networkType]?['band${networkType.toUpperCase()}']
              ?['channelNumber'],
          primaryDataSubscription: true,
          locationId: _getLocationId(cell, networkType),
          mcc: int.parse(cell[networkType]?['network']?['mcc'] ?? '0'),
          mnc: int.parse(cell[networkType]?['network']?['mnc'] ?? '0'),
          primaryScramblingCode: _getPrimaryScramblingCode(cell, networkType),
          technology: currentNetwork == ConnectivityResult.mobile
              ? cellTechnology
              : wifi,
          uuid: _getCellUuid(networkType, cell[networkType]?['cid']),
        );
      }
      return cellInfo;
    }
    return null;
  }

  /// Returns all signals detected by primary data connection according to cellType in case of mobile connection, connected cell in case of wifi
  Future<List<SignalInfo>> getPrimaryDataSignalInfo(CellType cellType) async {
    final currentNetwork = await connectivity.checkConnectivity();
    if (currentNetwork == ConnectivityResult.wifi) {
      return await _getWifiSignalInfo();
    } else if (currentNetwork == ConnectivityResult.mobile) {
      if (await isEnoughPermissionGranted()) {
        final simsInfoData = await cellPlugin.getSimInfo();
        final subscriptionId = _getPrimaryDataSubscriptionId(simsInfoData);
        final cellsInfoData = await cellPlugin.getCellInfo();
        var allPrimaryDataCellInfos;
        switch (cellType) {
          case CellType.ALL:
            final connectedDataCellInfos =
                await _getConnectedCellInfosForSubscription(
                    subscriptionId, cellsInfoData);
            final neighbouringDataCellInfos =
                await _getNeighbouringCellInfosForSubscription(
                    subscriptionId, cellsInfoData);
            allPrimaryDataCellInfos =
                connectedDataCellInfos + neighbouringDataCellInfos;
            break;
          case CellType.CONNECTED_ONLY:
            allPrimaryDataCellInfos =
                await _getConnectedCellInfosForSubscription(
                    subscriptionId, cellsInfoData);
            break;
        }
        final networkTechnology =
            (subscriptionId == UNKNOWN || allPrimaryDataCellInfos.isEmpty)
                ? null
                : _getTechnologyFromPrimaryCell(allPrimaryDataCellInfos[0]);
        return await _getMobileSignalInfo(
            allPrimaryDataCellInfos, networkTechnology);
      }
    }
    return [];
  }

  Future<List<SignalInfo>> _getWifiSignalInfo() async {
    return [
      SignalInfo(
        signal: (await wifiPlugin.getCurrentSignalStrength())!,
        band: (await wifiPlugin.getFrequency())!.toString(),
        technology: wifi,
        networkTypeId: serverNetworkTypes[wifi]!,
      )
    ];
  }

  /// get cells info for passed subscription ID, if subscription ID is UNKNOWN, then returns cells for all subscriptions
  Future<List<dynamic>> _getNeighbouringCellInfosForSubscription(
      int subscriptionId, dynamic cellsInfoData) async {
    var secondaryCells = _getSecondaryCells(cellsInfoData);
    var neighbouringDataCellsForSubscription = [];
    secondaryCells.forEach((element) {
      String? type = element['type'];
      if (type != null) {
        type = type.toLowerCase();
        if (subscriptionId == UNKNOWN ||
            element[type]?['subscriptionId'] == subscriptionId) {
          neighbouringDataCellsForSubscription.add(element);
        }
      }
    });
    return neighbouringDataCellsForSubscription;
  }

  Future<List<dynamic>> _getConnectedCellInfosForSubscription(
      int subscriptionId, dynamic cellsInfoData) async {
    var primaryCells = _getPrimaryCells(cellsInfoData);
    var primaryDataCellsForSubscription = [];
    primaryCells.forEach((element) {
      String? type = element['type'];
      if (type != null) {
        type = type.toLowerCase();
        if (subscriptionId == UNKNOWN ||
            element[type]?['subscriptionId'] == subscriptionId) {
          primaryDataCellsForSubscription.add(element);
        }
      }
    });
    return primaryDataCellsForSubscription;
  }

  Future<List<SignalInfo>> _getMobileSignalInfo(
      dynamic cells, String? technology) async {
    var cellsWithSignal = _removeCellsWithoutSignal(cells);
    if (cellsWithSignal.isNotEmpty) {
      return cellsWithSignal.map<SignalInfo>((item) {
        SignalInfo? signalInfo = SignalInfo(technology: unknown);
        String? type = item['type'];
        if (type != null) {
          type = type.toLowerCase();
          signalInfo = SignalInfo(
            cellUuid: _getCellUuid(
              item[type]?['type'] ?? unknown,
              item[type]?['cid'] ?? 0,
            ),
            isPrimaryCell:
                item[type]?['connectionStatus'] == "PrimaryConnection()",
            signal: _getSignalValue(item),
            band: item[type]?['band${type.toUpperCase()}']?['name'],
            technology: item[type]?['type'] ?? unknown,
            networkTypeId:
                serverNetworkTypes[technology] ?? serverNetworkTypes[unknown]!,
            timingAdvance:
                type == 'lte' ? item[type]['signalLTE']['timingAdvance'] : 0,
            lteCqi: type == 'lte' ? item[type]['signalLTE']['cqi'] : 0,
            lteRsrp: type == 'lte' ? item[type]['signalLTE']['rsrp'] : 0,
            lteRsrq: type == 'lte' ? item[type]['signalLTE']['rsrq'] : 0,
            lteRssnr: type == 'lte' ? item[type]['signalLTE']['snr'] : 0,
          );
        }
        return signalInfo;
      }).toList();
    }
    return [];
  }

  List<dynamic> _removeCellsWithoutSignal(dynamic cells) {
    var cellsWithSignals = [];
    cells.forEach((item) {
      final signalValue = _getSignalValue(item);
      if (signalValue != null && signalValue < 0) {
        cellsWithSignals.add(item);
      }
    });
    return cellsWithSignals;
  }

  int? _getSignalValue(dynamic cell) {
    var signal;
    String? type = cell?['type'];
    if (type != null) {
      type = type.toLowerCase();
      switch (cell[type]?['type']) {
        case 'NR':
          signal = cell[type]['signalNR']?['ssRsrp']?.toInt();
          break;
        case 'LTE':
          signal = cell[type]['signalLTE']?['rsrp']?.toInt();
          break;
        case 'TDSCDMA':
        case 'CDMA':
        case 'WCDMA':
        case 'GSM':
          signal = cell[type]?['signal${type.toUpperCase()}']?['dbm'];
          break;
      }
    }
    return signal;
  }

  int? _getAreaCode(dynamic cell, String type) {
    int? areaCode;
    switch (cell?['type']) {
      case 'NR':
      case 'LTE':
        areaCode = cell[type]?['tac'];
        break;
      case 'TDSCDMA':
        areaCode = cell[type]?['lac'];
        break;
      case 'CDMA':
        areaCode = cell[type]?['bid'];
        break;
      case 'WCDMA':
      case 'GSM':
        areaCode = cell[type]?['lac'];
        break;
    }
    return areaCode;
  }

  int? _getLocationId(dynamic cell, String type) {
    int? locationId;
    switch (cell?['type']) {
      case 'LTE':
        locationId = cell[type]?['eci'];
        break;
      case 'TDSCDMA':
        locationId = cell[type]?['cid'];
        break;
      case 'CDMA':
        locationId = cell[type]?['bid'];
        break;
      case 'WCDMA':
        locationId = cell[type]?['ci'];
        break;
      case 'GSM':
        locationId = cell[type]?['cid'];
        break;
    }
    return locationId;
  }

  int? _getPrimaryScramblingCode(dynamic cell, String type) {
    int? primaryScramblingCode;
    switch (cell?['type']) {
      case 'NR':
      case 'LTE':
        primaryScramblingCode = cell[type]?['pci'];
        break;
      case 'WCDMA':
        primaryScramblingCode = cell[type]?['psc'];
        break;
      case 'GSM':
        primaryScramblingCode = cell[type]?['bsic'];
        break;
    }
    return primaryScramblingCode;
  }

  List<dynamic> _getPrimaryCells(dynamic cellsInfoData) {
    if (cellsInfoData != null) {
      final cells = json.decode(cellsInfoData);
      if (cells['primaryCellList'] != null &&
          cells['primaryCellList']!.isNotEmpty) {
        return cells['primaryCellList'];
      }
    }
    return [];
  }

  List<dynamic> _getSecondaryCells(dynamic cellsInfoData) {
    if (cellsInfoData != null) {
      final cells = json.decode(cellsInfoData);
      if (cells['neighboringCellList'] != null &&
          cells['neighboringCellList']!.isNotEmpty) {
        return cells['neighboringCellList'];
      }
    }
    return [];
  }

  int _getPrimaryDataSubscriptionId(dynamic simsInfoData) {
    var primaryDataSubscriptionId = UNKNOWN;
    var primaryDataSimInfo = _getPrimaryDataSimInfo(simsInfoData);
    if (primaryDataSimInfo != null) {
      primaryDataSubscriptionId = primaryDataSimInfo['subscriptionId'];
    }
    return primaryDataSubscriptionId;
  }

  String? _getMobileTechnologyGenerationForSubscription(
      dynamic cellsInfoData, int subscriptionId) {
    if ((subscriptionId != UNKNOWN) && (cellsInfoData != null)) {
      var allPrimaryCells = _getPrimaryCells(cellsInfoData);
      var primaryDataCell = allPrimaryCells.firstWhere(
          (element) =>
              element[(element['type'] as String).toLowerCase()]
                  ?['subscriptionId'] ==
              subscriptionId,
          orElse: () => null);
      if (primaryDataCell != null) {
        String? primaryCellTechnologyGeneration =
            _getTechnologyGenerationFromCell(primaryDataCell);
        return _getNetworkTechnologyGenerationForPrimaryCell(
            primaryCellTechnologyGeneration, primaryDataCell);
      }
    }
    return null;
  }

  String? _getNetworkTechnologyGenerationForPrimaryCell(
      String? primaryCellTechnologyGeneration, primaryDataCell) {
    if (primaryCellTechnologyGeneration == '4G') {
      var nrAvailable = primaryDataCell['nrAvailable'];
      var nrConnected = primaryDataCell['nrConnected'];
      var nrConnectionStatus = primaryDataCell['nrConnectionStatus'];
      var nrRejectedReason = primaryDataCell['nrRejectedReason'];
      if (nrConnected != null && nrConnected) {
        return '5G';
      } else if (nrAvailable != null && nrAvailable) {
        if (nrConnectionStatus == "rejected" &&
            nrRejectedReason == "RESTRICTED") {
          return '4G';
        } else {
          return '4G+(5G)';
        }
      }
      return '4G';
    } else {
      return primaryCellTechnologyGeneration;
    }
  }

  String? _getMobileTechnologyForSubscriptionId(
      dynamic cellsInfoData, int subscriptionId) {
    if ((subscriptionId != UNKNOWN) && (cellsInfoData != null)) {
      var allPrimaryCells = _getPrimaryCells(cellsInfoData);
      var primaryDataCell = allPrimaryCells.firstWhere(
          (element) =>
              element[(element['type'] as String).toLowerCase()]
                  ?['subscriptionId'] ==
              subscriptionId,
          orElse: () => null);
      if (primaryDataCell != null) {
        String? primaryCellTechnologyGeneration =
            _getTechnologyFromPrimaryCell(primaryDataCell);
        return primaryCellTechnologyGeneration;
      }
    }
    return null;
  }

  String? _getPrimaryDataSubscriptionCarrierName(dynamic simsInfoData) {
    var primaryDataSubscriptionCarrierName;
    var primaryDataSimInfo = _getPrimaryDataSimInfo(simsInfoData);
    if (primaryDataSimInfo != null) {
      primaryDataSubscriptionCarrierName = primaryDataSimInfo['carrierName'];
    }
    return primaryDataSubscriptionCarrierName;
  }

  dynamic _getPrimaryDataSimInfo(dynamic simsDataInfo) {
    if (simsDataInfo != null) {
      final sims = json.decode(simsDataInfo);
      List<dynamic>? simsDetails = sims['simInfoList'];
      if (simsDetails == null || simsDetails.isEmpty) {
        return null;
      }
      var primaryDataSimDetails = simsDetails.firstWhere(
          (element) => element['isDefaultDataSubscription'] == true,
          orElse: () => simsDetails[0]);
      return primaryDataSimDetails;
    }
    return null;
  }

  String _getCellUuid(String type, int? cid) {
    final string = '${type.toLowerCase()}$cid';
    final uuid = Uuid();
    return uuid.v5(Uuid.NAMESPACE_OID, string);
  }

  String? _getTechnologyGenerationFromCell(dynamic cell) {
    switch (cell?['type']) {
      case 'NR':
        return '5G';
      case 'LTE':
        return '4G';
      case 'TDSCDMA':
      case 'WCDMA':
        return '3G';
      case 'GSM':
      case 'CDMA':
        return '2G';
      default:
        return null;
    }
  }

  String? _getTechnologyFromPrimaryCell(dynamic cell) {
    switch (cell?['networkType']) {
      case '0':
        return null;
      case '1':
        return 'GPRS';
      case '2':
        return 'EDGE';
      case '3':
        return 'UMTS';
      case '4':
        return 'CDMA';
      case '5':
        return 'EVDO rev. 0';
      case '6':
        return 'EVDO rev. A';
      case '7':
        return '1xRTT';
      case '8':
        return 'HSDPA';
      case '9':
        return 'HSUPA';
      case '10':
        return 'HSPA';
      case '11':
        return 'iDen';
      case '12':
        return 'EVDO rev. B';
      case '13':
        return 'LTE';
      case '14':
        return 'eHRPD';
      case '15':
        return 'HSPA+';
      case '16':
        return 'GSM';
      case '17':
        return 'TD SCDMA';
      case '18':
        return 'IWLAN';
      case '19':
        return 'LTE CA';
      case '20':
        return 'NR';
      case '41':
        return 'NSA';
      case '2147483644':
        {
          var technology;
          if (cell['nrConnectionStatus'] == 'rejected' &&
              cell['nrRejectedReason'] == 'RESTRICTED') {
            technology = 'LTE';
          } else if (cell['nrConnectionStatus'] == 'connected') {
            technology = 'NSA';
          } else {
            technology = 'LTE NR';
          }
          return technology;
        }
      case '2147483645':
        {
          var technology;
          if (cell['nrConnectionStatus'] == 'rejected' &&
              cell['nrRejectedReason'] == 'RESTRICTED') {
            technology = 'LTE CA';
          } else if (cell['nrConnectionStatus'] == 'connected') {
            technology = 'NSA';
          } else {
            technology = 'LTE CA NR';
          }
          return technology;
        }
      case '2147483646':
        return 'HSPA DC';
    }
    return null;
  }

  isEnoughPermissionGranted() async {
    if (platform.isAndroid &&
        permission.permissionsMap.locationPermissionsGranted &&
        permission.permissionsMap.phoneStatePermissionsGranted &&
        permission.permissionsMap.preciseLocationPermissionsGranted) {
      var locationServiceEnabled =
          await _locationService.isLocationServiceEnabled;
      if (locationServiceEnabled) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
