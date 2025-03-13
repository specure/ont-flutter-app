import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/app-review.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/date-time.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';

import '../../../core/wrappers/in-app-review.wrapper.dart';

class AppReviewService {
  final SharedPreferencesWrapper _preferences =
      GetIt.I.get<SharedPreferencesWrapper>();
  final CMSService _cmsService = GetIt.I.get<CMSService>();
  final _inAppReview = GetIt.I.get<InAppReviewWrapper>();
  final _dateTimeWrapper = GetIt.I.get<DateTimeWrapper>();

  /// Checks if feature flag for in app review is enabled and if review is possible
  /// (supported by OS and if we did not exceed number of tries, passed delay time)
  /// and shows the review if possible
  Future<bool> startAppReview() async {
    final isAppReviewAvailable = await _inAppReview.isAvailable;
    final isAppReviewEnabled =
        _cmsService.project?.enableAppInAppReview ?? false;
    if (isAppReviewEnabled && isAppReviewAvailable) {
      final reviewShownCount = _getInAppReviewShownCount();
      if (reviewShownCount < AppReview.IN_APP_REVIEW_MAX_COUNT) {
        switch (reviewShownCount) {
          case 0:
            {
              _showInAppReview();
              return true;
            }
          case 1:
            {
              return _shouldDisplayAskForReviewAttemptAfterMillis(
                  AppReview.IN_APP_REVIEW_SECOND_DISPLAY_DELAY_MILLIS);
            }
          case 2:
            {
              return _shouldDisplayAskForReviewAttemptAfterMillis(
                  AppReview.IN_APP_REVIEW_THIRD_DISPLAY_DELAY_MILLIS);
            }
        }
      }
    }
    return false;
  }

  Future _showInAppReview() async {
    Future.delayed(
        Duration(milliseconds: AppReview.IN_APP_REVIEW_DELAY_TO_DISPLAY_MILLIS),
        () async {
      _inAppReview.requestReview();
      var currentCount = _preferences.getInt(StorageKeys.inAppReviewShownCount);
      currentCount = currentCount != null ? currentCount + 1 : 1;
      await _preferences.setInt(
          StorageKeys.inAppReviewShownCount, currentCount);
      await _preferences.setInt(StorageKeys.inAppReviewLastShownTimestampMillis,
          _dateTimeWrapper.nowInMillis());
    });
  }

  bool _shouldDisplayAskForReviewAttemptAfterMillis(int millisDelay) {
    final nowMillis = _dateTimeWrapper.nowInMillis();
    final lastReviewShownTimestampMillis =
        _preferences.getInt(StorageKeys.inAppReviewLastShownTimestampMillis) ??
            0;
    if (nowMillis - lastReviewShownTimestampMillis > millisDelay) {
      _inAppReview.requestReview();
      _showInAppReview();
      return true;
    } else {
      return false;
    }
  }

  int _getInAppReviewShownCount() {
    var currentCount = _preferences.getInt(StorageKeys.inAppReviewShownCount);
    if (currentCount == null) {
      currentCount = 0;
    }
    return currentCount;
  }
}
