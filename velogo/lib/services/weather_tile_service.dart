import 'dart:convert';
import 'package:hive/hive.dart';
import '../hive/models/weather_data.dart';
import '../models/road_surface.dart';
import 'weather_service.dart';
import 'road_condition_service.dart';
import 'log_service.dart';

/// Тайл погоди для регіону
class WeatherTile {
  final String tileId;
  final double centerLat;
  final double centerLon;
  final int zoomLevel;
  final Map<String, dynamic> weatherData;
  final DateTime timestamp;
  final String region;

  WeatherTile({
    required this.tileId,
    required this.centerLat,
    required this.centerLon,
    required this.zoomLevel,
    required this.weatherData,
    required this.timestamp,
    required this.region,
  });

  /// Створення з JSON
  factory WeatherTile.fromJson(Map<String, dynamic> json) {
    return WeatherTile(
      tileId: json['tileId'],
      centerLat: json['centerLat'],
      centerLon: json['centerLon'],
      zoomLevel: json['zoomLevel'],
      weatherData: Map<String, dynamic>.from(json['weatherData']),
      timestamp: DateTime.parse(json['timestamp']),
      region: json['region'],
    );
  }

  /// Конвертація в JSON
  Map<String, dynamic> toJson() {
    return {
      'tileId': tileId,
      'centerLat': centerLat,
      'centerLon': centerLon,
      'zoomLevel': zoomLevel,
      'weatherData': weatherData,
      'timestamp': timestamp.toIso8601String(),
      'region': region,
    };
  }
}

/// Сервіс для роботи з тайлами погоди
class WeatherTileService {
  static final WeatherTileService _instance = WeatherTileService._internal();
  factory WeatherTileService() => _instance;
  WeatherTileService._internal();

  final Map<String, WeatherTile> _tiles = {};
  final WeatherService _weatherService = WeatherService();
  final String _tileBoxName = "weather_tiles";

  /// Завантаження тайлів для регіону
  Future<void> loadRegionTiles(String region) async {
    try {
      await LogService.log('🗺️ [WeatherTileService] Завантаження тайлів для регіону: $region');

      final regionBounds = _getRegionBounds(region);
      final tiles = <String, WeatherTile>{};

      // Створюємо тайли для регіону (крок 0.5 градуса)
      for (double lat = regionBounds['minLat']!; lat <= regionBounds['maxLat']!; lat += 0.5) {
        for (double lon = regionBounds['minLon']!; lon <= regionBounds['maxLon']!; lon += 0.5) {
          final tileId = _generateTileId(lat, lon, 10);

          await LogService.log('🗺️ [WeatherTileService] Створення тайлу: $tileId');

          // Завантажуємо погоду для цього квадрата
          final weatherData = await _loadTileWeather(lat, lon);

          tiles[tileId] = WeatherTile(
            tileId: tileId,
            centerLat: lat,
            centerLon: lon,
            zoomLevel: 10,
            weatherData: weatherData,
            timestamp: DateTime.now(),
            region: region,
          );
        }
      }

      _tiles.addAll(tiles);
      await _saveTilesToCache();

      await LogService.log('✅ [WeatherTileService] Завантажено ${tiles.length} тайлів для регіону: $region');
    } catch (e) {
      await LogService.log('❌ [WeatherTileService] Помилка завантаження тайлів: $e');
      rethrow;
    }
  }

