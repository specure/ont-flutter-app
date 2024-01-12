import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-measurement/net-neutrality-measurement.screen.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/net-neutrality-measurement-box.widget.dart';

import '../../di/service-locator.dart';
import '../unit-tests/net-neutrality-measurement-service_test.mocks.dart';

class MockNetNeutralityCubit extends MockCubit<NetNeutralityState>
    implements NetNeutralityCubit {}

final NetNeutralityCubit _cubit = MockNetNeutralityCubit();
final NetNeutralityState _state = NetNeutralityState(
  interimResults: [],
  historyResults: [],
  lastResultForCurrentPhase: 50,
);
final Widget _screen = BlocProvider<NetNeutralityCubit>(
  create: (context) => _cubit,
  child: MediaQuery(
    data: MediaQueryData(size: Size(800, 1200)),
    child: MaterialApp(home: const NetNeutralityMeasurementScreen()),
  ),
);

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    whenListen(_cubit, Stream.fromIterable([_state]), initialState: _state);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn('en-US');
  });

  group('Net neutrality result screen', () {
    testWidgets("shows results", (tester) async {
      await tester.pumpWidget(_screen);
      await tester.pumpAndSettle();
      expect(find.text("Net Neutrality"), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(NetNeutralityMeasurementBox), findsOneWidget);
      expect(find.text("%", skipOffstage: false), findsOneWidget);
      final cubitCalls = MockNetNeutralityCubitCalls();
      TestingServiceLocator.swapLazySingleton<NetNeutralityCubit>(
          () => cubitCalls);
      await tester.tap(find.byIcon(Icons.close));
      verify(cubitCalls.stopMeasurement());
    });
  });
}
