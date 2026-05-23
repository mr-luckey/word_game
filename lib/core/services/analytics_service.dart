// Firebase Analytics disabled for now. Re-enable firebase_analytics in pubspec
// and restore Firebase-backed implementation when ready for production.

class AnalyticsService {
  AnalyticsService();

  bool _enabled = true;

  void setEnabled(bool enabled) => _enabled = enabled;

  Future<void> logLevelStart(int levelId) async {
    if (!_enabled) return;
  }

  Future<void> logLevelComplete({
    required int levelId,
    required int stars,
  }) async {
    if (!_enabled) return;
  }

  Future<void> logPurchase(String productId) async {
    if (!_enabled) return;
  }
}
