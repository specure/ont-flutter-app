import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/app-review.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/date-time.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/in-app-review.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/app.review.service.dart';

import '../../di/service-locator.dart';

int milliseconds = 1654096923668;
int secondAppReviewDelayMillis =
    AppReview.IN_APP_REVIEW_SECOND_DISPLAY_DELAY_MILLIS;
int thirdAppReviewDelayMillis =
    AppReview.IN_APP_REVIEW_THIRD_DISPLAY_DELAY_MILLIS;

final List<Map<String, dynamic>> _projects = [
  {
    'mapbox_actual_date': '2022-02-03',
    'enable_app_results_sharing': false,
    'enable_app_results_synchronization': false,
    'enable_app_loop_mode': false,
    'enable_app_in_app_review': true
  },
  {
    'mapbox_actual_date': '2022-02-03',
    'enable_app_results_sharing': false,
    'enable_app_results_synchronization': false,
    'enable_app_loop_mode': false,
    'enable_app_in_app_review': false
  }
];

late SharedPreferencesWrapper _prefs;

@GenerateMocks([
  InAppReviewWrapper,
  DateTimeWrapper,
], customMocks: [])
void main() async {
  group('In app review', () {
    _setUpStubs();
    test('test review start allowed by CMS', () async {
      await _testStartReviewAllowedCMS();
    });
    test('test review start not allowed by CMS', () async {
      await _testStartReviewNotAllowedCMS();
    });
    test('test review start not allowed by CMS but not available', () async {
      await _testStartReviewAllowedCmsButNotAvailable();
    });
    test('test review start 2nd try with no delay', () async {
      await _testStartReviewSecondTryNotEnoughDelay();
    });
    test('test review start 2nd try with correct delay', () async {
      await _testStartReviewSecondTryCorrectDelay();
    });
    test('test review start 3rd try with no delay', () async {
      await _testStartReviewThirdTryNotEnoughDelay();
    });
    test('test review start 3rd try with correct delay', () async {
      await _testStartReviewThirdTryCorrectDelay();
    });
    test('test review start 4th - unsuccessful', () async {
      await _testStartReviewFourthTry();
    });

    test('test review start not allowed by CMS', () async {
      await _testStartReviewOutOfTries();
    });
  });
}

Future _testStartReviewFourthTry() async {
  _setUpEnabledReviewStubs();
  when(_prefs.getInt(StorageKeys.inAppReviewShownCount)).thenAnswer((_) => 3);
  expect(await AppReviewService().startAppReview(), false);
}

Future _testStartReviewThirdTryCorrectDelay() async {
  _setUpEnabledReviewStubs();
  when(_prefs.getInt(StorageKeys.inAppReviewShownCount)).thenAnswer((_) => 2);
  when(_prefs.setInt(StorageKeys.inAppReviewShownCount, 3))
      .thenAnswer((_) async => true);
  when(_prefs.getInt(StorageKeys.inAppReviewLastShownTimestampMillis))
      .thenAnswer((_) => milliseconds - thirdAppReviewDelayMillis - 1);
  expect(await AppReviewService().startAppReview(), true);
}

Future _testStartReviewThirdTryNotEnoughDelay() async {
  _setUpEnabledReviewStubs();
  when(_prefs.getInt(StorageKeys.inAppReviewShownCount)).thenAnswer((_) => 2);
  when(_prefs.getInt(StorageKeys.inAppReviewLastShownTimestampMillis))
      .thenAnswer((_) => milliseconds - thirdAppReviewDelayMillis);
  expect(await AppReviewService().startAppReview(), false);
}

Future _testStartReviewSecondTryCorrectDelay() async {
  _setUpEnabledReviewStubs();
  when(_prefs.getInt(StorageKeys.inAppReviewShownCount)).thenAnswer((_) => 1);
  when(_prefs.setInt(StorageKeys.inAppReviewShownCount, 2))
      .thenAnswer((_) async => true);
  when(_prefs.getInt(StorageKeys.inAppReviewLastShownTimestampMillis))
      .thenAnswer((_) => milliseconds - secondAppReviewDelayMillis - 1);
  expect(await AppReviewService().startAppReview(), true);
}

Future _testStartReviewSecondTryNotEnoughDelay() async {
  _setUpEnabledReviewStubs();
  when(_prefs.getInt(StorageKeys.inAppReviewShownCount)).thenAnswer((_) => 1);
  when(_prefs.getInt(StorageKeys.inAppReviewLastShownTimestampMillis))
      .thenAnswer((_) => milliseconds - secondAppReviewDelayMillis);
  expect(await AppReviewService().startAppReview(), false);
}

Future _testStartReviewAllowedCmsButNotAvailable() async {
  _setUpEnabledReviewStubs();
  when(_prefs.getInt(StorageKeys.inAppReviewLastShownTimestampMillis))
      .thenAnswer((_) => null);
  when(_prefs.getInt(StorageKeys.inAppReviewShownCount)).thenAnswer((_) => 0);
  when(GetIt.I.get<InAppReviewWrapper>().isAvailable)
      .thenAnswer((_) async => false);
  expect(await AppReviewService().startAppReview(), false);
}

Future _testStartReviewAllowedCMS() async {
  _setUpEnabledReviewStubs();
  when(_prefs.setInt(StorageKeys.inAppReviewShownCount, 1))
      .thenAnswer((_) async => true);
  when(_prefs.getInt(StorageKeys.inAppReviewLastShownTimestampMillis))
      .thenAnswer((_) => null);
  when(_prefs.getInt(StorageKeys.inAppReviewShownCount)).thenAnswer((_) => 0);
  expect(await AppReviewService().startAppReview(), true);
}

Future _testStartReviewNotAllowedCMS() async {
  when(GetIt.I.get<CMSService>().project)
      .thenReturn(NTProject.fromJson(_projects[1]));
  when(GetIt.I.get<DateTimeWrapper>().nowInMillis())
      .thenAnswer((_) => milliseconds);
  when(GetIt.I.get<InAppReviewWrapper>().isAvailable)
      .thenAnswer((_) async => true);
  when(_prefs.getInt(StorageKeys.inAppReviewShownCount)).thenAnswer((_) => 0);
  when(GetIt.I.get<InAppReviewWrapper>().requestReview())
      .thenAnswer((_) async => true);
  expect(await AppReviewService().startAppReview(), false);
}

Future _testStartReviewOutOfTries() async {
  when(_prefs.getInt(StorageKeys.inAppReviewShownCount)).thenAnswer((_) => 3);
}

_setUpStubs() {
  TestingServiceLocator.registerInstances();
  _prefs = GetIt.I.get<SharedPreferencesWrapper>();
  when(_prefs.setInt(StorageKeys.inAppReviewShownCount, 0))
      .thenAnswer((_) async => true);
  when(_prefs.setInt(
          StorageKeys.inAppReviewLastShownTimestampMillis, milliseconds))
      .thenAnswer((_) async => true);
}

void _setUpEnabledReviewStubs() {
  when(GetIt.I.get<CMSService>().project)
      .thenReturn(NTProject.fromJson(_projects[0]));
  when(GetIt.I.get<DateTimeWrapper>().nowInMillis())
      .thenAnswer((_) => milliseconds);
  when(GetIt.I.get<InAppReviewWrapper>().isAvailable)
      .thenAnswer((_) async => true);
  when(GetIt.I.get<InAppReviewWrapper>().requestReview())
      .thenAnswer((_) async => true);
}
