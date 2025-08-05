class ApiConstants {
  // StormGlass API
  static const String stormGlassBaseUrl = 'https://api.stormglass.io/v2';
  static const String stormGlassApiKey = 'YOUR_STORMGLASS_API_KEY'; // TODO: Add real API key

  // Tomorrow.io API
  static const String tomorrowBaseUrl = 'https://api.tomorrow.io/v4';
  static const String tomorrowApiKey = 'YOUR_TOMORROW_API_KEY'; // TODO: Add real API key

  // Open-Meteo API (fallback)
  static const String openMeteoBaseUrl = 'https://api.open-meteo.com/v1';

  // Weather endpoints
  static const String weatherEndpoint = '/weather';
  static const String forecastEndpoint = '/forecast';

  // Cache settings
  static const int cacheExpirationMinutes = 60;
  static const int maxCacheSize = 1000; // Maximum cached weather points

  // Wind data parameters
  static const List<String> windParameters = ['windSpeed', 'windDirection', 'windGust'];

  // Units
  static const String windSpeedUnit = 'm/s';
  static const String windDirectionUnit = 'degrees';
}
