final class FlavorConfig {
  FlavorConfig({
    required this.baseUrl,
    required this.wsUrl,
    this.mixpanelToken,
  });

  static late FlavorConfig instance;

  final String baseUrl;
  final String wsUrl;
  final String? mixpanelToken;
}
