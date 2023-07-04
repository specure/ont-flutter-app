import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.state.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-details.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-phase.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-list-factory.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/web-net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-result-details/net-neutrality-result-details.screen.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';
import 'package:sprintf/sprintf.dart';

import '../../di/service-locator.dart';

class MockNetNeutralityCubit extends MockCubit<NetNeutralityState>
    implements NetNeutralityCubit {}

final NetNeutralityCubit _cubit = MockNetNeutralityCubit();

final _historyJson = jsonDecode(
    File('test/net-neutrality/unit-tests/data/net-neutrality-history.json')
        .readAsStringSync());
final _history = NetNeutralityHistoryListFactory.parseHistoryResponse(
  _historyJson,
);

final HistoryState _historyState = HistoryState(speedHistory: []);

final _webResultDetailsJson = jsonDecode(File(
        'test/net-neutrality/unit-tests/data/net-neutrality-result-details-web.json')
    .readAsStringSync());
final _webResultDetails = NetNeutralityHistoryListFactory.parseHistoryResponse(
  _webResultDetailsJson,
);

final NetNeutralityState _webDetailsState = NetNeutralityState(
    interimResults: [],
    phase: NetNeutralityPhase.none,
    historyResults: _history,
    resultDetailsConfig: NetNeutralityDetailsConfig.webTestConfig,
    resultDetailsItems: _webResultDetails);

final _dnsResultDetailsJson = jsonDecode(File(
        'test/net-neutrality/unit-tests/data/net-neutrality-result-details-dns.json')
    .readAsStringSync());
final _dnsResultDetails = NetNeutralityHistoryListFactory.parseHistoryResponse(
  _dnsResultDetailsJson,
);

final NetNeutralityState _dnsDetailsState = NetNeutralityState(
  interimResults: [],
  phase: NetNeutralityPhase.none,
  historyResults: _history,
  resultDetailsConfig: NetNeutralityDetailsConfig.dnsTestConfig,
  resultDetailsItems: _dnsResultDetails,
);

final Widget _screen = BlocProvider<NetNeutralityCubit>(
  create: (context) => _cubit,
  child: MediaQuery(
    data: MediaQueryData(),
    child: MaterialApp(home: const NetNeutralityResultDetailScreen()),
  ),
);

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    whenListen(_cubit, Stream.fromIterable([_webDetailsState]),
        initialState: _webDetailsState);
    whenListen(
        GetIt.I.get<HistoryCubit>(), Stream.fromIterable([_historyState]),
        initialState: _historyState);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn('en-US');
  });

  group('Web net neutrality result screen details', () {
    testWidgets("shows results", (tester) async {
      await tester.pumpWidget(_screen);
      await tester.pumpAndSettle();
      expect(find.text("Web page"), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byType(SectionTitle), findsOneWidget);
      expect(
          (find.byType(SectionTitle).evaluate().single.widget as SectionTitle)
              .text,
          'Information');
      expect(find.text("TARGET"), findsOneWidget);
      expect(find.text("TIME"), findsOneWidget);
      expect(find.text("STATUS"), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.highlight_remove_rounded), findsOneWidget);
      _webDetailsState.resultDetailsItems?.forEach((element) {
        expect(find.text((element as WebNetNeutralityHistoryItem).url),
            findsOneWidget);
        expect(
            find.text(element.actualStatusCode == null
                ? "-"
                : element.actualStatusCode.toString()),
            findsOneWidget);
        expect(find.text(sprintf("%s ms", [(element.durationNs ~/ 1000000)])),
            findsOneWidget);
      });
      expect(find.text('Expected'), findsOneWidget);
      expect(find.text('< 10000 ms'), findsOneWidget);
      expect(find.text('301'), findsOneWidget);
      when(GetIt.I.get<NavigationService>().goBack()).thenReturn(null);
      await tester.tap(find.byIcon(Icons.arrow_back));
      verify(GetIt.I.get<NavigationService>().goBack()).called(1);
    });
  });

  group('DNS net neutrality result screen details', () {
    testWidgets("shows results", (tester) async {
      whenListen(_cubit, Stream.fromIterable([_dnsDetailsState]),
          initialState: _dnsDetailsState);
      await tester.pumpWidget(_screen);
      await tester.pumpAndSettle();
      expect(find.text("DNS"), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byType(SectionTitle), findsOneWidget);
      expect(
          (find.byType(SectionTitle).evaluate().single.widget as SectionTitle)
              .text,
          'Information');
      expect(find.text("TARGET"), findsOneWidget);
      expect(find.text("TIME"), findsOneWidget);
      expect(find.text("STATUS"), findsOneWidget);
      expect(find.text("IP ADDRESS"), findsOneWidget);

      var succeedCount = _dnsDetailsState.resultDetailsItems
              ?.where((element) =>
                  element.testStatus == NetNeutralityTestStatus.SUCCEED)
              .length ??
          0;
      var failedCount = _dnsDetailsState.resultDetailsItems
              ?.where((element) =>
                  element.testStatus != NetNeutralityTestStatus.SUCCEED)
              .length ??
          0;
      expect(find.byIcon(Icons.check_circle), findsNWidgets(succeedCount));
      expect(find.byIcon(Icons.highlight_remove_rounded),
          findsNWidgets(failedCount));

      _dnsDetailsState.resultDetailsItems?.forEach((element) {
        expect(find.text((element as DnsNetNeutralityHistoryItem).target ?? ""),
            findsOneWidget);
        expect(find.text("Resolver: ${element.actualResolver ?? ""}"),
            findsOneWidget);
        if (element.durationNs < 10000000000) {
          expect(find.text(sprintf("%s ms", [(element.durationNs ~/ 1000000)])),
              findsOneWidget);
        }
      });
      expect(find.text('Expected'), findsNWidgets(3));
      expect(find.text('< 10000 ms'), findsNWidgets(3));
      expect(find.text('No error'), findsNWidgets(5));
      expect(find.text('Does not exist'), findsNWidgets(2));
      expect(find.text('-'), findsNWidgets(3));
      expect(find.text('192.192.192.192'), findsNWidgets(4));
      expect(find.text('193.193.193.193'), findsOneWidget);
      expect(find.text('190.190.190.190'), findsOneWidget);
    });
  });
}
