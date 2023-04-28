import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets***REMOVED***-info.widget.dart';

import '../../di/service-locator.dart';

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
  });
  group(
      'IP info widget when color coding is enabled and private IPs are visible',
      () {
    testWidgets('when no connectivity', (widgetTester) async {
      final widget = IPInfo(
        state: MeasurementsState.init().copyWith(
          project: NTProject(
            enableAppIpColorCoding: true,
            enableAppPrivateIp: true,
          ),
        ),
        badgeText: 'IPv4',
        statusColor: NetworkInfoDetails.yellow,
        privateAddress: 'private',
        publicAddress: 'public',
      );
      expect(widget.badgeColor, Colors.grey);
      expect(widget.badgeTextColor, Colors.white);
      await widgetTester.pumpWidget(MaterialApp(home: widget));
      expect(find.text('IPv4'), findsOneWidget);
      expect(find.text('Private address'.toUpperCase()), findsOneWidget);
      expect(find.text('Public address'.toUpperCase()), findsOneWidget);
      expect(find.text(addressIsNotAvailable), findsNWidgets(2));
    });
    testWidgets('when connected', (widgetTester) async {
      final widget = IPInfo(
        state: MeasurementsState.init().copyWith(
          connectivity: ConnectivityResult.wifi,
          project: NTProject(
            enableAppIpColorCoding: true,
            enableAppPrivateIp: true,
          ),
        ),
        badgeText: 'IPv4',
        statusColor: NetworkInfoDetails.yellow,
        privateAddress: 'private',
        publicAddress: 'public',
      );
      expect(widget.badgeColor, NetworkInfoDetails.yellow);
      expect(widget.badgeTextColor, Colors.black);
      await widgetTester.pumpWidget(MaterialApp(home: widget));
      expect(find.text('IPv4'), findsOneWidget);
      expect(find.text('Private address'.toUpperCase()), findsOneWidget);
      expect(find.text('Public address'.toUpperCase()), findsOneWidget);
      expect(find.text('private'), findsOneWidget);
      expect(find.text('public'), findsOneWidget);
    });
  });

  group(
      'IP info widget when color coding is disabled and private IPs are hidden',
      () {
    testWidgets('when no connectivity', (widgetTester) async {
      final widget = IPInfo(
        state: MeasurementsState.init(),
        badgeText: 'IPv4',
        statusColor: NetworkInfoDetails.yellow,
        privateAddress: 'private',
        publicAddress: 'public',
      );
      expect(widget.badgeColor, Colors.grey);
      expect(widget.badgeTextColor, Colors.white);
      await widgetTester.pumpWidget(MaterialApp(home: widget));
      expect(find.text('IPv4'), findsOneWidget);
      expect(find.text('Private address'.toUpperCase()), findsNothing);
      expect(find.text('Public address'.toUpperCase()), findsNothing);
      expect(find.text(addressIsNotAvailable), findsNWidgets(1));
    });
    testWidgets('when connected', (widgetTester) async {
      final widget = IPInfo(
        state: MeasurementsState.init().copyWith(
          connectivity: ConnectivityResult.wifi,
        ),
        badgeText: 'IPv4',
        statusColor: NetworkInfoDetails.yellow,
        privateAddress: 'private',
        publicAddress: 'public',
      );
      expect(widget.badgeColor, Colors.grey);
      expect(widget.badgeTextColor, Colors.white);
      await widgetTester.pumpWidget(MaterialApp(home: widget));
      expect(find.text('IPv4'), findsOneWidget);
      expect(find.text('Private address'.toUpperCase()), findsNothing);
      expect(find.text('Public address'.toUpperCase()), findsNothing);
      expect(find.text('private'), findsNothing);
      expect(find.text('public'), findsOneWidget);
    });
  });
}
