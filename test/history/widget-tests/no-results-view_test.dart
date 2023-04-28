import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/no-results.view.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/start-test/start-test.widget.dart';

import '../../di/service-locator.dart';

final NoResultsView view = NoResultsView(
  title: 'No results to show.',
  linkText: 'Make your first measurement',
  onTap: () => GetIt.I.get<CoreCubit>().goToScreen<StartTestWidget>(),
);

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUpAll(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
  });

  group('No results view', () {
    testWidgets('shows correct image and text', (tester) async {
      await tester.pumpWidget(MaterialApp(home: view));
      final picFinder = find.byType(SvgPicture);
      expect(picFinder, findsOneWidget);
      final picProvider = (picFinder.evaluate().single.widget as SvgPicture)
          .pictureProvider as ExactAssetPicture;
      expect(picProvider.assetName, 'config/.nt/images/empty_image.svg');
      expect(find.text('No results to show.'), findsOneWidget);
    });

    testWidgets('allows navigation to the home screen', (tester) async {
      await tester.pumpWidget(MaterialApp(home: view));
      final gdFinder = find.byType(GestureDetector);
      expect(gdFinder, findsOneWidget);
      final gd = gdFinder.evaluate().single.widget as GestureDetector;
      expect((gd.child as Text).data, 'Make your first measurement');
      expect(gd.onTap, isNotNull);
      when(GetIt.I.get<CoreCubit>().goToScreen<StartTestWidget>())
          .thenReturn(null);
      gd.onTap!();
      verify(GetIt.I.get<CoreCubit>().goToScreen<StartTestWidget>());
    });
  });
}
