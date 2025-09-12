import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/log_service.dart';

enum WeatherProvider { stormGlass, tomorrow, openMeteo }

class WeatherService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// Отримує погодні дані з пріоритетним провайдером
  Future<Map<String, dynamic>> getWeather(double lat, double lon, {WeatherProvider provider = WeatherProvider.stormGlass}) async {
    try {
      await LogService.log('🌤️ [WeatherService] Запит погоди: lat=$lat, lon=$lon, provider=$provider');

      switch (provider) {
        case WeatherProvider.stormGlass:
          await LogService.log('🌤️ [WeatherService] Використовуємо StormGlass API');
          return await _getStormGlassWeather(lat, lon);
        case WeatherProvider.tomorrow:
          await LogService.log('🌤️ [WeatherService] Використовуємо Tomorrow.io API');
          return await _getTomorrowWeather(lat, lon);
        case WeatherProvider.openMeteo:
          await LogService.log('🌤️ [WeatherService] Використовуємо Open-Meteo API');
          return await _getOpenMeteoWeather(lat, lon);
      }
    } on DioException catch (e) {
      await LogService.log('❌ [WeatherService] Помилка запиту до $provider: ${e.message}');
      print("❌ Error fetching weather from $provider: ${e.message}");

      // Fallback to Open-Meteo if primary provider fails
      if (provider != WeatherProvider.openMeteo) {
        await LogService.log('🔄 [WeatherService] Переходимо до fallback Open-Meteo');
        print("🔄 Falling back to Open-Meteo...");
        return await getWeather(lat, lon, provider: WeatherProvider.openMeteo);
      }

      await LogService.log('❌ [WeatherService] Всі провайдери недоступні');
      throw Exception("Failed to load weather data from all providers");
    }
  }

  /// StormGlass API
  Future<Map<String, dynamic>> _getStormGlassWeather(double lat, double lon) async {
    try {
      await LogService.log('🌤️ [WeatherService] StormGlass запит: ${ApiConstants.stormGlassBaseUrl}/weather/point');

      // Виправлені параметри для StormGlass API v2
      final response = await _dio.get(
        '${ApiConstants.stormGlassBaseUrl}/weather/point',
        queryParameters: {
          'lat': lat,
          'lng': lon,
          'params': 'windSpeed,windDirection,gust,precipitation,humidity,airTemperature,visibility',
          'source': 'sg',
          'start': DateTime.now().toIso8601String(),
          'end': DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
        },
        options: Options(
          headers: {
            'Authorization': ApiConstants.stormGlassApiKey,
            'Content-Type': 'application/json',
          },
        ),
      );
      await LogService.log('✅ [WeatherService] StormGlass відповідь отримана');
      return _parseStormGlassResponse(response.data);
    } catch (e) {
      await LogService.log('❌ [WeatherService] StormGlass помилка: $e');
      if (e is DioException) {
        await LogService.log('❌ [WeatherService] StormGlass статус: ${e.response?.statusCode}');
        await LogService.log('❌ [WeatherService] StormGlass відповідь: ${e.response?.data}');
      }
      rethrow;
    }
  }

  /// Tomorrow.io API
  Future<Map<String, dynamic>> _getTomorrowWeather(double lat, double lon) async {
    try {
      await LogService.log('🌤️ [WeatherService] Tomorrow.io запит: ${ApiConstants.tomorrowBaseUrl}/timelines');
      final response = await _dio.get(
        '${ApiConstants.tomorrowBaseUrl}/timelines',
        queryParameters: {
          'location': '$lat,$lon',
          'fields': ApiConstants.windParameters.join(','),
          'apikey': ApiConstants.tomorrowApiKey,
        },
      );
      await LogService.log('✅ [WeatherService] Tomorrow.io відповідь отримана');
      return _parseTomorrowResponse(response.data);
    } catch (e) {
      await LogService.log('❌ [WeatherService] Tomorrow.io помилка: $e');
      rethrow;
    }
  }

  /// Open-Meteo API (fallback)
  Future<Map<String, dynamic>> _getOpenMeteoWeather(double lat, double lon) async {
    try {
      await LogService.log('🌤️ [WeatherService] Open-Meteo запит: ${ApiConstants.openMeteoBaseUrl}/forecast');

      // Виправлені параметри для Open-Meteo API
      final response = await _dio.get(
        '${ApiConstants.openMeteoBaseUrl}/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'hourly': 'wind_speed_10m,wind_direction_10m,wind_gusts_10m,precipitation,precipitation_type,relative_humidity_2m,temperature_2m,visibility',
          'timezone': 'auto',
          'forecast_days': 1,
        },
      );
      await LogService.log('✅ [WeatherService] Open-Meteo відповідь отримана');
      return _parseOpenMeteoResponse(response.data);
    } catch (e) {
      await LogService.log('❌ [WeatherService] Open-Meteo помилка: $e');
      if (e is DioException) {
        await LogService.log('❌ [WeatherService] Open-Meteo статус: ${e.response?.statusCode}');
        await LogService.log('❌ [WeatherService] Open-Meteo відповідь: ${e.response?.data}');
      }
      rethrow;
    }
  }

  /// Парсинг відповіді StormGlass
  Map<String, dynamic> _parseStormGlassResponse(Map<String, dynamic> data) {
    final hourly = data['hours']?[0] ?? {};
    return {
      'hourly': {
        'wind_speed': [hourly['windSpeed']?['sg'] ?? 0.0],
        'wind_direction': [hourly['windDirection']?['sg'] ?? 0.0],
        'wind_gust': [hourly['gust']?['sg'] ?? 0.0],
        'precipitation': [hourly['precipitation']?['sg'] ?? 0.0],
        'precipitation_type': [0.0], // StormGlass не підтримує precipitationType
        'humidity': [hourly['humidity']?['sg'] ?? 50.0],
        'temperature': [hourly['airTemperature']?['sg'] ?? 20.0],
        'visibility': [hourly['visibility']?['sg'] ?? 10.0],
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
        'precipitation': [values['precipitation'] ?? 0.0],
        'precipitation_type': [values['precipitationType'] ?? 0.0],
        'humidity': [values['humidity'] ?? 50.0],
        'temperature': [values['temperature'] ?? 20.0],
        'visibility': [values['visibility'] ?? 10.0],
      }
    };
  }

  /// Парсинг відповіді Open-Meteo
  Map<String, dynamic> _parseOpenMeteoResponse(Map<String, dynamic> data) {
    final hourly = data['hourly'] ?? {};
    return {
      'hourly': {
        'wind_speed': [hourly['wind_speed_10m']?[0] ?? 0.0],
        'wind_direction': [hourly['wind_direction_10m']?[0] ?? 0.0],
        'wind_gust': [hourly['wind_gusts_10m']?[0] ?? 0.0],
        'precipitation': [hourly['precipitation']?[0] ?? 0.0],
        'precipitation_type': [hourly['precipitation_type']?[0] ?? 0.0],
        'humidity': [hourly['relative_humidity_2m']?[0] ?? 50.0],
        'temperature': [hourly['temperature_2m']?[0] ?? 20.0],
        'visibility': [hourly['visibility']?[0] ?? 10.0],
      }
    };
  }
}
