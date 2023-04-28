class AppReview {
  static const int IN_APP_REVIEW_MAX_COUNT = 3;
  static const int IN_APP_REVIEW_SECOND_DISPLAY_DELAY_MILLIS = 30 * 24 * 60 * 60 * 1000; // 30 days ~ 1 month
  static const int IN_APP_REVIEW_THIRD_DISPLAY_DELAY_MILLIS = 3 * IN_APP_REVIEW_SECOND_DISPLAY_DELAY_MILLIS; // 90 days ~ 3 months
  static const int IN_APP_REVIEW_DELAY_TO_DISPLAY_MILLIS = 3 * 1000;
  AppReview._();
}