import 'dart:math';
import 'package:latlong2/latlong.dart';
import '../hive/models/weather_data.dart';
import '../bloc/weather/weather_cubit.dart';

class RouteAnalyzer {
  /// Аналізує маршрут та визначає ключові точки для погодних запитів
  static List<Map<String, double>> getKeyPoints(List<LatLng> routePoints) {
    if (routePoints.isEmpty) return [];

    final List<Map<String, double>> keyPoints = [];

    // Додаємо початкову точку
    keyPoints.add({
      'lat': routePoints.first.latitude,
      'lon': routePoints.first.longitude,
    });

    // Аналізуємо зміни напрямку та відстані
    for (int i = 1; i < routePoints.length; i++) {
      final prevPoint = routePoints[i - 1];
      final currentPoint = routePoints[i];

      // Якщо зміна напрямку більше 30 градусів або відстань більше 5км
      if (_isSignificantChange(routePoints, i) || _calculateDistance(prevPoint, currentPoint) > 5.0) {
        keyPoints.add({
          'lat': currentPoint.latitude,
          'lon': currentPoint.longitude,
        });
      }
    }

    // Додаємо кінцеву точку
    if (routePoints.length > 1) {
      keyPoints.add({
        'lat': routePoints.last.latitude,
        'lon': routePoints.last.longitude,
      });
    }

    return keyPoints;
  }

  /// Розраховує складність маршруту на основі погодних умов
  static double calculateWeatherDifficulty(List<WeatherData> weatherDataList, List<LatLng> routePoints) {
    if (weatherDataList.isEmpty || routePoints.isEmpty) return 0.0;

    double totalDifficulty = 0.0;
    int pointCount = 0;

    for (int i = 0; i < weatherDataList.length && i < routePoints.length; i++) {
      final weather = weatherDataList[i];
      final point = routePoints[i];

      // Розраховуємо вплив вітру на складність
      final windDifficulty = _calculateWindDifficulty(weather, point);
      totalDifficulty += windDifficulty;
      pointCount++;
    }

    return pointCount > 0 ? totalDifficulty / pointCount : 0.0;
  }

  /// Розраховує вплив вітру на складність для конкретної точки
  static double _calculateWindDifficulty(WeatherData weather, LatLng point) {
    // Базовий вплив швидкості вітру
    double difficulty = weather.windSpeed * 0.5;

    // Додатковий вплив поривів
    difficulty += (weather.windGust - weather.windSpeed) * 0.3;

    // Вплив напрямку вітру (попутний/зустрічний)
    // TODO: Додати логіку розрахунку напрямку руху велосипедиста

    return difficulty;
  }

  /// Перевіряє чи є значна зміна напрямку
  static bool _isSignificantChange(List<LatLng> points, int index) {
    if (index < 2 || index >= points.length - 1) return false;

    final prevPoint = points[index - 1];
    final currentPoint = points[index];
    final nextPoint = points[index + 1];

    // Розраховуємо кути
    final angle1 = _calculateBearing(prevPoint, currentPoint);
    final angle2 = _calculateBearing(currentPoint, nextPoint);

    final angleDifference = (angle2 - angle1).abs();
    return angleDifference > 30.0; // Значна зміна напрямку
  }

  /// Розраховує азимут між двома точками
  static double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * pi / 180;
    final lat2 = to.latitude * pi / 180;
    final dLon = (to.longitude - from.longitude) * pi / 180;

    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    final bearing = atan2(y, x) * 180 / pi;
    return (bearing + 360) % 360;
  }

  /// Розраховує відстань між двома точками в кілометрах
  static double _calculateDistance(LatLng from, LatLng to) {
    const double earthRadius = 6371; // км

    final lat1 = from.latitude * pi / 180;
    final lat2 = to.latitude * pi / 180;
    final dLat = (to.latitude - from.latitude) * pi / 180;
    final dLon = (to.longitude - from.longitude) * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }
}
