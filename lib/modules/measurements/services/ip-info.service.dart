import 'dart:convert';
import 'dart:io';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:http/http.dart' as http;

class IPInfoService extends DioService {
  IPInfoService({bool testing = false}) : super(testing: testing);

  Future<String> getPublicAddress(IPVersion version) async {
    try {
      final host = Environment.controlServerUrl
          .replaceFirst('.net', 'v${version.toInt()}.net');
      final response = await http.post(
        Uri(scheme: "http", host: host, path: NTUrls.csIpRoute),
      );
      final parsed = jsonDecode(response.body) as Map;
      return parsed['ip'];
    } catch (_) {
      return addressIsNotAvailable;
    }
  }

  Future<String> getPrivateAddress(IPVersion version) async {
    final ipList;
    try {
      ipList = await NetworkInterface.list(type: version.type);
    } on SocketException catch (_) {
      return addressIsNotAvailable;
    }
    final connectedInterfaceAddresses =
        ipList.isNotEmpty ? ipList.last.addresses : null;
    if (connectedInterfaceAddresses != null) {
      final onlyValidIpAddresses = connectedInterfaceAddresses.where(
          (interfaceAddress) =>
              !_isDerivedFromMacAddress(interfaceAddress) &&
              !interfaceAddress.isMulticast);
      if (connectedInterfaceAddresses.isNotEmpty) {
        return _extractAddressFromAddressAndMask(onlyValidIpAddresses);
      } else {
        return addressIsNotAvailable;
      }
    } else {
      return addressIsNotAvailable;
    }
  }

  bool _isDerivedFromMacAddress(InternetAddress interfaceAddress) =>
      interfaceAddress.address.toLowerCase().contains("ff:fe");

  String _extractAddressFromAddressAndMask(
      Iterable<InternetAddress> onlyNotDerivedFromMacAddress) {
    if (onlyNotDerivedFromMacAddress.isEmpty) {
      return unknown;
    }
    final List<String> addresses =
        onlyNotDerivedFromMacAddress.first.address.split('%');
    if (addresses.isEmpty) {
      return unknown;
    }
    return addresses.first;
  }
}

enum IPVersion { v4, v6 }

extension IPVersionExt on IPVersion {
  int toInt() => this == IPVersion.v6 ? 6 : 4;
  InternetAddressType get type => this == IPVersion.v6
      ? InternetAddressType.IPv6
      : InternetAddressType.IPv4;
}
