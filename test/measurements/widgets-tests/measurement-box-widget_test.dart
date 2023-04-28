import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/measurement-box.widget.dart';

import '../../di/service-locator.dart';
import 'bottom-box-widget_test.dart';
import 'start-test.widget_test.dart';

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init()).thenAnswer((_) async => null);
    when(GetIt.I.get<SharedPreferencesWrapper>().getString(StorageKeys.selectedLocaleTag)).thenReturn(_selectedLocaleTag);
  });

  group('Test measurement box widget', () {
    testWidgets('Test init phase', (tester) async {
      await _testInitPhase(tester);
    });
    testWidgets('Test speed phase', (tester) async {
      await _testSpeedPhase(tester);
    });
  });
}

Future _testInitPhase(WidgetTester tester) async {
  final state = MeasurementsState.init().copyWith(
    phase: MeasurementPhase.init,
  );
  final bloc = setUpMeasurementsBloc(state);
  await tester.pumpWidget(
    getNecessaryParentWidgets<MeasurementsBloc>(
      bloc,
      MeasurementBox(),
    ),
  );
  final phaseNameTextFinder = find.text(state.phase.name.toUpperCase());
  final circularProgressIndicatorFinder =
      find.byType(CircularProgressIndicator);
  expect(phaseNameTextFinder, findsOneWidget);
  expect(circularProgressIndicatorFinder, findsOneWidget);
}

Future _testSpeedPhase(WidgetTester tester) async {
  final state = MeasurementsState.init()
      .copyWith(phase: MeasurementPhase.down, phaseProgress: {
    MeasurementPhase.down: [1, 2, 3.589],
  });
  final bloc = setUpMeasurementsBloc(state);
  await tester.pumpWidget(
    getNecessaryParentWidgets<MeasurementsBloc>(
      bloc,
      MeasurementBox(),
    ),
  );
  final phaseNameTextFinder = find.text(state.phase.name.toUpperCase());
  final valueTextFinder = find.text('3.59');
  final unitTextFinder = find.text(state.phase.progressUnits);
  expect(phaseNameTextFinder, findsOneWidget);
  expect(valueTextFinder, findsOneWidget);
  expect(unitTextFinder, findsOneWidget);
}
