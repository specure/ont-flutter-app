import 'dart:io';

class InternetAddressWrapper {
  Future<List<InternetAddress>> lookup(String host,
      {InternetAddressType type = InternetAddressType.any}) {
    return InternetAddress.lookup(host, type: type);
  }
}
