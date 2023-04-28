import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:nt_flutter_standalone/core/di/service-locator.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.state.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/results-metadata/results-metadata.view.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/text-section.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'results-qos-view-widget_test.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    ServiceLocator.registerInstances();
    await dotenv.load(fileName: '.env');
  });

  testWidgets('Test Results metadata view widget', (tester) async {
    final state = await _setUpStateAndPumpWidget(tester);
    _testMetadataView(state);
  });
}

_testMetadataView(MeasurementResultState state) {
  final dateTimeFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Date & Time' &&
      DateFormat('dd.MM.yyyy HH:mm').parseStrict(widget.value) ==
          DateTime.parse(state.result!.measurementDate).toLocal());
  final phoneFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Phone information' &&
      widget.value == state.result!.device);
  final networkTypeFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Network type' &&
      widget.value == state.result!.networkType &&
      widget.icon == Icons.signal_cellular_alt_outlined);
  final networkNameFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Network name' &&
      widget.value == state.result!.operator);
  final measurementServerFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Measurement Server' &&
      widget.value == state.result!.measurementServerName);
  final locationFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Location' &&
      widget.value == state.result!.location!.locationString);
  expect(dateTimeFinder, findsOneWidget);
  expect(phoneFinder, findsOneWidget);
  expect(networkTypeFinder, findsOneWidget);
  expect(networkNameFinder, findsOneWidget);
  expect(measurementServerFinder, findsOneWidget);
  expect(locationFinder, findsOneWidget);
}

Future<MeasurementResultState> _setUpStateAndPumpWidget(
    WidgetTester tester) async {
  final state = MeasurementResultState(
    result: MeasurementHistoryResult(
      testUuid: 'uuid',
      uploadKbps: 1000,
      downloadKbps: 2000,
      pingMs: 100,
      measurementDate: '2020-01-01T15:00:00.000Z',
      userExperienceMetrics: [],
      networkType: '3G',
      operator: 'Provider',
      device: 'iPhone',
      measurementServerName: 'Server',
      measurementServerCity: 'Washington, D.C.',
      location: LocationModel(
        latitude: 10.0,
        longitude: 20.0,
        country: 'USA',
        county: 'Cupertino',
        city: 'Cupertino',
      ),
    ),
  );
  final cubit = setUpMeasurementResultCubit(state);
  await tester.pumpWidget(
    BlocProvider<MeasurementResultCubit>(
      create: (cntx) => cubit,
      child: MaterialApp(
        home: const ResultsMetadataView(
          navFinished: true,
        ),
      ),
    ),
  );
  return state;
}
