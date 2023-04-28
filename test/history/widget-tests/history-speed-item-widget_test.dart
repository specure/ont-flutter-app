import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/history-speed-item/history-speed-item.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-results.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';

MeasurementHistoryResult _basicResultBorder10VariousMbps =
    MeasurementHistoryResult(
  testUuid: 'uuid',
  uploadKbps: 9123,
  downloadKbps: 9457,
  pingMs: 100,
  measurementDate: '2020-01-01T15:00:00.000Z',
  userExperienceMetrics: [],
  networkType: '3G',
  device: 'iPhone',
  loopModeUuid: null,
);

MeasurementHistoryResult _basicResultBorder100Mbps = MeasurementHistoryResult(
  testUuid: 'uuid',
  uploadKbps: 100999,
  downloadKbps: 99999,
  pingMs: 20,
  measurementDate: '2020-01-01T15:00:00.000Z',
  userExperienceMetrics: [],
  networkType: '3G',
  device: 'iPhone',
  loopModeUuid: null,
);

MeasurementHistoryResult _basicResultBorder10Mbps = MeasurementHistoryResult(
  testUuid: 'uuid',
  uploadKbps: 10499,
  downloadKbps: 9499,
  pingMs: 100,
  measurementDate: '2020-01-01T15:00:00.000Z',
  userExperienceMetrics: [],
  networkType: '3G',
  device: 'iPhone',
  loopModeUuid: null,
);

MeasurementHistoryResult _basicResultBorder1Mbps = MeasurementHistoryResult(
  testUuid: 'uuid',
  uploadKbps: 1149,
  downloadKbps: 999,
  pingMs: 100,
  measurementDate: '2020-01-01T15:00:00.000Z',
  userExperienceMetrics: [],
  networkType: '3G',
  device: 'iPhone',
  loopModeUuid: null,
);

MeasurementHistoryResult _basicResultUnder1Mbps = MeasurementHistoryResult(
  testUuid: 'uuid',
  uploadKbps: 999,
  downloadKbps: 945,
  pingMs: 100,
  measurementDate: '2020-01-01T15:00:00.000Z',
  userExperienceMetrics: [],
  networkType: '3G',
  device: 'iPhone',
  loopModeUuid: null,
);

MeasurementHistoryResult _basicResultBellow100Mbps = MeasurementHistoryResult(
  testUuid: 'uuid',
  uploadKbps: 97500,
  downloadKbps: 99499,
  pingMs: 100,
  measurementDate: '2020-01-01T15:00:00.000Z',
  userExperienceMetrics: [],
  networkType: '3G',
  device: 'iPhone',
  loopModeUuid: null,
);

MeasurementHistoryResult _basicResultHigherThan100Mbps =
    MeasurementHistoryResult(
  testUuid: 'uuid',
  uploadKbps: 100999,
  downloadKbps: 101500,
  pingMs: 100,
  measurementDate: '2020-01-01T15:00:00.000Z',
  userExperienceMetrics: [],
  networkType: '3G',
  device: 'iPhone',
  loopModeUuid: null,
);

void main() {
  group('Test History speed item widget', () {
    testWidgets('Test with mobile network type', (tester) async {
      await _testHistorySpeedItemWithNetworkType(tester, '3G');
    });
    testWidgets('Test with wifi network type', (tester) async {
      await _testHistorySpeedItemWithNetworkType(tester, wifi);
    });
    testWidgets('Test with loop mode - single test', (tester) async {
      await _testHistorySpeedItemWithLoopModeSingle(tester);
    });
    testWidgets('Test with loop mode - multiple tests', (tester) async {
      await _testHistorySpeedItemWithLoopModeMultiple(tester);
    });
    testWidgets('Test with speeds higher than 100Mbps', (tester) async {
      await _testHistorySpeedItemRounding(
          tester, _basicResultHigherThan100Mbps, '101', '102');
    });
    testWidgets('Test with speeds border around 100Mbps', (tester) async {
      await _testHistorySpeedItemRounding(
          tester, _basicResultBorder100Mbps, '100', '101');
    });
    testWidgets('Test with speeds border around 10Mbps', (tester) async {
      await _testHistorySpeedItemRounding(
          tester, _basicResultBorder10Mbps, '10.5', '9.5');
    });
    testWidgets('Test with speeds bellow 100Mbps', (tester) async {
      await _testHistorySpeedItemRounding(
          tester, _basicResultBellow100Mbps, '99.5', '97.5');
    });
    testWidgets('Test with speeds bellow 10Mbps', (tester) async {
      await _testHistorySpeedItemRounding(
          tester, _basicResultBorder10VariousMbps, '9.46', '9.12');
    });
    testWidgets('Test with speeds around border 1Mbps', (tester) async {
      await _testHistorySpeedItemRounding(
          tester, _basicResultBorder1Mbps, '1.15', '0.999');
    });
    testWidgets('Test with speeds under 1Mbps', (tester) async {
      await _testHistorySpeedItemRounding(
          tester, _basicResultUnder1Mbps, '0.945', '0.999');
    });
    testWidgets('Test unknown network', (tester) async {
      await _testHistorySpeedItemWithNetworkType(tester, unknown);
    });
    testWidgets('Test mobile network', (tester) async {
      await _testHistorySpeedItemWithNetworkType(tester, mobile);
    });
  });
}

