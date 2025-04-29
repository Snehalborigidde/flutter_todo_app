// to define different flavors:
enum Flavor {
  development,
  staging,
  production,
  test,
}

// class FlavorConfig {
//   final Flavor flavor;
//   final String name;
//   final String apiBaseUrl;
//
//   static FlavorConfig? _instance;
//
//   factory FlavorConfig({required Flavor flavor, required String name, required String apiBaseUrl}) {
//     _instance ??= FlavorConfig._internal(flavor, name, apiBaseUrl);
//     return _instance!;
//   }
//
//   FlavorConfig._internal(this.flavor, this.name, this.apiBaseUrl);
//
//   static FlavorConfig get instance => _instance!;
//
// }

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String apiBaseUrl;

  static FlavorConfig? _instance;

  // Private constructor
  FlavorConfig._internal(this.flavor, this.name, this.apiBaseUrl);

  // Factory constructor to provide the singleton instance
  factory FlavorConfig({required Flavor flavor, required String name, required String apiBaseUrl}) {
    _instance ??= FlavorConfig._internal(flavor, name, apiBaseUrl);
    return _instance!;
  }

  // Static getter for accessing the instance
  static FlavorConfig get instance {
    if (_instance == null) {
      throw StateError('FlavorConfig is not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  // New initialize method
  static void initialize({
    required Flavor flavor,
    required String name,
    required String apiBaseUrl,
  }) {
    if (_instance != null) {
      throw StateError('FlavorConfig is already initialized.');
    }
    _instance = FlavorConfig._internal(flavor, name, apiBaseUrl);
  }
}

