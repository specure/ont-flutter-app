import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';

class PingWrapper {
  Ping? getIstance(String host, {int? count, double? intervalS}) {
    return Ping(host, count: count, interval: intervalS);
  }
}
