import 'package:injectable/injectable.dart';

import 'analytics_service.dart';
import 'firebase_analytics_service.dart';

@LazySingleton(as: AnalyticsService)
final class CompositeAnalyticsService implements AnalyticsService {
  CompositeAnalyticsService(this._firebase);

  final FirebaseAnalyticsService _firebase;

  List<AnalyticsService> get _services => [_firebase];

  @override
  Future<void> initialize() =>
      Future.wait(_services.map((s) => s.initialize()));

  @override
  Future<void> logEvent(String name, Map<String, dynamic> params) =>
      Future.wait(_services.map((s) => s.logEvent(name, params)));

  @override
  Future<void> setUserProperty(String key, String value) =>
      Future.wait(_services.map((s) => s.setUserProperty(key, value)));

  @override
  Future<void> logScreen(String name) =>
      Future.wait(_services.map((s) => s.logScreen(name)));
}
