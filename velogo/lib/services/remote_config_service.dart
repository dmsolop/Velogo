import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:convert';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Ключі параметрів
  static const String _stormglassApiKey = 'stormglass_api_key';
  static const String _tomorrowApiKey = 'tomorrow_api_key';
  static const String _stormglassBaseUrl = 'stormglass_base_url';
  static const String _tomorrowBaseUrl = 'tomorrow_base_url';
  static const String _openMeteoBaseUrl = 'open_meteo_base_url';
  static const String _cacheExpirationMinutes = 'cache_expiration_minutes';
  static const String _maxCacheSize = 'max_cache_size';
  static const String _windParameters = 'wind_parameters';
  static const String _windSpeedUnit = 'wind_speed_unit';
  static const String _windDirectionUnit = 'wind_direction_unit';
  static const String _weatherEndpoint = 'weather_endpoint';
  static const String _forecastEndpoint = 'forecast_endpoint';
  static const String _syncIntervalMinutes = 'sync_interval_minutes';
  static const String _enableWeatherLogging = 'enable_weather_logging';
  static const String _primaryWeatherProvider = 'primary_weather_provider';

  // Значення за замовчуванням (fallback)
  static const Map<String, dynamic> _defaults = {
    'stormglass_api_key': '0071dc8e-7200-11f0-b2b2-0242ac130006-0071dd38-7200-11f0-b2b2-0242ac130006',
    'tomorrow_api_key': 'WMYu7OiXcenM6ToxOMwNAAqWLAec4FVR',
    'stormglass_base_url': 'https://api.stormglass.io/v2',
    'tomorrow_base_url': 'https://api.tomorrow.io/v4',
    'open_meteo_base_url': 'https://api.open-meteo.com/v1',
    'cache_expiration_minutes': '60',
    'max_cache_size': '1000',
    'wind_parameters': '["windSpeed", "windDirection", "windGust"]',
    'wind_speed_unit': 'm/s',
    'wind_direction_unit': 'degrees',
    'weather_endpoint': '/weather',
    'forecast_endpoint': '/forecast',
    'sync_interval_minutes': '30',
    'enable_weather_logging': 'true',
    'primary_weather_provider': 'stormglass',
  };

  /// Ініціалізація Remote Config
  Future<void> initialize() async {
    try {
      // Встановлюємо значення за замовчуванням
      await _remoteConfig.setDefaults(_defaults);

      // Налаштування для розробки
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      // Отримуємо конфігурацію
      await _remoteConfig.fetchAndActivate();

      print('✅ Remote Config ініціалізовано успішно');
      _logCurrentConfig();
    } catch (e) {
      print('❌ Помилка ініціалізації Remote Config: $e');
    }
  }

  /// Отримання API ключа StormGlass
  String get stormglassApiKey => _remoteConfig.getString(_stormglassApiKey);

  /// Отримання API ключа Tomorrow.io
  String get tomorrowApiKey => _remoteConfig.getString(_tomorrowApiKey);

  /// Отримання базового URL StormGlass
  String get stormglassBaseUrl => _remoteConfig.getString(_stormglassBaseUrl);

  /// Отримання базового URL Tomorrow.io
  String get tomorrowBaseUrl => _remoteConfig.getString(_tomorrowBaseUrl);

  /// Отримання базового URL Open-Meteo
  String get openMeteoBaseUrl => _remoteConfig.getString(_openMeteoBaseUrl);

  /// Отримання часу життя кешу в хвилинах
  int get cacheExpirationMinutes => int.tryParse(_remoteConfig.getString(_cacheExpirationMinutes)) ?? 60;

  /// Отримання максимального розміру кешу
  int get maxCacheSize => int.tryParse(_remoteConfig.getString(_maxCacheSize)) ?? 1000;

  /// Отримання списку параметрів вітру
  List<String> get windParameters {
    try {
      final jsonString = _remoteConfig.getString(_windParameters);
      final List<dynamic> list = jsonDecode(jsonString);
      return list.cast<String>();
    } catch (e) {
      print('❌ Помилка парсингу wind_parameters: $e');
      return ['windSpeed', 'windDirection', 'windGust'];
    }
  }

  /// Отримання одиниці виміру швидкості вітру
  String get windSpeedUnit => _remoteConfig.getString(_windSpeedUnit);

  /// Отримання одиниці виміру напряму вітру
  String get windDirectionUnit => _remoteConfig.getString(_windDirectionUnit);

  /// Отримання endpoint для погоди
  String get weatherEndpoint => _remoteConfig.getString(_weatherEndpoint);

  /// Отримання endpoint для прогнозу
  String get forecastEndpoint => _remoteConfig.getString(_forecastEndpoint);

  /// Отримання інтервалу синхронізації в хвилинах
  int get syncIntervalMinutes => int.tryParse(_remoteConfig.getString(_syncIntervalMinutes)) ?? 30;

  /// Отримання налаштування логування погоди
  bool get enableWeatherLogging => _remoteConfig.getBool(_enableWeatherLogging);

  /// Отримання основного провайдера погоди
  String get primaryWeatherProvider => _remoteConfig.getString(_primaryWeatherProvider);

  /// Примусове оновлення конфігурації
  Future<bool> fetchAndActivate() async {
    try {
      final success = await _remoteConfig.fetchAndActivate();
      if (success) {
        print('✅ Remote Config оновлено успішно');
        _logCurrentConfig();
      } else {
        print('⚠️ Remote Config оновлення не вдалося');
      }
      return success;
    } catch (e) {
      print('❌ Помилка оновлення Remote Config: $e');
      return false;
    }
  }

  /// Логування поточної конфігурації
  void _logCurrentConfig() {
    print('📋 Поточна конфігурація Remote Config:');
    print('  StormGlass API Key: ${stormglassApiKey.substring(0, 10)}...');
    print('  Tomorrow API Key: ${tomorrowApiKey.substring(0, 10)}...');
    print('  Cache Expiration: ${cacheExpirationMinutes} min');
    print('  Max Cache Size: $maxCacheSize');
    print('  Primary Provider: $primaryWeatherProvider');
    print('  Weather Logging: $enableWeatherLogging');
  }

  /// Отримання всіх параметрів як Map
  Map<String, dynamic> getAllParameters() {
    return {
      'stormglass_api_key': stormglassApiKey,
      'tomorrow_api_key': tomorrowApiKey,
      'stormglass_base_url': stormglassBaseUrl,
      'tomorrow_base_url': tomorrowBaseUrl,
      'open_meteo_base_url': openMeteoBaseUrl,
      'cache_expiration_minutes': cacheExpirationMinutes,
      'max_cache_size': maxCacheSize,
      'wind_parameters': windParameters,
      'wind_speed_unit': windSpeedUnit,
      'wind_direction_unit': windDirectionUnit,
      'weather_endpoint': weatherEndpoint,
      'forecast_endpoint': forecastEndpoint,
      'sync_interval_minutes': syncIntervalMinutes,
      'enable_weather_logging': enableWeatherLogging,
      'primary_weather_provider': primaryWeatherProvider,
    };
  }
}
