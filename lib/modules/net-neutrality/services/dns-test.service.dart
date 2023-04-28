import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-net-neutrality-settings-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-result.dart';

class DnsTestService {
  final MethodChannel channel;

  DnsTestService({
    this.channel = const MethodChannel('nettest/dnsTest'),
  });

  Future<DnsResult?> execute(DnsNetNeutralitySettingsItem params) async {
    try {
      final message = await channel.invokeMethod(
        'startDnsTest',
        params.toJson(),
      );
      Map<String, dynamic> json = jsonDecode(message);
      return DnsResult.fromJson(json);
    } on PlatformException catch (err) {
      print(err);
      return null;
    }
  }
}
