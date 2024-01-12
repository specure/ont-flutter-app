import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/date-time.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-net-neutrality-result-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-result.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-settings-response.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/web-net-neutrality-result-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/dns-test.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-measurement.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

final _requestSentAt = 3000;
final _settings = NetNeutralitySettingsResponse.fromJson(jsonDecode(
    File('test/net-neutrality/unit-tests/data/net-neutrality-settings.json')
        .readAsStringSync()));
final _settingsMoreDns = NetNeutralitySettingsResponse.fromJson(jsonDecode(File(
        'test/net-neutrality/unit-tests/data/net-neutrality-settings-more-dns.json')
    .readAsStringSync()));
final _service = NetNeutralityMeasurementService(testing: true);
final _clientUuid = "clientUuid";
final _dioError = MockDioError();
final _webTestResponse = Response(
  requestOptions: RequestOptions(path: ""),
  statusCode: 200,
  data: {
    "statusCode": 200,
  },
);

final _dnsTestExistingResponse = DnsResult(
    givenResolver: "8.8.8.8",
    record: "A",
    host: "yahoo.com",
    timeoutSeconds: 10,
    resultQueryStatus: "OK",
    resultStatus: DnsResultStatus.NOERROR,
    resultDurationNanos: 80901875,
    resultResolver: "8.8.8.8",
    rawResponse: null,
    dnsRecords: [
      DnsRecord(
          resultAddress: "74.6.143.25", resultPriority: null, resultTtl: "489"),
      DnsRecord(
          resultAddress: "74.6.231.20", resultPriority: null, resultTtl: "489"),
      DnsRecord(
          resultAddress: "74.6.231.21", resultPriority: null, resultTtl: "489"),
      DnsRecord(
          resultAddress: "74.6.143.26", resultPriority: null, resultTtl: "489"),
      DnsRecord(
          resultAddress: "98.137.11.163",
          resultPriority: null,
          resultTtl: "489"),
      DnsRecord(
          resultAddress: "98.137.11.164",
          resultPriority: null,
          resultTtl: "489")
    ]);

final _dnsTestNonExistingResponse = DnsResult(
    givenResolver: "",
    record: "A",
    host: "yahoo.com",
    timeoutSeconds: 10,
    resultQueryStatus: "OK",
    resultStatus: DnsResultStatus.NXDOMAIN,
    resultDurationNanos: 80901875,
    resultResolver: "8.8.8.8",
    rawResponse: null,
    dnsRecords: []);

final _dnsEntries = [
  "74.6.143.25",
  "74.6.231.20",
  "74.6.231.21",
  "74.6.143.26",
  "98.137.11.163",
  "98.137.11.164",
];

