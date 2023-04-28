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
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/constants/measurement-quality-category.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/constants/measurement-quality-estimate.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-results.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-quality.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/advanced-results.screen.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/measurement-result/measurement-result.screen.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/services/measurement-result.service.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/qoe-estimate.widget.dart';

import '../../di/service-locator.dart';
import '../../util/widget-tester.ext.dart';

late MeasurementResultCubit _cubit;
final _testUuid = 'testUuid';
final _result = MeasurementHistoryResults([
  MeasurementHistoryResult(
      testUuid: 'testUuid',
      uploadKbps: 30000,
      downloadKbps: 30000,
      pingMs: 30,
      measurementDate: '2022-02-22',
      userExperienceMetrics: [
        MeasurementQuality.fromJson({
          'category': MeasurementQualityCategory.videoStreaming,
          'quality': MeasurementQualityEstimate.good,
        }),
        MeasurementQuality.fromJson({
          'category': MeasurementQualityCategory.onlineGaming,
          'quality': MeasurementQualityEstimate.good,
        }),
        MeasurementQuality.fromJson({
          'category': MeasurementQualityCategory.socialMedia,
          'quality': MeasurementQualityEstimate.good,
        }),
        MeasurementQuality.fromJson({
          'category': MeasurementQualityCategory.email,
          'quality': MeasurementQualityEstimate.good,
        }),
      ])
]);
final _args = {
  MeasurementResultScreen.argumentResult: _result,
  MeasurementResultScreen.argumentTestUuid: _testUuid
};
final _widget = BlocProvider.value(
  value: _cubit,
  child: MeasurementResultScreen(),
);

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    _cubit = MeasurementResultCubit();
    TestingServiceLocator.swapLazySingleton<MeasurementResultCubit>(
        () => _cubit);
    when(GetIt.I.get<MeasurementResultService>().getResultWithSpeedCurves(
          _testUuid,
          result: _result.tests.first,
          errorHandler: _cubit,
        )).thenAnswer((realInvocation) async => _result.tests.first);
    when(GetIt.I.get<CMSService>().getProject()).thenAnswer(
        (realInvocation) async => NTProject(enableAppResultsSharing: true));
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
  });

  group('Measurement result screen', () {
    testWidgets('shows the main sections', (tester) async {
      await tester.pumpWidgetWithArguments(_widget, arguments: _args);
      await tester.pumpAndSettle();
      expect(find.byType(NTAppBar), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.text('Measurement details'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text('Mbps'), findsOneWidget);
      expect(find.byType(QoeEstimate), findsNWidgets(3));
      expect(find.text('MOST POPULAR SERVICES'), findsOneWidget);
      expect(find.text('DATE & TIME'), findsOneWidget);
      expect(find.text('PHONE INFORMATION'), findsOneWidget);
      expect(find.text('NETWORK TYPE'), findsOneWidget);
      expect(find.text('NETWORK NAME'), findsOneWidget);
    });
    testWidgets('allows navigation to advanced results', (tester) async {
      await tester.pumpWidgetWithArguments(_widget, arguments: _args);
      await tester.pumpAndSettle();
      final btn = find.text('Switch to Advanced Results');
      expect(btn, findsOneWidget);
      when(GetIt.I
              .get<NavigationService>()
              .pushNamed(AdvancedResultsScreen.route))
          .thenReturn(null);
      await tester.dragUntilVisible(
          btn, find.byType(SingleChildScrollView), Offset(0, 50));
      await tester.tap(btn);
      verify(GetIt.I
              .get<NavigationService>()
              .pushNamed(AdvancedResultsScreen.route))
          .called(1);
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
