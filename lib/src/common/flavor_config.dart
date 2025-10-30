enum Flavor { dev, staging, prod }

class FlavourConfig {
  final Flavor flavor;
  final String baseUrl;
  final String name;
  static FlavourConfig? _instance;

  FlavourConfig._({
    required this.baseUrl,
    required this.flavor,
    required this.name,
  });

  factory FlavourConfig({
    required Flavor flavor,
    required String baseUrl,
    required name,
  }) {
    _instance ??= FlavourConfig._(flavor: flavor, baseUrl: baseUrl, name: name);
    return _instance!;
  }

  static FlavourConfig get instance {
    if (_instance == null) {
      throw Exception('Not initalized');
    }
    return _instance!;
  }

  static bool isDev() => instance.flavor == Flavor.dev;

  static bool isProd() => instance.flavor == Flavor.prod;

  static bool isStaging() => instance.flavor == Flavor.staging;
}