Future _testHistorySpeedItemRounding(
    WidgetTester tester,
    MeasurementHistoryResult data,
    String expectedDownloadSpeed,
    String expectedUploadSpeed) async {
  final widget = HistorySpeedItemWidget(
    item: MeasurementHistoryResults([data]),
  );
  await tester.pumpWidget(MaterialApp(home: widget));
  _testSpeedElements(expectedDownloadSpeed, expectedUploadSpeed);
}

Future _testHistorySpeedItemWithNetworkType(
    WidgetTester tester, String networkType) async {
  final widget = HistorySpeedItemWidget(
    item: _getMeasurementResultModel(networkType: networkType),
  );
  await tester.pumpWidget(MaterialApp(home: widget));
  final networkTypeLabelFinder = find.text(networkType);
  final networkTypeIconFinder = find.byIcon(networkType == wifi
      ? Icons.signal_wifi_4_bar
      : networkType == "unknown"
          ? Icons.cell_wifi_outlined
          : Icons.signal_cellular_alt_outlined);
  expect(
      networkTypeLabelFinder,
      networkType == wifi || networkType == "unknown" || networkType == mobile
          ? findsNothing
          : findsOneWidget);
  expect(networkTypeIconFinder, findsOneWidget);
  _testAllOtherElements();
}

Future _testHistorySpeedItemWithLoopModeSingle(WidgetTester tester) async {
  final widget = HistorySpeedItemWidget(
    item: _getMeasurementResultModel(loopMode: true, networkType: '3G'),
  );
  await tester.pumpWidget(MaterialApp(home: widget));
  final loopModeIconFinder = find.byIcon(Icons.signal_cellular_alt_outlined);
  expect(loopModeIconFinder, findsOneWidget);
  _testAllOtherElements();
}

Future _testHistorySpeedItemWithLoopModeMultiple(WidgetTester tester) async {
  final widget = HistorySpeedItemWidget(
    item: _getMeasurementResultModelWithMultipleLoop(loopMode: true),
  );
  await tester.pumpWidget(MaterialApp(home: widget));
  final loopModeIconFinder = find.byIcon(Icons.sync);
  expect(loopModeIconFinder, findsOneWidget);
  _testAllOtherElements();
}

MeasurementHistoryResults _getMeasurementResultModel({
  String? networkType,
  bool loopMode = false,
}) {
  return MeasurementHistoryResults([
    MeasurementHistoryResult(
      testUuid: 'uuid',
      uploadKbps: 1000,
      downloadKbps: 2000,
      pingMs: 100,
      measurementDate: '2020-01-01T15:00:00.000Z',
      userExperienceMetrics: [],
      networkType: networkType,
      device: 'iPhone',
      loopModeUuid: loopMode ? 'loopModeUuid' : null,
    )
  ]);
}

MeasurementHistoryResults _getMeasurementResultModelWithMultipleLoop({
  String? networkType,
  bool loopMode = false,
}) {
  return MeasurementHistoryResults([
    MeasurementHistoryResult(
      testUuid: 'uuid',
      uploadKbps: 1000,
      downloadKbps: 2000,
      pingMs: 100,
      measurementDate: '2020-01-01T15:00:00.000Z',
      userExperienceMetrics: [],
      networkType: networkType,
      device: 'iPhone',
      loopModeUuid: loopMode ? 'loopModeUuid' : null,
    ),
    MeasurementHistoryResult(
      testUuid: 'uuid',
      uploadKbps: 2000,
      downloadKbps: 3000,
      pingMs: 200,
      measurementDate: '2020-01-01T15:00:00.000Z',
      userExperienceMetrics: [],
      networkType: networkType,
      device: 'iPhone',
      loopModeUuid: loopMode ? 'loopModeUuid' : null,
    )
  ]);
}

_testSpeedElements(String downloadSpeedText, String uploadSpeedText) {
  final uploadFinder = find.text(uploadSpeedText);
  final downloadFinder = find.text(downloadSpeedText);
  expect(uploadFinder, findsOneWidget);
  expect(downloadFinder, findsOneWidget);
}

_testAllOtherElements() {
  final dateString = DateFormat('dd.MM.yyyy HH:mm')
      .format(DateTime.parse('2020-01-01T15:00:00.000Z').toLocal());
  final dateTimeFinder = find.text(dateString);
  final deviceFinder = find.text('iPhone');
  final pingFinder = find.text('100');
  final uploadFinder = find.text('1');
  final downloadFinder = find.text('2');
  expect(dateTimeFinder, findsOneWidget);
  expect(deviceFinder, findsOneWidget);
  expect(pingFinder, findsOneWidget);
  expect(uploadFinder, findsOneWidget);
  expect(downloadFinder, findsOneWidget);
}
