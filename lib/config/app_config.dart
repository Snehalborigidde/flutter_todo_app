// lib/config/app_config.dart
import 'flavor.dart';

class AppConfig {
  static String get apiBaseUrl => FlavorConfig.instance.apiBaseUrl;
  static String get flavorName => FlavorConfig.instance.name;
}
