import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:nt_flutter_standalone/core/di/service-locator.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/text-section.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/web-net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/results-metadata/nn-results-metadata.view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'net-neutrality-result-details-screen_test.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    ServiceLocator.registerInstances();
    await dotenv.load(fileName: '.env');
  });

  testWidgets('NN Test Results metadata view widget', (tester) async {
    final state = await _setUpStateAndPumpWidget(tester);
    _testMetadataView(state);
  });
}

_testMetadataView(NetNeutralityState state) {
  final dateTimeFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Date & Time' &&
      DateFormat('dd.MM.yyyy HH:mm').parseStrict(widget.value) ==
          DateTime.parse(state.historyResults.first.measurementDate).toLocal());
  final phoneFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Phone information' &&
      widget.value == state.historyResults.first.device);
  final networkTypeFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Network type' &&
      widget.value ==
          "${state.historyResults.first.networkType} (${state.historyResults.first.networkName})" &&
      widget.icon == Icons.signal_cellular_alt_outlined);
  final networkNameFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Network name' &&
      widget.value == state.historyResults.first.operator);
  final locationFinder = find.byWidgetPredicate((widget) =>
      widget is TextSection &&
      widget.title == 'Location' &&
      widget.value == state.historyResults.first.location!.locationString);
  expect(dateTimeFinder, findsOneWidget);
  expect(phoneFinder, findsOneWidget);
  expect(networkTypeFinder, findsOneWidget);
  expect(networkNameFinder, findsOneWidget);
  expect(locationFinder, findsOneWidget);
}

Future<NetNeutralityState> _setUpStateAndPumpWidget(WidgetTester tester) async {
  final state = NetNeutralityState(
    interimResults: [],
    historyResults: [
      WebNetNeutralityHistoryItem(
          url: "google.com",
          timeout: 5000,
          expectedStatusCode: 200,
          timeoutExceeded: false,
          clientUuid: "clientUuid",
          durationNs: 2000000,
          measurementDate: '2020-01-01T15:00:00.000Z',
          openTestUuid: "openTestUuid",
          testStatus: "SUCCEED",
          type: "WEB",
          uuid: "uuid",
          device: "Mega phone",
          networkType: "4G",
          networkName: "LTE",
          location: LocationModel(
            latitude: 10.0,
            longitude: 20.0,
            country: 'USA',
            county: 'Cupertino',
            city: 'Cupertino',
          ),
          operator: "O2")
    ],
    loading: false,
  );

  final cubit = setUpMeasurementResultCubit(state);
  await tester.pumpWidget(
    BlocProvider<NetNeutralityCubit>(
      create: (cntx) => cubit,
      child: MaterialApp(
        home: const NetNeutralityResultsMetadataView(
          navFinished: true,
        ),
      ),
    ),
  );
  return state;
}

NetNeutralityCubit setUpMeasurementResultCubit(NetNeutralityState state) {
  final cubit = MockNetNeutralityCubit();
  whenListen(
    cubit,
    Stream.fromIterable([state]),
    initialState: state,
  );
  return cubit;
}
