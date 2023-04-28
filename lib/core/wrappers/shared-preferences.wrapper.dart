import 'package:flutter/services.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

//SharedPreferences is wrapped in order to be able to mock it
//and easily access without calling static getInstance() method
class SharedPreferencesWrapper {
  static const MethodChannel _methodChannel =
      const MethodChannel('nettest/preferences');
  late SharedPreferences _preferences;

  Future<String?> get clientUuid async {
    String? uuid = getString(StorageKeys.clientUuid);
    if (uuid == null) {
      // Check for legacy apps
      try {
        uuid = await _methodChannel.invokeMethod('getClientUuid');
      } catch (_) {}
    }
    return uuid;
  }

  Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String? getString(String key) => _preferences.getString(key);
  bool? getBool(String key) => _preferences.getBool(key);
  double? getDouble(String key) => _preferences.getDouble(key);
  int? getInt(String key) => _preferences.getInt(key);

  Future setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  Future setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  Future setDouble(String key, double value) async {
    await _preferences.setDouble(key, value);
  }

  Future setInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  Future remove(String key) async {
    await _preferences.remove(key);
  }

  Future<bool> removeClientUuid() async {
    final removedNew = await _preferences.remove(StorageKeys.clientUuid);
    final removedOld = await _methodChannel.invokeMethod('removeClientUuid');
    return removedNew && removedOld;
  }
}