  /// Отримання приблизних погодних даних з тайлу
  WeatherData? getApproximateWeather(double lat, double lon, DateTime time) {
    try {
      final tileId = _findTileForCoordinates(lat, lon);
      final tile = _tiles[tileId];

      if (tile == null) {
        LogService.log('⚠️ [WeatherTileService] Тайл не знайдено для координат: lat=$lat, lon=$lon');
        return null;
      }

      // Отримуємо дані з тайлу
      final pointKey = '${lat.toStringAsFixed(2)},${lon.toStringAsFixed(2)}';
      final weatherData = tile.weatherData[pointKey];

      if (weatherData == null) {
        LogService.log('⚠️ [WeatherTileService] Дані не знайдено в тайлі для точки: $pointKey');
        return null;
      }

      return WeatherData(
        lat: lat,
        lon: lon,
        windSpeed: weatherData['windSpeed']?.toDouble() ?? 0.0,
        windDirection: weatherData['windDirection']?.toDouble() ?? 0.0,
        windGust: weatherData['windGust']?.toDouble() ?? 0.0,
        precipitation: weatherData['precipitation']?.toDouble() ?? 0.0,
        precipitationType: weatherData['precipitationType']?.toDouble() ?? 0.0,
        humidity: weatherData['humidity']?.toDouble() ?? 50.0,
        temperature: weatherData['temperature']?.toDouble() ?? 20.0,
        visibility: weatherData['visibility']?.toDouble() ?? 10.0,
        roadCondition: weatherData['roadCondition']?.toDouble() ?? 0.0,
        timestamp: time,
        source: 'Tile',
      );
    } catch (e) {
      LogService.log('❌ [WeatherTileService] Помилка отримання приблизних даних: $e');
      return null;
    }
  }

  /// Отримання точкових погодних даних
  Future<WeatherData?> getPreciseWeather(double lat, double lon, DateTime time, RoadSurface surface) async {
    try {
      await LogService.log('🎯 [WeatherTileService] Точковий запит: lat=$lat, lon=$lon, surface=${surface.displayName}');

      final weatherData = await _weatherService.getWeather(lat, lon);

      final weather = WeatherData(
        lat: lat,
        lon: lon,
        windSpeed: weatherData['hourly']['wind_speed'][0].toDouble(),
        windDirection: weatherData['hourly']['wind_direction'][0].toDouble(),
        windGust: weatherData['hourly']['wind_gust'][0].toDouble(),
        precipitation: weatherData['hourly']['precipitation']?[0]?.toDouble() ?? 0.0,
        precipitationType: weatherData['hourly']['precipitation_type']?[0]?.toDouble() ?? 0.0,
        humidity: weatherData['hourly']['humidity']?[0]?.toDouble() ?? 50.0,
        temperature: weatherData['hourly']['temperature']?[0]?.toDouble() ?? 20.0,
        visibility: weatherData['hourly']['visibility']?[0]?.toDouble() ?? 10.0,
        roadCondition: 0.0, // Буде розраховано окремим сервісом
        timestamp: time,
        source: 'Precise',
      );

      // Розраховуємо стан дороги через окремий сервіс
      final roadCondition = RoadConditionService().calculateRoadCondition(weather, surface);

      return weather.copyWith(roadCondition: roadCondition);
    } catch (e) {
      await LogService.log('❌ [WeatherTileService] Помилка точкового запиту: $e');
      return null;
    }
  }

  /// Корекція прогнозу на основі точкових даних (застарілий метод)
  @deprecated
  WeatherData correctForecast(WeatherData approximate, WeatherData? precise) {
    LogService.log('⚠️ [WeatherTileService] Використовується застарілий метод correctForecast. Використовуйте WeatherForecastCorrectionService');

    if (precise == null) {
      return approximate;
    }

    // Використовуємо точкові дані для критичних параметрів
    return approximate.copyWith(
      windSpeed: precise.windSpeed,
      windDirection: precise.windDirection,
      windGust: precise.windGust,
      precipitation: precise.precipitation,
      precipitationType: precise.precipitationType,
      humidity: precise.humidity,
      temperature: precise.temperature,
      visibility: precise.visibility,
      roadCondition: precise.roadCondition,
      source: 'Corrected',
    );
  }

  /// Оновлення тайлів
  Future<void> updateTiles() async {
    try {
      await LogService.log('🔄 [WeatherTileService] Оновлення тайлів');

      for (final tile in _tiles.values) {
        final weatherData = await _loadTileWeather(tile.centerLat, tile.centerLon);
        tile.weatherData.addAll(weatherData);
        // timestamp є final, тому створюємо новий тайл
        _tiles[tile.tileId] = WeatherTile(
          tileId: tile.tileId,
          centerLat: tile.centerLat,
          centerLon: tile.centerLon,
          zoomLevel: tile.zoomLevel,
          weatherData: tile.weatherData,
          timestamp: DateTime.now(),
          region: tile.region,
        );
      }

      await _saveTilesToCache();
      await LogService.log('✅ [WeatherTileService] Тайли оновлено');
    } catch (e) {
      await LogService.log('❌ [WeatherTileService] Помилка оновлення тайлів: $e');
      rethrow;
    }
  }

