import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/constants/measurement-quality-category.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/constants/measurement-quality-estimate.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/qoe-estimate.widget.dart';

import '../../di/service-locator.dart';

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init()).thenAnswer((_) async => null);
    when(GetIt.I.get<SharedPreferencesWrapper>().getString(StorageKeys.selectedLocaleTag)).thenReturn(_selectedLocaleTag);
  });

  group('Test QoE Estimate Widget', () {
    testWidgets('Test Moderate Quality', (tester) async {
      await _testWidget(tester, MeasurementQualityEstimate.moderate);
    });
    testWidgets('Test Excellent Quality', (tester) async {
      await _testWidget(tester, MeasurementQualityEstimate.excellent);
    });
  });
}

Future _testWidget(WidgetTester tester, String quality) async {
  final widget = QoeEstimate(
    category: MeasurementQualityCategory.socialMedia,
    quality: quality,
  );
  await tester.pumpWidget(MaterialApp(home: widget));
  final estimateIconFinder = find.byIcon(Icons.contacts);
  final estimateTitleFinder =
      find.text(QoeEstimate.categoryTitle[widget.category]!);
  final badgeTitleFinder =
      find.text(QualityBadge.qualityTitle[widget.quality]!);
  final badgeIconFinder = find.byIcon(Icons.check_circle);
  expect(estimateIconFinder, findsOneWidget);
  expect(estimateTitleFinder, findsOneWidget);
  expect(badgeTitleFinder, findsOneWidget);
  expect(
    badgeIconFinder,
    quality == MeasurementQualityEstimate.excellent ||
            quality == MeasurementQualityEstimate.good
        ? findsOneWidget
        : findsNothing,
  );
}
