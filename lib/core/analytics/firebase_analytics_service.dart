import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

import 'analytics_service.dart';

@lazySingleton
final class FirebaseAnalyticsService implements AnalyticsService {
  final _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> logEvent(String name, Map<String, dynamic> params) => _analytics
      .logEvent(name: name, parameters: params.cast<String, Object>());

  @override
  Future<void> setUserProperty(String key, String value) =>
      _analytics.setUserProperty(name: key, value: value);

  @override
  Future<void> logScreen(String name) =>
      _analytics.logScreenView(screenName: name);
}
