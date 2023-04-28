import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/loop-mode-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';
import 'package:nt_flutter_standalone/modules/measurements/screens/servers.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/loop.mode.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurements.api.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';

import '../../di/service-locator.dart';

final _loopModeDetails = LoopModeDetails(medians: HashMap());

final _servers = [
  MeasurementServer(
    id: 1,
    uuid: 'uuid',
    city: 'Cupertino',
    name: 'Name',
    distance: 400000,
  ),
  MeasurementServer(
    id: 2,
    uuid: 'uuid2',
    city: 'Cupertino',
    name: 'Name',
  ),
];

final String _selectedLocaleTag = 'sr-Latn-rs';

final _location = LocationModel(latitude: 0.0, longitude: 0.0);

late MaterialApp _widget;

late MeasurementsBloc _bloc;

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    _bloc = MeasurementsBloc();
    when(GetIt.I.get<SharedPreferencesWrapper>().init()).thenAnswer((_) async => null);
    when(GetIt.I.get<SharedPreferencesWrapper>().getString(StorageKeys.selectedLocaleTag)).thenReturn(_selectedLocaleTag);
    when(GetIt.I
        .get<MeasurementsApiService>()
        .getMeasurementServersForCurrentFlavor(
          location: _location,
          errorHandler: _bloc.errorHandler,
        )).thenAnswer((realInvocation) async => _servers);
    when(GetIt.I.get<LoopModeService>().updateLocation(_location)).thenAnswer((_) {});
    when(GetIt.I.get<LoopModeService>().isLoopModeActivated).thenAnswer((_) => false);
    when(GetIt.I.get<LoopModeService>().loopModeDetails).thenAnswer((_) => _loopModeDetails);
    _bloc.add(SetLocationInfo(_location));
    TestingServiceLocator.swapLazySingleton<MeasurementsBloc>(() => _bloc);
    _widget = MaterialApp(
      home: BlocProvider<MeasurementsBloc>(
        create: (context) => _bloc,
        child: ServersScreen(),
      ),
    );
  });

  group('Services screen widget', () {
    testWidgets('is shown and can be closed', (tester) async {
      await tester.pumpWidget(_widget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(NTAppBar), findsOneWidget);
      expect(find.text("Measurement Server"), findsOneWidget);
      final closeButtonFinder = find.byKey(ServersScreen.closeButtonKey);
      expect(closeButtonFinder, findsOneWidget);
      expect(tester.widget<IconButton>(closeButtonFinder).onPressed, isNotNull);
      await tester.tap(closeButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text("Measurement Server"), findsNothing);
    });
    testWidgets('contains a list of servers and allows selection',
        (tester) async {
      await tester.pumpWidget(_widget);
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(InkWell), findsNWidgets(2));
      expect(find.text("Name (Cupertino)"), findsNWidgets(2));
      expect(find.text("400 km"), findsOneWidget);
      expect(find.text("Distance unknown"), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      var inkWell = tester
          .element(find.byIcon(Icons.check))
          .findAncestorWidgetOfExactType<InkWell>();
      final inkWell2 = tester
          .element(find.text("Distance unknown"))
          .findAncestorWidgetOfExactType<InkWell>();
      expect(inkWell == inkWell2, false);
      await tester.tap(find.text("Distance unknown"));
      await tester.pumpAndSettle();
      expect(find.text("Measurement Server"), findsNothing);
    });
  });
}
