import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';

// No way to found the active carrier, so we're just using the first one found.
// https://developer.apple.com/forums/thread/117102
class CarrierInfoWrapper {
  static const MethodChannel _channel = MethodChannel("nettest/carrierInfo");
  static final PlatformWrapper _platform = GetIt.I.get<PlatformWrapper>();

  Future<String> getNetworkGeneration() async {
    if (_platform.isAndroid) {
      return unknown;
    }
    try {
      Map<dynamic, dynamic>? respMap =
          await _channel.invokeMethod('getIosInfo');
      return respMap?['carrierRadioAccessTechnologyGenerationList'][0] ??
          unknown;
    } catch (e) {
      return unknown;
    }
  }

  Future<String> getRadioType() async {
    if (_platform.isAndroid) {
      return unknown;
    }
    try {
      Map<dynamic, dynamic>? respMap =
          await _channel.invokeMethod('getIosInfo');
      return respMap?['carrierRadioAccessTechnologyTypeList'][0] ?? unknown;
    } catch (e) {
      return unknown;
    }
  }

  Future<String> getCarrierName() async {
    if (_platform.isAndroid) {
      return unknown;
    }
    try {
      Map<dynamic, dynamic>? respMap =
          await _channel.invokeMethod('getIosInfo');
      return respMap?['carrierData'][0]?['carrierName'] ?? unknown;
    } catch (e) {
      return unknown;
    }
  }

  Future<bool> getIsDualSim() async {
    if (_platform.isAndroid) {
      return false;
    }
    try {
      Map<dynamic, dynamic>? respMap =
          await _channel.invokeMethod('getIosInfo');
      return respMap?['carrierData'] != null &&
          respMap?['carrierData'].length > 1;
    } catch (e) {
      return false;
    }
  }
}