  /// Завантаження погоди для тайлу
  Future<Map<String, dynamic>> _loadTileWeather(double lat, double lon) async {
    try {
      final weatherData = await _weatherService.getWeather(lat, lon);

      // Створюємо дані для всіх точок в тайлі (крок 0.01 градуса)
      final tileData = <String, dynamic>{};

      for (double tileLat = lat - 0.25; tileLat <= lat + 0.25; tileLat += 0.01) {
        for (double tileLon = lon - 0.25; tileLon <= lon + 0.25; tileLon += 0.01) {
          final pointKey = '${tileLat.toStringAsFixed(2)},${tileLon.toStringAsFixed(2)}';

          // Інтерполюємо дані для кожної точки
          tileData[pointKey] = {
            'windSpeed': weatherData['hourly']['wind_speed'][0],
            'windDirection': weatherData['hourly']['wind_direction'][0],
            'windGust': weatherData['hourly']['wind_gust'][0],
            'precipitation': weatherData['hourly']['precipitation']?[0] ?? 0.0,
            'precipitationType': weatherData['hourly']['precipitation_type']?[0] ?? 0.0,
            'humidity': weatherData['hourly']['humidity']?[0] ?? 50.0,
            'temperature': weatherData['hourly']['temperature']?[0] ?? 20.0,
            'visibility': weatherData['hourly']['visibility']?[0] ?? 10.0,
          };
        }
      }

      return tileData;
    } catch (e) {
      await LogService.log('❌ [WeatherTileService] Помилка завантаження погоди для тайлу: $e');
      rethrow;
    }
  }

  /// Генерація ID тайлу
  String _generateTileId(double lat, double lon, int zoom) {
    return '${lat.toStringAsFixed(2)}_${lon.toStringAsFixed(2)}_zoom$zoom';
  }

  /// Пошук тайлу для координат
  String _findTileForCoordinates(double lat, double lon) {
    // Округляємо до найближчого тайлу
    final tileLat = (lat * 2).round() / 2;
    final tileLon = (lon * 2).round() / 2;
    return _generateTileId(tileLat, tileLon, 10);
  }

  /// Отримання меж регіону
  Map<String, double> _getRegionBounds(String region) {
    switch (region.toLowerCase()) {
      case 'ukraine':
        return {
          'minLat': 44.0,
          'maxLat': 53.0,
          'minLon': 22.0,
          'maxLon': 41.0,
        };
      case 'europe':
        return {
          'minLat': 35.0,
          'maxLat': 70.0,
          'minLon': -10.0,
          'maxLon': 40.0,
        };
      default:
        return {
          'minLat': 50.0,
          'maxLat': 51.0,
          'minLon': 30.0,
          'maxLon': 31.0,
        };
    }
  }

  /// Збереження тайлів в кеш
  Future<void> _saveTilesToCache() async {
    try {
      final box = await Hive.openBox<String>(_tileBoxName);

      for (final tile in _tiles.values) {
        await box.put(tile.tileId, jsonEncode(tile.toJson()));
      }

      await LogService.log('💾 [WeatherTileService] Тайли збережено в кеш');
    } catch (e) {
      await LogService.log('❌ [WeatherTileService] Помилка збереження тайлів: $e');
    }
  }

  /// Завантаження тайлів з кешу
  Future<void> _loadTilesFromCache() async {
    try {
      final box = await Hive.openBox<String>(_tileBoxName);

      for (final key in box.keys) {
        final tileJson = jsonDecode(box.get(key)!);
        final tile = WeatherTile.fromJson(tileJson);
        _tiles[tile.tileId] = tile;
      }

      await LogService.log('📦 [WeatherTileService] Тайли завантажено з кешу: ${_tiles.length}');
    } catch (e) {
      await LogService.log('❌ [WeatherTileService] Помилка завантаження тайлів з кешу: $e');
    }
  }

  /// Ініціалізація сервісу
  Future<void> initialize() async {
    await _loadTilesFromCache();
  }
}
