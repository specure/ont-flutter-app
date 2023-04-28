import 'package:in_app_review/in_app_review.dart';

class InAppReviewWrapper {
  late InAppReview _inAppReview;

  init() {
    _inAppReview = InAppReview.instance;
  }

  Future<bool> get isAvailable async => await _inAppReview.isAvailable();

  Future<bool> requestReview() async {
    await _inAppReview.requestReview();
    return true;
  }
}
