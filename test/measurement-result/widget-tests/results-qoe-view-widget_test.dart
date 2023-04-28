import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/di/service-locator.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/wrappers/url-launcher-wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-quality.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.state.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/qoe-estimate.widget.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/result-bottom-sheet.widget.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/results-qoe.view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../di/service-locator.dart';
import 'results-qos-view-widget_test.dart';
import 'results-qos-view-widget_test.mocks.dart';

final _pageUrl = "https://pageUrl.com";
late final MeasurementResultCubit _cubit;

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ServiceLocator.registerInstances();
  });

  testWidgets('Test Results QoE view widget', (tester) async {
    await _setUpStateAndPumpWidget(tester);
    final qoeEstimateFinder = find.byType(QoeEstimate);
    expect(qoeEstimateFinder, findsNWidgets(3));
    final cubit = MockMeasurementResultCubitCalls();
    TestingServiceLocator.swapLazySingleton<MeasurementResultCubit>(
        () => cubit);
    final mockUrlLauncher = MockUrlLauncherWrapper();
    TestingServiceLocator.swapLazySingleton<UrlLauncherWrapper>(
        () => mockUrlLauncher);
    when(mockUrlLauncher.canLaunch(Uri.parse(_pageUrl)))
        .thenAnswer((_) async => true);
    when(mockUrlLauncher.launch(Uri.parse(_pageUrl)))
        .thenAnswer((_) async => true);
    var qoeExplanationIcon = find.byIcon(Icons.info_outline);
    expect(qoeExplanationIcon, findsOneWidget);
    var qoeExplanationTextFinder = find.textContaining("Experience");
    expect(qoeExplanationTextFinder, findsOneWidget);
    var qoeExplanationFinder =
        find.text("Learn more about Quality of Experience");
    expect(qoeExplanationFinder, findsOneWidget);
    await tester.tap(qoeExplanationFinder);
    await tester.pumpAndSettle();
    verify(cubit.getPage(any, pageContent: anyNamed('pageContent'))).called(1);
    var bottomSheetFinder = find.byType(ResultBottomSheet);
    expect(bottomSheetFinder, findsOneWidget);
    var linkPage = find.text("Read more on our website");
    expect(linkPage, findsOneWidget);
    await tester.tap(linkPage);
    await tester.pumpAndSettle();
    verify(mockUrlLauncher.canLaunch(Uri.parse(_pageUrl))).called(1);
    verify(mockUrlLauncher.launch(Uri.parse(_pageUrl))).called(1);
  });
}

Future<MeasurementResultState> _setUpStateAndPumpWidget(
    WidgetTester tester) async {
  final state = MeasurementResultState(
    staticPageUrl: _pageUrl,
    project: NTProject.fromJson({"enable_app_qoe_result_explanation": true}),
    result: MeasurementHistoryResult(
      testUuid: 'uuid',
      uploadKbps: 1000,
      downloadKbps: 2000,
      pingMs: 100,
      measurementDate: '01.01.1970',
      userExperienceMetrics: [
        MeasurementQuality(category: 'EMAIL_MESSAGING', quality: 'EXCELLENT'),
        MeasurementQuality(category: 'ONLINE_GAMING', quality: 'MODERATE'),
        MeasurementQuality(category: 'SOCIAL_MEDIA', quality: 'GOOD'),
      ],
    ),
  );
  _cubit = setUpMeasurementResultCubit(state);
  await tester.pumpWidget(
    BlocProvider<MeasurementResultCubit>(
      create: (cntx) => _cubit,
      child: MaterialApp(
        home: const ResultsQoeView(),
      ),
    ),
  );
  return state;
}