@GenerateMocks([
  DnsTestService
], customMocks: [
  MockSpec<NetNeutralityCubit>(
    as: #MockNetNeutralityCubitCalls,
    onMissingStub: OnMissingStub.returnDefault,
  ),
])
void main() {
  setUpAll(() async {
    TestingServiceLocator.registerInstances();
    when(GetIt.I.get<Dio>().options).thenReturn(BaseOptions());
    when(GetIt.I.get<DateTimeWrapper>().nowInMillis())
        .thenReturn(_requestSentAt);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.clientUuid))
        .thenReturn(_clientUuid);
  });

  group('Net neutrality measurement service', () {
    test('initWithSettings', () async {
      await _service.initWithSettings(_settings);
      expect(_service.settings, _settings);
    });

    test('runAllWebPageTests', () async {
      await _service.initWithSettings(_settings);
      when(GetIt.I.get<Dio>().get(""))
          .thenAnswer((realInvocation) async => _webTestResponse);
      expect(_service.runAllWebPageTests(), emitsInOrder([]));
    });

    test('runOneWebPageTest', () async {
      await _service.initWithSettings(_settings);
      final test = _settings.web!.first;
      when(GetIt.I.get<Dio>().get(""))
          .thenAnswer((realInvocation) async => _webTestResponse);
      final WebNetNeutralityResultItem resultItem = (await _service
          .runOneWebPageTest(test)) as WebNetNeutralityResultItem;
      expect(resultItem.statusCode, 200);
      expect(resultItem.timeoutExceeded, false);
    });

    test('runOneWebPageTest with error', () async {
      await _service.initWithSettings(_settings);
      final test = _settings.web!.first;
      WebNetNeutralityResultItem resultItem;
      when(GetIt.I.get<Dio>().get(""))
          .thenAnswer((realInvocation) async => throw _dioError);

      when(_dioError.type).thenReturn(DioExceptionType.connectionTimeout);
      resultItem = (await _service.runOneWebPageTest(test))
          as WebNetNeutralityResultItem;
      expect(resultItem.statusCode, null);
      expect(resultItem.timeoutExceeded, true);

      when(_dioError.type).thenReturn(DioExceptionType.badResponse);
      when(_dioError.response).thenReturn(Response(
        requestOptions: RequestOptions(path: ""),
        statusCode: 500,
      ));
      resultItem = (await _service.runOneWebPageTest(test))
          as WebNetNeutralityResultItem;
      expect(resultItem.statusCode, 500);
      expect(resultItem.timeoutExceeded, false);

      when(GetIt.I.get<Dio>().get(""))
          .thenAnswer((realInvocation) async => throw Exception());
      resultItem = (await _service.runOneWebPageTest(test))
          as WebNetNeutralityResultItem;
      expect(resultItem.statusCode, null);
      expect(resultItem.timeoutExceeded, false);
    });

    test('runAllDnsTests', () async {
      final test = _settings.dns![0];
      when(GetIt.I.get<DnsTestService>().execute(test))
          .thenAnswer((realInvocation) async => _dnsTestExistingResponse);
      final test2 = _settingsMoreDns.dns![1];
      when(GetIt.I.get<DnsTestService>().execute(test2))
          .thenAnswer((realInvocation) async => _dnsTestNonExistingResponse);
      await _service.initWithSettings(_settings);
      expect(_service.runAllDnsTests(), emitsInOrder([]));
    });

    test('runOneDnsTest - existing', () async {
      final test = _settings.dns![0];
      when(GetIt.I.get<DnsTestService>().execute(test))
          .thenAnswer((realInvocation) async => _dnsTestExistingResponse);
      await _service.initWithSettings(_settings);
      final DnsNetNeutralityResultItem resultItem =
          (await _service.runOneDnsTest(test)) as DnsNetNeutralityResultItem;
      expect(resultItem.resolver, "8.8.8.8");
      expect(resultItem.timeoutExceeded, false);
      expect(resultItem.dnsStatus,
          DnsResultStatus.getAsString(DnsResultStatus.NOERROR));
      expect(resultItem.durationNs, 80901875);
      expect(resultItem.type, NetNeutralityType.DNS);
      expect(resultItem.dnsEntries, _dnsEntries);
    });

    test('runOneDnsTest - non-existing', () async {
      final test = _settingsMoreDns.dns![1];
      when(GetIt.I.get<DnsTestService>().execute(test))
          .thenAnswer((realInvocation) async => _dnsTestNonExistingResponse);
      await _service.initWithSettings(_settingsMoreDns);
      final DnsNetNeutralityResultItem resultItem =
          (await _service.runOneDnsTest(test)) as DnsNetNeutralityResultItem;
      expect(resultItem.resolver, "8.8.8.8");
      expect(resultItem.timeoutExceeded, false);
      expect(resultItem.dnsStatus,
          DnsResultStatus.getAsString(DnsResultStatus.NXDOMAIN));
      expect(resultItem.durationNs, 80901875);
      expect(resultItem.type, NetNeutralityType.DNS);
      expect(resultItem.dnsEntries, []);
    });
  });
}
