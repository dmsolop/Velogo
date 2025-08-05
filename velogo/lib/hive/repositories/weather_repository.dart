import 'package:hive/hive.dart';
import '../models/weather_data.dart';
import '../../services/weather_service.dart';
import '../../constants/api_constants.dart';

class WeatherRepository {
  final String _boxName = "weather_data";
  final WeatherService _weatherService;

  WeatherRepository(this._weatherService);

  Future<Box<WeatherData>> _openBox() async {
    return await Hive.openBox<WeatherData>(_boxName);
  }

  /// Отримуємо погоду з кешу або API
  Future<WeatherData> getWeather(double lat, double lon) async {
    final box = await _openBox();

    // Отримуємо всі записи для цієї локації
    final cachedData = box.values.where((weather) => weather.lat == lat && weather.lon == lon).toList();

    // Якщо дані є і не застаріли – повертаємо їх
    if (cachedData.isNotEmpty && !_isDataStale(cachedData.first)) {
      print("📦 Using cached weather data for ($lat, $lon)");
      return cachedData.first;
    }

    // Отримуємо нові дані, якщо кеш застарів або його немає
    print("🌤️ Fetching fresh weather data for ($lat, $lon)");
    return await fetchWeather(lat, lon);
  }

  /// Завантажуємо нові дані з API та зберігаємо в БД
  Future<WeatherData> fetchWeather(double lat, double lon) async {
    final weatherData = await _weatherService.getWeather(lat, lon);

    final newData = WeatherData(
      lat: lat,
      lon: lon,
      windSpeed: weatherData['hourly']['wind_speed'][0].toDouble(),
      windDirection: weatherData['hourly']['wind_direction'][0].toDouble(),
      windGust: weatherData['hourly']['wind_gust'][0].toDouble(),
      timestamp: DateTime.now(),
      source: "API",
    );

    // Оновлюємо БД
    await _updateWeatherData(newData);

    return newData;
  }

  /// Отримуємо погоду для кількох точок маршруту
  Future<List<WeatherData>> getWeatherForRoute(List<Map<String, double>> routePoints) async {
    final List<WeatherData> weatherData = [];

    for (final point in routePoints) {
      final weather = await getWeather(point['lat']!, point['lon']!);
      weatherData.add(weather);
    }

    return weatherData;
  }

  /// Зберігаємо погоду в БД, видаляючи старі записи для цієї локації
  Future<void> _updateWeatherData(WeatherData data) async {
    final box = await _openBox();

    // Видаляємо старі записи для цієї локації
    final oldEntries = box.values.where((entry) => entry.lat == data.lat && entry.lon == data.lon).toList();
    for (var entry in oldEntries) {
      entry.delete();
    }

    // Додаємо новий запис
    await box.add(data);

    // Очищуємо старих даних якщо кеш переповнений
    if (box.length > ApiConstants.maxCacheSize) {
      await clearOldData();
    }
  }

  /// Чистимо старі дані (старші за 1 годину)
  Future<void> clearOldData() async {
    final box = await _openBox();
    final now = DateTime.now();

    final oldEntries = box.values.where((data) => now.difference(data.timestamp).inMinutes > ApiConstants.cacheExpirationMinutes).toList();

    for (var entry in oldEntries) {
      entry.delete();
    }

    print("🧹 Cleaned ${oldEntries.length} old weather records");
  }

  /// Перевіряємо, чи дані застаріли
  bool _isDataStale(WeatherData data) {
    final now = DateTime.now();
    return now.difference(data.timestamp).inMinutes > ApiConstants.cacheExpirationMinutes;
  }

  /// Отримуємо статистику кешу
  Future<Map<String, dynamic>> getCacheStats() async {
    final box = await _openBox();
    final now = DateTime.now();

    final totalRecords = box.length;
    final staleRecords = box.values.where((data) => now.difference(data.timestamp).inMinutes > ApiConstants.cacheExpirationMinutes).length;

    return {
      'totalRecords': totalRecords,
      'staleRecords': staleRecords,
      'freshRecords': totalRecords - staleRecords,
      'maxCacheSize': ApiConstants.maxCacheSize,
    };
  }
}
