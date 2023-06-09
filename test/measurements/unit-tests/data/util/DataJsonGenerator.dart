import 'dart:convert';
import 'dart:io';

import 'package:nt_flutter_standalone/modules/measurements/models/cell-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/signal-info.dart';

class DataJsonGenerator {
  void generateDataJsons() {
    _generateAllCellsInfoJsons();
    _generatePrimaceCellInfoJsons();
    _generateNeighbouringCellsOnlyJsons();
    _generateCellInfoModels();
  }

  void _generatePrimaceCellInfoJsons() {
    var primaryCellInfoNrLte = [
      SignalInfo(
          cellUuid: '60b45d01-1633-53d5-b625-9651eabc0df4',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -92.0,
          lteRsrq: 0.0,
          lteRssnr: 9.0,
          signal: -92,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: true)
    ];
    var primaryCellInfoNrLteJson = jsonEncode(primaryCellInfoNrLte);
    File('test/measurements/unit-tests/data/primaryPrimaryDataCellSignalInfoNrLte.json')
        .writeAsString(primaryCellInfoNrLteJson);
    var primaryCellInfo2G = [
      SignalInfo(
          cellUuid: 'f369926f-7239-505e-88a0-3c5736c5ed97',
          networkTypeId: 2,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -87,
          band: '900',
          technology: 'GSM',
          isPrimaryCell: true)
    ];
    var primaryCellInfo2Gjson = jsonEncode(primaryCellInfo2G);
    File('test/measurements/unit-tests/data/primaryPrimaryDataCellSignalInfo2gEdge.json')
        .writeAsString(primaryCellInfo2Gjson);
    var primaryCellInfo3G = [
      SignalInfo(
          cellUuid: 'ce79f06b-5a09-50fa-a0f4-bbaa7bf47d00',
          networkTypeId: 10,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -99,
          band: '900',
          technology: 'WCDMA',
          isPrimaryCell: true),
    ];
    var primaryCellInfo3Gjson = jsonEncode(primaryCellInfo3G);
    File('test/measurements/unit-tests/data/primaryPrimaryDataCellSignalInfo3gHspa.json')
        .writeAsString(primaryCellInfo3Gjson);
    var primaryCellInfo4gPlus5g = [
      SignalInfo(
          cellUuid: '60b45d01-1633-53d5-b625-9651eabc0df4',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -106.0,
          lteRsrq: 0.0,
          lteRssnr: 5.0,
          signal: -106,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: true),
    ];
    var primaryCellInfo4GPlus5Gjson = jsonEncode(primaryCellInfo4gPlus5g);
    File('test/measurements/unit-tests/data/primaryPrimaryDataCellSignalInfo4gPlus5g.json')
        .writeAsString(primaryCellInfo4GPlus5Gjson);
    var primaryCellInfo4gLteCa = [
      SignalInfo(
          cellUuid: '949f7e4a-3470-5c01-8e52-66d930b29265',
          networkTypeId: 13,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: -112.0,
          lteRsrq: 0.0,
          lteRssnr: 5.0,
          signal: -112,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: true),
    ];
    var primaryCellInfo4GLtaCaJson = jsonEncode(primaryCellInfo4gLteCa);
    File('test/measurements/unit-tests/data/primaryPrimaryDataCellSignalInfo4gLteCa.json')
        .writeAsString(primaryCellInfo4GLtaCaJson);
    var primaryCellInfoNrLteCa = [
      SignalInfo(
          cellUuid: '60b45d01-1633-53d5-b625-9651eabc0df4',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -92.0,
          lteRsrq: 0.0,
          lteRssnr: 9.0,
          signal: -92,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: true),
    ];
    var primaryCellInfoNrLteCaJson = jsonEncode(primaryCellInfoNrLteCa);
    File('test/measurements/unit-tests/data/primaryPrimaryDataCellSignalInfoNrLteCa.json')
        .writeAsString(primaryCellInfoNrLteCaJson);
  }

