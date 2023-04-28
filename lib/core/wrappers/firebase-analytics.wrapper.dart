import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsWrapper {
  late FirebaseAnalytics _analytics;

  init() {
    _analytics = FirebaseAnalytics.instance;
  }

  setAnalyticsEnabled(bool enabled) => _analytics.setAnalyticsCollectionEnabled(enabled);
}