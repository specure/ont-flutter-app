import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';

const int wifiMinSignal = -100;
const int wifiMaxSignal = -30;

const int cellularMinSignal = -110;
const int cellularMaxSignal = -50;

const int lteMinSignal = -130;
const int lteMaxSignal = -70;

const int wcdmaMinSignal = -120;
const int wcdmaMaxSignal = -24;

const int nrSignalStrengthPoor = -110;
const int nrSignalStrengthModerate = -90;
const int nrSignalStrengthGood = -80;
const int nrSignalStrengthExcellent = -44;

const String signalStrengthEstimatePoor = 'Poor';
const String signalStrengthEstimateModerate = 'Moderate';
const String signalStrengthEstimateGood = 'Good';
const String signalStrengthEstimateExcellent = 'Excellent';

int calculateSignalStep(int max, int min) => ((max - min) ~/ 4).abs();

String getCommonSignalQuality(int max, int min, int signal) {
  final step = calculateSignalStep(max, min);
  if (signal < min + step) {
    return signalStrengthEstimatePoor.translated;
  } else if (signal < min + step * 2) {
    return signalStrengthEstimateModerate.translated;
  } else if (signal < min + step * 3) {
    return signalStrengthEstimateGood.translated;
  } else {
    return signalStrengthEstimateExcellent.translated;
  }
}

String getNrSignalQuality(int signal) {
  if (signal <= nrSignalStrengthPoor) {
    return signalStrengthEstimatePoor.translated;
  } else if (signal <= nrSignalStrengthModerate) {
    return signalStrengthEstimateModerate.translated;
  } else if (signal <= nrSignalStrengthGood) {
    return signalStrengthEstimateGood.translated;
  } else {
    return signalStrengthEstimateExcellent.translated;
  }
}

String getWifiSignalQuality(int signal) =>
    getCommonSignalQuality(wifiMaxSignal, wifiMinSignal, signal);
String getCellularSignalQuality(int signal) =>
    getCommonSignalQuality(cellularMaxSignal, cellularMinSignal, signal);
String get3gSignalQuality(int signal) =>
    getCommonSignalQuality(wcdmaMaxSignal, wcdmaMinSignal, signal);
String get4gSignalQuality(int signal) =>
    getCommonSignalQuality(lteMaxSignal, lteMinSignal, signal);

String getSignalQuality(String technology, int signal) {
  String quality; 
  switch (technology) {
    case wifi:
      quality = getWifiSignalQuality(signal);
      break;
    case '5g':
      quality = getNrSignalQuality(signal);
      break;
    case '4g':
      quality = get4gSignalQuality(signal);
      break;
    case '3g':
      quality = get3gSignalQuality(signal);
      break;
    default:
      quality = getCellularSignalQuality(signal);
  }
  return quality;
}
