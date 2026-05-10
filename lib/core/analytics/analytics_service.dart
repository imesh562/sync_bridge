abstract interface class AnalyticsService {
  Future<void> initialize();
  Future<void> logEvent(String name, Map<String, dynamic> params);
  Future<void> setUserProperty(String key, String value);
  Future<void> logScreen(String name);
}
