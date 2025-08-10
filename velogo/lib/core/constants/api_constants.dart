import '../../services/remote_config_service.dart';

class ApiConstants {
  static final RemoteConfigService _remoteConfig = RemoteConfigService();

  // StormGlass API
  static String get stormGlassBaseUrl => _remoteConfig.stormglassBaseUrl;
  static String get stormGlassApiKey => _remoteConfig.stormglassApiKey;

  // Tomorrow.io API
  static String get tomorrowBaseUrl => _remoteConfig.tomorrowBaseUrl;
  static String get tomorrowApiKey => _remoteConfig.tomorrowApiKey;

  // Open-Meteo API (fallback)
  static String get openMeteoBaseUrl => _remoteConfig.openMeteoBaseUrl;

  // Weather endpoints
  static String get weatherEndpoint => _remoteConfig.weatherEndpoint;
  static String get forecastEndpoint => _remoteConfig.forecastEndpoint;

  // Cache settings
  static int get cacheExpirationMinutes => _remoteConfig.cacheExpirationMinutes;
  static int get maxCacheSize => _remoteConfig.maxCacheSize;

  // Wind data parameters
  static List<String> get windParameters => _remoteConfig.windParameters;

  // Units
  static String get windSpeedUnit => _remoteConfig.windSpeedUnit;
  static String get windDirectionUnit => _remoteConfig.windDirectionUnit;

  // Additional settings
  static int get syncIntervalMinutes => _remoteConfig.syncIntervalMinutes;
  static bool get enableWeatherLogging => _remoteConfig.enableWeatherLogging;
  static String get primaryWeatherProvider => _remoteConfig.primaryWeatherProvider;

  /// Ініціалізація Remote Config (викликається в main.dart)
  static Future<void> initialize() async {
    await _remoteConfig.initialize();
  }

  /// Отримання всіх параметрів для дебагу
  static Map<String, dynamic> getAllParameters() {
    return _remoteConfig.getAllParameters();
  }
}
