import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/permissions-map.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/home-info-box-item.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/home-info-box.widget.dart';
import '../../di/service-locator.dart';
import 'start-test.widget_test.dart';

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<PlatformWrapper>().isAndroid)
        .thenReturn(true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
    when(GetIt.I
        .get<NavigationService>()
        .goBack())
        .thenAnswer((realInvocation) async => null);
  });

  group('Test bottom box widget', () {
    testWidgets('Test missing permissions are shown', (tester) async {
      await _testMissingPermissionsAreShown(tester);
    });
    testWidgets('Test network info is shown', (tester) async {
      await _testNetworkInfoIsShown(tester);
    });
    testWidgets('Test missing precise location permission', (tester) async {
      await _testMissingPreciseLocationPermissionsAreShown(tester);
    });
    testWidgets('Test disabled location services ', (tester) async {
      await _testDisabledLocationServices(tester);
    });
    testWidgets('Test dialog dismiss', (tester) async {
      await _testPermissionProblemDialogDismiss(tester);
    });
  });
}

Future _testMissingPermissionsAreShown(WidgetTester tester) async {
  final state = MeasurementsState.init().copyWith(
    permissions: PermissionsMap(
      locationPermissionsGranted: false,
      readPhoneStatePermissionsGranted: false,
    ),
  );
  final bloc = setUpMeasurementsBloc(state);
  await tester.pumpWidget(
    getNecessaryParentWidgets<MeasurementsBloc>(
      bloc,
      HomeInfoBox(),
    ),
  );
  final locationPermissionTextFinder =
      find.widgetWithText(HomeInfoBoxItem, 'Missing location permissions');
  expect(locationPermissionTextFinder, findsOneWidget);
}

Future _testNetworkInfoIsShown(WidgetTester tester) async {
  final state = MeasurementsState.init().copyWith(
    networkInfoDetails: NetworkInfoDetails(
      mobileNetworkGeneration: '4G',
      type: 'LTE',
      name: 'Provider',
    ),
    permissions: PermissionsMap(
      locationPermissionsGranted: true,
      readPhoneStatePermissionsGranted: true,
    ),
  );
  final bloc = setUpMeasurementsBloc(state);
  await tester.pumpWidget(
    getNecessaryParentWidgets<MeasurementsBloc>(
      bloc,
      HomeInfoBox(),
    ),
  );
  final networkTypeTextFinder =
      find.widgetWithText(HomeInfoBoxItem, '4G (LTE)');
  final networkNameTextFinder =
      find.widgetWithText(HomeInfoBoxItem, 'Provider');
  expect(networkTypeTextFinder, findsOneWidget);
  expect(networkNameTextFinder, findsOneWidget);
}

Future _testMissingPreciseLocationPermissionsAreShown(WidgetTester tester) async {
  final state = MeasurementsState.init().copyWith(
    permissions: PermissionsMap(
      locationPermissionsGranted: true,
      readPhoneStatePermissionsGranted: true,
      preciseLocationPermissionsGranted: false
    ),
    locationServicesEnabled: true
  );
  final bloc = setUpMeasurementsBloc(state);
  await tester.pumpWidget(
    getNecessaryParentWidgets<MeasurementsBloc>(
      bloc,
      HomeInfoBox(),
    ),
  );
  final warningIconFinder = find.byIcon(Icons.warning);
  expect(warningIconFinder, findsOneWidget);
  await tester.tap(warningIconFinder);
  await tester.pumpAndSettle();
  expect(find.text('Missing permissions', skipOffstage: false), findsOneWidget);
  expect(find.text("We need permission to access the precise location in order to provide more accurate information ***REMOVED*** your network connection."), findsOneWidget);
  var cancel = find.text('Cancel');
  expect(cancel, findsOneWidget);
  var openSettings = find.text('Change settings');
  expect(openSettings, findsOneWidget);
  await tester.tap(openSettings);
  await tester.pumpAndSettle();
  verify(GetIt.I.get<NavigationService>().goBack(levels: 1)).called(1);
}

Future _testDisabledLocationServices(WidgetTester tester) async {
  final state = MeasurementsState.init().copyWith(
      permissions: PermissionsMap(
          locationPermissionsGranted: true,
          readPhoneStatePermissionsGranted: true,
          preciseLocationPermissionsGranted: true
      ),
      locationServicesEnabled: false
  );
  final bloc = setUpMeasurementsBloc(state);
  await tester.pumpWidget(
    getNecessaryParentWidgets<MeasurementsBloc>(
        bloc,
        HomeInfoBox()
    ),
  );
  final warningIconFinder = find.byIcon(Icons.warning);
  expect(warningIconFinder, findsOneWidget);
  await tester.tap(warningIconFinder);
  await tester.pumpAndSettle();
  expect(find.text('Location services disabled'), findsOneWidget);
  expect(find.text(
      "We need enabled location services in order to provide more accurate information ***REMOVED*** your network connection."),
      findsOneWidget);
  var cancel = find.text('Cancel');
  expect(cancel, findsOneWidget);
  var openSettings = find.text('Change settings');
  expect(openSettings, findsOneWidget);
  await tester.tap(openSettings);
  await tester.pumpAndSettle();
  verify(GetIt.I.get<NavigationService>().goBack(levels: 1)).called(1);
}

Future _testPermissionProblemDialogDismiss(WidgetTester tester) async {
  final state = MeasurementsState.init().copyWith(
      permissions: PermissionsMap(
          locationPermissionsGranted: true,
          readPhoneStatePermissionsGranted: true,
          preciseLocationPermissionsGranted: true
      ),
      locationServicesEnabled: false
  );
  final bloc = setUpMeasurementsBloc(state);
  await tester.pumpWidget(
    getNecessaryParentWidgets<MeasurementsBloc>(
        bloc,
        HomeInfoBox()
    ),
  );
  final warningIconFinder = find.byIcon(Icons.warning);
  expect(warningIconFinder, findsOneWidget);
  await tester.tap(warningIconFinder);
  await tester.pumpAndSettle();
  var cancel = find.text('Cancel');
  expect(cancel, findsOneWidget);
  await tester.tap(cancel);
  await tester.pumpAndSettle();
  verify(GetIt.I.get<NavigationService>().goBack(levels: 1)).called(1);
}

MeasurementsBloc setUpMeasurementsBloc(MeasurementsState initState,
    [List<MeasurementsState>? states]) {
  final bloc = MockMeasurementsBloc();
  if ((states?.length ?? 0) > 0) {
    whenListen(
      bloc,
      Stream.fromIterable([initState, ...states!]),
      initialState: initState,
    );
  } else {
    whenListen(
      bloc,
      Stream.fromIterable([initState]),
      initialState: initState,
    );
  }
  return bloc;
}
