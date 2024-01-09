import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/date-time.wrapper.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-net-neutrality-result-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-net-neutrality-settings-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-result-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-settings-response.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/web-net-neutrality-result-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/web-net-neutrality-settings-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/dns-test.service.dart';

abstract class NetNeutralityProgressHandler {
  updateProgress({NetNeutralityResultItem? resultItem});
}

class NetNeutralityMeasurementService extends DioService {
  NetNeutralitySettingsResponse? settings;
  DnsTestService _dnsTestService = GetIt.I.get<DnsTestService>();
  final _dateTimeWrapper = GetIt.I.get<DateTimeWrapper>();

  NetNeutralityMeasurementService({this.settings, bool testing = false})
      : super(testing: testing);

  initWithSettings(NetNeutralitySettingsResponse settings) {
    this.settings = settings;
  }

  Stream<NetNeutralityResultItem>? runAllWebPageTests() {
    if (this.settings?.web == null) {
      return null;
    }
    return Stream.fromFutures(this.settings!.web!.map(runOneWebPageTest));
  }

  Stream<NetNeutralityResultItem>? runAllDnsTests() {
    if (this.settings?.dns == null) {
      return null;
    }
    return Stream.fromFutures(this.settings!.dns!.map(runOneDnsTest));
  }

  Future<NetNeutralityResultItem> runOneWebPageTest(
      WebNetNeutralitySettingsItem test) async {
    final requestSentAt = _dateTimeWrapper.nowInMillis();
    WebNetNeutralityResultItem resultItem;
    final localDio = dioInstanceForUrl(test.target);
    final timeoutMs = (test.timeout * 1000).toInt();
    localDio.options.connectTimeout = Duration(milliseconds: timeoutMs);
    localDio.options.sendTimeout = Duration(milliseconds: timeoutMs);
    localDio.options.receiveTimeout = Duration(milliseconds: timeoutMs);
    localDio.options.followRedirects = false;
    try {
      final response = await localDio.get("");
      resultItem = WebNetNeutralityResultItem.fromSettingsItem(
        test,
        openTestUuid: settings!.openTestUuid,
        requestSentAt: requestSentAt,
        timeoutExceeded: false,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          resultItem = WebNetNeutralityResultItem.fromSettingsItem(
            test,
            openTestUuid: settings!.openTestUuid,
            requestSentAt: requestSentAt,
            timeoutExceeded: true,
            statusCode: e.response?.statusCode,
          );
          break;
        case DioExceptionType.badResponse:
        default:
          resultItem = WebNetNeutralityResultItem.fromSettingsItem(
            test,
            openTestUuid: settings!.openTestUuid,
            requestSentAt: requestSentAt,
            timeoutExceeded: false,
            statusCode: e.response?.statusCode,
          );
          break;
      }
    } on Exception catch (_) {
      resultItem = WebNetNeutralityResultItem.fromSettingsItem(
        test,
        openTestUuid: settings!.openTestUuid,
        requestSentAt: requestSentAt,
        timeoutExceeded: false,
      );
    }
    return resultItem;
  }

  Future<NetNeutralityResultItem> runOneDnsTest(
      DnsNetNeutralitySettingsItem test) async {
    var result;
    try {
      result = await _dnsTestService.execute(test);
    } catch (e) {
      print("DNS test execution failed: $e");
    }

    final resultItem = DnsNetNeutralityResultItem.fromSettingsAndResultItem(
      test,
      result,
      openTestUuid: settings!.openTestUuid,
    );
    return resultItem;
  }
}
