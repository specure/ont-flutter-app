import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/services/max-mind.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';

// No way to found the active carrier, so we're just using the first one found.
// https://developer.apple.com/forums/thread/117102
class CarrierInfoWrapper {
  static const MethodChannel _channel = MethodChannel("nettest/carrierInfo");
  static final PlatformWrapper _platform = GetIt.I.get<PlatformWrapper>();
  final MaxMindService _maxMind = GetIt.I.get<MaxMindService>();

  Future<String> getNetworkGeneration() async {
    if (_platform.isAndroid) {
      return unknown;
    }
    try {
      Map<dynamic, dynamic>? respMap =
          await _channel.invokeMethod('getIosInfo');
      final Iterable? generations =
          respMap?['carrierRadioAccessTechnologyGenerationList'];
      final Map? gen = generations?.firstWhere(
        (element) => element["isActive"],
        orElse: () => null,
      );
      debugPrint("Technology gen is $gen");
      return gen?['name'] ?? unknown;
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
      final Iterable? types = respMap?['carrierRadioAccessTechnologyTypeList'];
      final Map? type = types?.firstWhere(
        (element) => element["isActive"],
        orElse: () => unknown,
      );
      debugPrint("Technology type is $type");
      return type?["name"] ?? unknown;
    } catch (e) {
      return unknown;
    }
  }

  Future<String> getNativeCarrierName() async {
    if (_platform.isAndroid) {
      return unknown;
    }
    try {
      Map<dynamic, dynamic>? respMap =
          await _channel.invokeMethod('getIosInfo');
      final Iterable? carriers = respMap?['carrierData'];
      final Map? activeCarrier = carriers?.firstWhere(
        (element) => element["isActive"],
        orElse: () => null,
      );
      String? carrierName = activeCarrier?['carrierName'];
      if (carrierName == null ||
          carrierName == "Carrier" ||
          carrierName == "--") {
        carrierName = unknown;
      }
      return carrierName;
    } catch (e) {
      return unknown;
    }
  }

  Future<String> getCarrierName() async {
    if (_platform.isAndroid) {
      return unknown;
    }
    try {
      String activeCarrierName = await getNativeCarrierName();
      if (activeCarrierName == unknown) {
        final info = await _maxMind.getInfoForCurrentIp();
        return info?.traits.isp ?? unknown;
      }
      return activeCarrierName;
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