  void _generateAllCellsInfoJsons() {
    var allCellInfoNrLte = [
      SignalInfo(
          cellUuid: '60b45d01-1633-53d5-b625-9651eabc0df4',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -92.0,
          lteRsrq: 0.0,
          lteRssnr: 9.0,
          signal: -92,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: true),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -97.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -97,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -102.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -102,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -110.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -110,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -102.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -102,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -102.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -102,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -114.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -114,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -119.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -119,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2955ce89-e865-5f81-bcf3-aa43bbb3b2fa',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -109,
          band: null,
          technology: 'NR',
          isPrimaryCell: false),
    ];
    var allCellInfoNrLteJson = jsonEncode(allCellInfoNrLte);
    File('test/measurements/unit-tests/data/allPrimaryDataCellSignalInfoNrLte.json')
        .writeAsString(allCellInfoNrLteJson);
    var allCellInfo2G = [
      SignalInfo(
          cellUuid: 'f369926f-7239-505e-88a0-3c5736c5ed97',
          networkTypeId: 2,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -87,
          band: '900',
          technology: 'GSM',
          isPrimaryCell: true),
      SignalInfo(
          cellUuid: 'f369926f-7239-505e-88a0-3c5736c5ed97',
          networkTypeId: 2,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -89,
          band: '900',
          technology: 'GSM',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: 'f369926f-7239-505e-88a0-3c5736c5ed97',
          networkTypeId: 2,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -95,
          band: '900',
          technology: 'GSM',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: 'f369926f-7239-505e-88a0-3c5736c5ed97',
          networkTypeId: 2,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -93,
          band: '900',
          technology: 'GSM',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: 'f369926f-7239-505e-88a0-3c5736c5ed97',
          networkTypeId: 2,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -99,
          band: '900',
          technology: 'GSM',
          isPrimaryCell: false),
    ];
    var allCellInfo2Gjson = jsonEncode(allCellInfo2G);
    File('test/measurements/unit-tests/data/allPrimaryDataCellSignalInfo2gEdge.json')
        .writeAsString(allCellInfo2Gjson);
    var allCellInfo3G = [
      SignalInfo(
          cellUuid: 'ce79f06b-5a09-50fa-a0f4-bbaa7bf47d00',
          networkTypeId: 10,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -99,
          band: '900',
          technology: 'WCDMA',
          isPrimaryCell: true),
      SignalInfo(
          cellUuid: 'ce79f06b-5a09-50fa-a0f4-bbaa7bf47d00',
          networkTypeId: 10,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -97,
          band: '900',
          technology: 'WCDMA',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: 'ce79f06b-5a09-50fa-a0f4-bbaa7bf47d00',
          networkTypeId: 10,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -107,
          band: '900',
          technology: 'WCDMA',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: 'ce79f06b-5a09-50fa-a0f4-bbaa7bf47d00',
          networkTypeId: 10,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -107,
          band: '900',
          technology: 'WCDMA',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: 'ce79f06b-5a09-50fa-a0f4-bbaa7bf47d00',
          networkTypeId: 10,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -107,
          band: '2100',
          technology: 'WCDMA',
          isPrimaryCell: false),
    ];
    var allCellInfo3Gjson = jsonEncode(allCellInfo3G);
    File('test/measurements/unit-tests/data/allPrimaryDataCellSignalInfo3gHspa.json')
        .writeAsString(allCellInfo3Gjson);
    var allCellInfo4gPlus5g = [
      SignalInfo(
          cellUuid: '60b45d01-1633-53d5-b625-9651eabc0df4',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -106.0,
          lteRsrq: 0.0,
          lteRssnr: 5.0,
          signal: -106,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: true),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -110.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -110,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -120.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -120,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -122.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -122,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -118.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -118,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -131.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -131,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: false),
    ];
    var allCellInfo4GPlus5Gjson = jsonEncode(allCellInfo4gPlus5g);
    File('test/measurements/unit-tests/data/allPrimaryDataCellSignalInfo4gPlus5g.json')
        .writeAsString(allCellInfo4GPlus5Gjson);
    var allCellInfo4gLteCa = [
      SignalInfo(
          cellUuid: '949f7e4a-3470-5c01-8e52-66d930b29265',
          networkTypeId: 13,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: -112.0,
          lteRsrq: 0.0,
          lteRssnr: 5.0,
          signal: -112,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: true),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 13,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: -121.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -121,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: false),
    ];
    var allCellInfo4GLtaCaJson = jsonEncode(allCellInfo4gLteCa);
    File('test/measurements/unit-tests/data/allPrimaryDataCellSignalInfo4gLteCa.json')
        .writeAsString(allCellInfo4GLtaCaJson);
    var allCellInfoNrLteCa = [
      SignalInfo(
          cellUuid: '60b45d01-1633-53d5-b625-9651eabc0df4',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -92.0,
          lteRsrq: 0.0,
          lteRssnr: 9.0,
          signal: -92,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: true),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -97.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -97,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -102.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -102,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -110.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -110,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -102.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -102,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -102.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -102,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -114.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -114,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -119.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -119,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2955ce89-e865-5f81-bcf3-aa43bbb3b2fa',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -109,
          band: null,
          technology: 'NR',
          isPrimaryCell: false),
    ];
    var allCellInfoNrLteCaJson = jsonEncode(allCellInfoNrLteCa);
    File('test/measurements/unit-tests/data/allPrimaryDataCellSignalInfoNrLteCa.json')
        .writeAsString(allCellInfoNrLteCaJson);
  }

  void _generateCellInfoModels() {
    var cellInfoModel4g = CellInfoModel(
        active: true,
        registered: true,
        areaCode: 52502,
        channelNumber: 6400,
        primaryDataSubscription: true,
        locationId: 78185474,
        mcc: 231,
        mnc: 6,
        primaryScramblingCode: 193,
        uuid: '60b45d01-1633-53d5-b625-9651eabc0df4',
        technology: '4g');
    File('test/measurements/unit-tests/data/cellInfoModel4g.json')
        .writeAsString(jsonEncode(cellInfoModel4g).toString());

    var cellInfoModel4gOnly = CellInfoModel(
        active: true,
        registered: true,
        areaCode: 52502,
        channelNumber: 550,
        primaryDataSubscription: true,
        locationId: 78185494,
        mcc: 231,
        mnc: 6,
        primaryScramblingCode: 193,
        uuid: '949f7e4a-3470-5c01-8e52-66d930b29265',
        technology: '4g');
    File('test/measurements/unit-tests/data/cellInfoModel4gOnly.json')
        .writeAsString(jsonEncode(cellInfoModel4gOnly).toString());

    var cellInfoModel2g = CellInfoModel(
        active: true,
        registered: true,
        channelNumber: 1021,
        primaryDataSubscription: true,
        mcc: 231,
        mnc: 6,
        uuid: '8def1970-e71b-5258-8e0e-e67bbf677c1f',
        technology: '2g');
    File('test/measurements/unit-tests/data/cellInfoModel2g.json')
        .writeAsString(jsonEncode(cellInfoModel2g).toString());

    var cellInfoModel3g = CellInfoModel(
        active: true,
        registered: true,
        channelNumber: 2938,
        primaryDataSubscription: true,
        mcc: 231,
        mnc: 6,
        uuid: '4f60ebf8-cd51-5544-822a-7e6d7d95dc3a',
        technology: '3g');
    File('test/measurements/unit-tests/data/cellInfoModel3g.json')
        .writeAsString(jsonEncode(cellInfoModel3g).toString());
  }

  void _generateNeighbouringCellsOnlyJsons() {
    var notConnectedCellInfoNrLte = [
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -97.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -97,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -102.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -102,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -110.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -110,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -102.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -102,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -102.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -102,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -114.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -114,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -119.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -119,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2955ce89-e865-5f81-bcf3-aa43bbb3b2fa',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -109,
          band: null,
          technology: 'NR',
          isPrimaryCell: false),
    ];
    var notConnectedCellInfoNrLteJson = jsonEncode(notConnectedCellInfoNrLte);
    File('test/measurements/unit-tests/data/notConnectedPrimaryDataCellSignalInfoNrLte.json')
        .writeAsString(notConnectedCellInfoNrLteJson);
    var notConnectedCellInfo2G = [
      SignalInfo(
          cellUuid: 'f369926f-7239-505e-88a0-3c5736c5ed97',
          networkTypeId: 2,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -89,
          band: '900',
          technology: 'GSM',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: 'f369926f-7239-505e-88a0-3c5736c5ed97',
          networkTypeId: 2,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -95,
          band: '900',
          technology: 'GSM',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: 'f369926f-7239-505e-88a0-3c5736c5ed97',
          networkTypeId: 2,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -93,
          band: '900',
          technology: 'GSM',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: 'f369926f-7239-505e-88a0-3c5736c5ed97',
          networkTypeId: 2,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -99,
          band: '900',
          technology: 'GSM',
          isPrimaryCell: false),
    ];
    var notConnectedCellInfo2Gjson = jsonEncode(notConnectedCellInfo2G);
    File('test/measurements/unit-tests/data/notConnectedPrimaryDataCellSignalInfo2gEdge.json')
        .writeAsString(notConnectedCellInfo2Gjson);
    var notConnectedCellInfo3G = [
      SignalInfo(
          cellUuid: 'ce79f06b-5a09-50fa-a0f4-bbaa7bf47d00',
          networkTypeId: 10,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -97,
          band: '900',
          technology: 'WCDMA',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: 'ce79f06b-5a09-50fa-a0f4-bbaa7bf47d00',
          networkTypeId: 10,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -107,
          band: '900',
          technology: 'WCDMA',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: 'ce79f06b-5a09-50fa-a0f4-bbaa7bf47d00',
          networkTypeId: 10,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -107,
          band: '900',
          technology: 'WCDMA',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: 'ce79f06b-5a09-50fa-a0f4-bbaa7bf47d00',
          networkTypeId: 10,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -107,
          band: '2100',
          technology: 'WCDMA',
          isPrimaryCell: false),
    ];
    var notConnectedCellInfo3Gjson = jsonEncode(notConnectedCellInfo3G);
    File('test/measurements/unit-tests/data/notConnectedPrimaryDataCellSignalInfo3gHspa.json')
        .writeAsString(notConnectedCellInfo3Gjson);
    var notConnectedCellInfo4gPlus5g = [
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -110.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -110,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -120.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -120,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -122.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -122,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -118.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -118,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -131.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -131,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: false),
    ];
    var notConnectedCellInfo4GPlus5Gjson =
        jsonEncode(notConnectedCellInfo4gPlus5g);
    File('test/measurements/unit-tests/data/notConnectedPrimaryDataCellSignalInfo4gPlus5g.json')
        .writeAsString(notConnectedCellInfo4GPlus5Gjson);
    var notConnectedCellInfo4gLteCa = [
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 13,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: -121.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -121,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: false),
    ];
    var notConnectedCellInfo4GLtaCaJson =
        jsonEncode(notConnectedCellInfo4gLteCa);
    File('test/measurements/unit-tests/data/notConnectedPrimaryDataCellSignalInfo4gLteCa.json')
        .writeAsString(notConnectedCellInfo4GLtaCaJson);
    var notConnectedCellInfoNrLteCa = [
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -97.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -97,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -102.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -102,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -110.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -110,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -102.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -102,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -102.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -102,
          band: '800',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -114.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -114,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2f1f3d34-6916-527e-88f6-54a2434f08ce',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 4,
          lteCqi: 0,
          lteRsrp: -119.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -119,
          band: '2100',
          technology: 'LTE',
          isPrimaryCell: false),
      SignalInfo(
          cellUuid: '2955ce89-e865-5f81-bcf3-aa43bbb3b2fa',
          networkTypeId: 41,
          timeNsLast: null,
          timeNs: null,
          timingAdvance: 0,
          lteCqi: 0,
          lteRsrp: 0.0,
          lteRsrq: 0.0,
          lteRssnr: 0.0,
          signal: -109,
          band: null,
          technology: 'NR',
          isPrimaryCell: false),
    ];
    var notConnectedCellInfoNrLteCaJson =
        jsonEncode(notConnectedCellInfoNrLteCa);
    File('test/measurements/unit-tests/data/notConnectedPrimaryDataCellSignalInfoNrLteCa.json')
        .writeAsString(notConnectedCellInfoNrLteCaJson);
  }
}
