import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/history-item.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-results.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/loop-measurement-result/loop-measurement-result.screen.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/services/measurement-result.service.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';

import '../../di/service-locator.dart';
import '../../util/widget-tester.ext.dart';

late MeasurementResultCubit _cubit;
final _testUuid = 'testUuid';
final _loopUuid = 'loopUuid';
final _result = MeasurementHistoryResults([
  MeasurementHistoryResult(
      testUuid: _testUuid,
      loopModeUuid: _loopUuid,
      uploadKbps: 60000.0,
      downloadKbps: 50000.0,
      pingMs: 30.0,
      jitterMs: 10.0,
      packetLossPercents: 16.0,
      measurementDate: '2123-02-16T15:01:54.609Z'),
  MeasurementHistoryResult(
      testUuid: _testUuid + _testUuid,
      loopModeUuid: _loopUuid,
      uploadKbps: 70000,
      downloadKbps: 80000,
      pingMs: 40,
      jitterMs: 20,
      packetLossPercents: 17.0,
      measurementDate: '2122-02-21',
      userExperienceMetrics: [])
]);
final _args = {
  LoopMeasurementResultScreen.argumentResult: _result,
  LoopMeasurementResultScreen.argumentTestUuid: _loopUuid
};
final _widget = BlocProvider.value(
  value: _cubit,
  child: LoopMeasurementResultScreen()
);

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    _cubit = MeasurementResultCubit();
    TestingServiceLocator.swapLazySingleton<MeasurementResultCubit>(
            () => _cubit);
    when(GetIt.I.get<MeasurementResultService>().getResultWithSpeedCurves(
      _loopUuid,
      result: _result.tests.first,
      errorHandler: _cubit,
    )).thenAnswer((realInvocation) async => _result.tests.first);
    when(GetIt.I.get<CMSService>().getProject()).thenAnswer(
            (realInvocation) async => NTProject(enableAppResultsSharing: true, enableAppJitterAndPacketLoss: true));
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
        .get<SharedPreferencesWrapper>()
        .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
  });

  group('Loop measurement result screen', () {
    testWidgets('shows all measurements', (tester) async {
      await tester.pumpWidgetWithArguments(_widget, arguments: _args);
      await tester.pumpAndSettle();
      expect(find.byType(NTAppBar), findsOneWidget);
      expect(find.byIcon(Icons.share), findsNothing);
      expect(find.text('Loop measurements'), findsOneWidget);
      expect(find.text('Median values'), findsOneWidget);
      expect(find.text('JITTER'), findsOneWidget);
      expect(find.text('PACKET LOSS'), findsOneWidget);
      expect(find.text('PING'), findsOneWidget);
      expect(find.text('DOWNLOAD'), findsOneWidget);
      expect(find.text('UPLOAD'), findsOneWidget);
      expect(find.textContaining('Download'), findsOneWidget);
      expect(find.textContaining('Upload'), findsOneWidget);
      expect(find.textContaining('Ping'), findsOneWidget);
      expect(find.textContaining('%', findRichText: true), findsOneWidget);
      expect(find.textContaining('ms', findRichText: true), findsNWidgets(3));
      expect(find.textContaining('30'), findsOneWidget);
      expect(find.textContaining('80'), findsOneWidget);
      expect(find.textContaining('70'), findsOneWidget);
      expect(find.textContaining('60'), findsOneWidget);
      expect(find.textContaining('50'), findsOneWidget);
      expect(find.textContaining('15', findRichText: true), findsOneWidget);
      expect(find.textContaining('35', findRichText: true), findsOneWidget);
      expect(find.textContaining('16.5', findRichText: true), findsOneWidget);
      expect(find.textContaining('65', findRichText: true), findsNWidgets(2));
      expect(find.textContaining('Mbps', findRichText: true), findsNWidgets(4));
      expect(find.byType(HistoryItemWidget), findsNWidgets(2));
      final firstItem = find.textContaining('16.02.2123');
      expect(firstItem, findsOneWidget);
    });

    testWidgets('allows back navigation', (tester) async {
      await tester.pumpWidgetWithArguments(_widget, arguments: _args);
      await tester.pumpAndSettle();
      final btn = find.byIcon(Icons.arrow_back);
      expect(btn, findsOneWidget);
      when(GetIt.I.get<NavigationService>().goBack()).thenReturn(null);
      await tester.tap(btn);
      verify(GetIt.I.get<NavigationService>().goBack()).called(1);
    });
  });
}
