import 'package:hive/hive.dart';
import '../models/weather_data.dart';
import '../datasources/weather_service.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../services/log_service.dart';

class WeatherRepository {
  final String _boxName = "weather_data";
  final WeatherService _weatherService;

  WeatherRepository(this._weatherService);

  Future<Box<WeatherData>> _openBox() async {
    return await Hive.openBox<WeatherData>(_boxName);
  }

  /// Отримуємо погоду з кешу або API
  Future<WeatherData> getWeather(double lat, double lon) async {
    await LogService.log('📦 [WeatherRepository] Запит погоди: lat=$lat, lon=$lon');
    final box = await _openBox();

    // Отримуємо всі записи для цієї локації
    final cachedData = box.values.where((weather) => weather.lat == lat && weather.lon == lon).toList();

    // Якщо дані є і не застаріли – повертаємо їх
    if (cachedData.isNotEmpty && !_isDataStale(cachedData.first)) {
      await LogService.log('📦 [WeatherRepository] Використовуємо кешовані дані для ($lat, $lon)');
      print("📦 Using cached weather data for ($lat, $lon)");
      return cachedData.first;
    }

    // Отримуємо нові дані, якщо кеш застарів або його немає
    await LogService.log('🌤️ [WeatherRepository] Отримуємо свіжі дані для ($lat, $lon)');
    print("🌤️ Fetching fresh weather data for ($lat, $lon)");
    return await fetchWeather(lat, lon);
  }

  /// Завантажуємо нові дані з API та зберігаємо в БД
  Future<WeatherData> fetchWeather(double lat, double lon) async {
    try {
      await LogService.log('🌤️ [WeatherRepository] Завантаження з API: lat=$lat, lon=$lon');
      final weatherData = await _weatherService.getWeather(lat, lon);

      final newData = WeatherData(
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
        roadCondition: 0.0, // Буде розраховано пізніше
        timestamp: DateTime.now(),
        source: "API",
      );

      await LogService.log('💾 [WeatherRepository] Зберігаємо нові дані в БД');
      // Оновлюємо БД
      await _updateWeatherData(newData);

      return newData;
    } catch (e) {
      await LogService.log('❌ [WeatherRepository] Помилка завантаження: $e');
      rethrow;
    }
  }

  /// Отримуємо погоду для кількох точок маршруту
  Future<List<WeatherData>> getWeatherForRoute(List<Map<String, double>> routePoints) async {
    await LogService.log('🗺️ [WeatherRepository] Запит погоди для маршруту: ${routePoints.length} точок');
    final List<WeatherData> weatherData = [];

    for (int i = 0; i < routePoints.length; i++) {
      final point = routePoints[i];
      await LogService.log('🗺️ [WeatherRepository] Обробка точки ${i + 1}/${routePoints.length}: lat=${point['lat']}, lon=${point['lon']}');
      final weather = await getWeather(point['lat']!, point['lon']!);
      weatherData.add(weather);
    }

    await LogService.log('✅ [WeatherRepository] Отримано погоду для всіх ${routePoints.length} точок маршруту');
    return weatherData;
  }

  /// Зберігаємо погоду в БД, видаляючи старі записи для цієї локації
  Future<void> _updateWeatherData(WeatherData data) async {
    try {
      final box = await _openBox();

      // Видаляємо старі записи для цієї локації
      final oldEntries = box.values.where((entry) => entry.lat == data.lat && entry.lon == data.lon).toList();
      for (var entry in oldEntries) {
        entry.delete();
      }
      await LogService.log('🗑️ [WeatherRepository] Видалено ${oldEntries.length} старих записів для (${data.lat}, ${data.lon})');

      // Додаємо новий запис
      await box.add(data);
      await LogService.log('💾 [WeatherRepository] Додано новий запис для (${data.lat}, ${data.lon})');

      // Очищуємо старих даних якщо кеш переповнений
      if (box.length > ApiConstants.maxCacheSize) {
        await LogService.log('⚠️ [WeatherRepository] Кеш переповнений (${box.length}/${ApiConstants.maxCacheSize}), очищаємо старі дані');
        await clearOldData();
      }
    } catch (e) {
      await LogService.log('❌ [WeatherRepository] Помилка оновлення даних: $e');
      rethrow;
    }
  }

  /// Чистимо старі дані (старші за 1 годину)
  Future<void> clearOldData() async {
    try {
      final box = await _openBox();
      final now = DateTime.now();

      final oldEntries = box.values.where((data) => now.difference(data.timestamp).inMinutes > ApiConstants.cacheExpirationMinutes).toList();

      for (var entry in oldEntries) {
        entry.delete();
      }

      await LogService.log('🧹 [WeatherRepository] Очищено ${oldEntries.length} старих записів погоди');
      print("🧹 Cleaned ${oldEntries.length} old weather records");
    } catch (e) {
      await LogService.log('❌ [WeatherRepository] Помилка очищення старих даних: $e');
      rethrow;
    }
  }

  /// Перевіряємо, чи дані застаріли
  bool _isDataStale(WeatherData data) {
    final now = DateTime.now();
    return now.difference(data.timestamp).inMinutes > ApiConstants.cacheExpirationMinutes;
  }

  /// Отримуємо статистику кешу
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final box = await _openBox();
      final now = DateTime.now();

      final totalRecords = box.length;
      final staleRecords = box.values.where((data) => now.difference(data.timestamp).inMinutes > ApiConstants.cacheExpirationMinutes).length;

      final stats = {
        'totalRecords': totalRecords,
        'staleRecords': staleRecords,
        'freshRecords': totalRecords - staleRecords,
        'maxCacheSize': ApiConstants.maxCacheSize,
      };

      await LogService.log('📊 [WeatherRepository] Статистика кешу: $stats');
      return stats;
    } catch (e) {
      await LogService.log('❌ [WeatherRepository] Помилка отримання статистики: $e');
      rethrow;
    }
  }
}
