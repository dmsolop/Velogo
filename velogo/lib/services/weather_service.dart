import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

enum WeatherProvider { stormGlass, tomorrow, openMeteo }

class WeatherService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// Отримує погодні дані з пріоритетним провайдером
  Future<Map<String, dynamic>> getWeather(double lat, double lon, {WeatherProvider provider = WeatherProvider.stormGlass}) async {
    try {
      switch (provider) {
        case WeatherProvider.stormGlass:
          return await _getStormGlassWeather(lat, lon);
        case WeatherProvider.tomorrow:
          return await _getTomorrowWeather(lat, lon);
        case WeatherProvider.openMeteo:
          return await _getOpenMeteoWeather(lat, lon);
      }
    } on DioException catch (e) {
      print("❌ Error fetching weather from $provider: ${e.message}");

      // Fallback to Open-Meteo if primary provider fails
      if (provider != WeatherProvider.openMeteo) {
        print("🔄 Falling back to Open-Meteo...");
        return await getWeather(lat, lon, provider: WeatherProvider.openMeteo);
      }

      throw Exception("Failed to load weather data from all providers");
    }
  }

  /// StormGlass API
  Future<Map<String, dynamic>> _getStormGlassWeather(double lat, double lon) async {
    final response = await _dio.get(
      '${ApiConstants.stormGlassBaseUrl}/weather/point',
      queryParameters: {
        'lat': lat,
        'lng': lon,
        'params': ApiConstants.windParameters.join(','),
        'source': 'sg',
        'key': ApiConstants.stormGlassApiKey,
      },
    );

    return _parseStormGlassResponse(response.data);
  }

  /// Tomorrow.io API
  Future<Map<String, dynamic>> _getTomorrowWeather(double lat, double lon) async {
    final response = await _dio.get(
      '${ApiConstants.tomorrowBaseUrl}/timelines',
      queryParameters: {
        'location': '$lat,$lon',
        'fields': ApiConstants.windParameters.join(','),
        'apikey': ApiConstants.tomorrowApiKey,
      },
    );

    return _parseTomorrowResponse(response.data);
  }

  /// Open-Meteo API (fallback)
  Future<Map<String, dynamic>> _getOpenMeteoWeather(double lat, double lon) async {
    final response = await _dio.get(
      '${ApiConstants.openMeteoBaseUrl}/forecast',
      queryParameters: {
        'latitude': lat,
        'longitude': lon,
        'hourly': ApiConstants.windParameters.join(','),
        'timezone': 'auto',
      },
    );

    return _parseOpenMeteoResponse(response.data);
  }

  /// Парсинг відповіді StormGlass
  Map<String, dynamic> _parseStormGlassResponse(Map<String, dynamic> data) {
    final hourly = data['hours']?[0] ?? {};
    return {
      'hourly': {
        'wind_speed': [hourly['windSpeed']?['sg'] ?? 0.0],
        'wind_direction': [hourly['windDirection']?['sg'] ?? 0.0],
        'wind_gust': [hourly['windGust']?['sg'] ?? 0.0],
      }
    };
  }

  /// Парсинг відповіді Tomorrow.io
  Map<String, dynamic> _parseTomorrowResponse(Map<String, dynamic> data) {
    final intervals = data['data']?['timelines']?[0]?['intervals']?[0] ?? {};
    final values = intervals['values'] ?? {};
    return {
      'hourly': {
        'wind_speed': [values['windSpeed'] ?? 0.0],
        'wind_direction': [values['windDirection'] ?? 0.0],
        'wind_gust': [values['windGust'] ?? 0.0],
      }
    };
  }

  /// Парсинг відповіді Open-Meteo
  Map<String, dynamic> _parseOpenMeteoResponse(Map<String, dynamic> data) {
    final hourly = data['hourly'] ?? {};
    return {
      'hourly': {
        'wind_speed': [hourly['windspeed_10m']?[0] ?? 0.0],
        'wind_direction': [hourly['winddirection_10m']?[0] ?? 0.0],
        'wind_gust': [hourly['windgusts_10m']?[0] ?? 0.0],
      }
    };
  }
}
