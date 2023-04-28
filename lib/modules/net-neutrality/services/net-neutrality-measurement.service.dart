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
  NetNeutralityProgressHandler? progressHandler;
  DnsTestService _dnsTestService = GetIt.I.get<DnsTestService>();
  final _dateTimeWrapper = GetIt.I.get<DateTimeWrapper>();

  NetNeutralityMeasurementService(
      {this.settings, this.progressHandler, bool testing = false})
      : super(testing: testing);

  initWithSettings(NetNeutralitySettingsResponse settings,
      {NetNeutralityProgressHandler? progressHandler}) {
    this.settings = settings;
    if (progressHandler != null) {
      this.progressHandler = progressHandler;
    }
  }

  Future runAllWebPageTests() async {
    if (this.settings == null) {
      return;
    }
    return Future.wait(
        this.settings!.web?.map(runOneWebPageTest).toList() ?? []);
  }

  Future runOneWebPageTest(WebNetNeutralitySettingsItem test) async {
    final requestSentAt = _dateTimeWrapper.nowInMillis();
    WebNetNeutralityResultItem resultItem;
    final localDio = dioInstanceForUrl(test.target);
    localDio.options.connectTimeout = (test.timeout * 1000).toInt();
    localDio.options.sendTimeout = (test.timeout * 1000).toInt();
    localDio.options.receiveTimeout = (test.timeout * 1000).toInt();
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
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          resultItem = WebNetNeutralityResultItem.fromSettingsItem(
            test,
            openTestUuid: settings!.openTestUuid,
            requestSentAt: requestSentAt,
            timeoutExceeded: true,
            statusCode: e.response?.statusCode,
          );
          break;
        case DioErrorType.response:
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
    this.progressHandler?.updateProgress(resultItem: resultItem);
    return resultItem;
  }

  Future runAllDnsTests() async {
    if (this.settings == null) {
      return;
    }
    return Future.wait(this.settings!.dns?.map(runOneDnsTest).toList() ?? []);
  }

  Future runOneDnsTest(DnsNetNeutralitySettingsItem test) async {
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
    this.progressHandler?.updateProgress(resultItem: resultItem);
    return resultItem;
  }
}
