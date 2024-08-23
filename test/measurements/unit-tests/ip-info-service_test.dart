@Timeout(Duration(seconds: 600))

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/ip-info.service.dart';

import '../../di/service-locator.dart';

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances();
    when(GetIt.I.get<Dio>().options).thenReturn(BaseOptions());
  });

  test(
      'getPublicAddress returns either the IP address or the placeholder string',
      () async {
    final service = IPInfoService(testing: true);
    var result = await service.getPublicAddress(IPVersion.v4);
    expect(result, isA<String>());
    result = await service.getPublicAddress(IPVersion.v6);
    expect(result, isA<String>());
  });

  test(
      'getPrivateAddress returns either the IP address or the placeholder string',
      () async {
    final service = IPInfoService(testing: true);
    var result = await service.getPrivateAddress(IPVersion.v4);
    expect(result, isA<String>());
    result = await service.getPrivateAddress(IPVersion.v6);
    expect(result, isA<String>());
  });
}
