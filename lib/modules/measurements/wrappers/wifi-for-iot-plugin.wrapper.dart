import 'package:wifi_iot/wifi_iot.dart';

//WifiForIoTPlugin is wrapped in order to be able to mock its static methods
class WifiForIoTPluginWrapper {
  Future<int?> getFrequency() async {
    return await WiFiForIoTPlugin.getFrequency();
  }

  Future<int?> getCurrentSignalStrength() async {
    return await WiFiForIoTPlugin.getCurrentSignalStrength();
  }

  Future<String?> getSSID() async {
    return await WiFiForIoTPlugin.getSSID();
  }
}