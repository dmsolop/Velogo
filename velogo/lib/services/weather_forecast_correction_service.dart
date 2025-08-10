import 'dart:math';
import '../features/weather/data/models/weather_data.dart';
import 'log_service.dart';

/// Сервіс для корекції прогнозу на основі точкових даних
class WeatherForecastCorrectionService {
  static final WeatherForecastCorrectionService _instance = WeatherForecastCorrectionService._internal();
  factory WeatherForecastCorrectionService() => _instance;
  WeatherForecastCorrectionService._internal();

  /// Корекція прогнозу для маршруту на основі точкових даних
  List<WeatherData> correctRouteForecast(
    List<WeatherData> approximateForecast,
    List<WeatherData> preciseData,
    DateTime startTime,
  ) {
    try {
      LogService.log('🔮 [WeatherForecastCorrectionService] Корекція прогнозу: ${approximateForecast.length} точок, ${preciseData.length} точкових даних');

      if (approximateForecast.isEmpty) {
        return approximateForecast;
      }

      final correctedForecast = <WeatherData>[];
      final averageSpeed = 15.0; // км/год

      for (int i = 0; i < approximateForecast.length; i++) {
        final approximate = approximateForecast[i];

        // Знаходимо найближчі точкові дані
        final nearestPrecise = _findNearestPreciseData(approximate, preciseData);

        if (nearestPrecise != null) {
          // Розраховуємо час досягнення цієї точки
          final distanceFromStart = _calculateDistanceFromStart(approximateForecast, i);
          final timeToReach = startTime.add(Duration(minutes: (distanceFromStart / averageSpeed * 60).round()));

          // Корегуємо прогноз
          final corrected = _correctPointForecast(approximate, nearestPrecise, timeToReach);
          correctedForecast.add(corrected);

          LogService.log('📍 [WeatherForecastCorrectionService] Точка $i: коректовано на основі точкових даних');
        } else {
          // Використовуємо приблизний прогноз
          correctedForecast.add(approximate);
        }
      }

      LogService.log('✅ [WeatherForecastCorrectionService] Прогноз скоректовано для ${correctedForecast.length} точок');
      return correctedForecast;
    } catch (e) {
      LogService.log('❌ [WeatherForecastCorrectionService] Помилка корекції прогнозу: $e');
      return approximateForecast;
    }
  }

  /// Корекція прогнозу для однієї точки
  WeatherData _correctPointForecast(
    WeatherData approximate,
    WeatherData precise,
    DateTime timeToReach,
  ) {
    // Розраховуємо ваги для інтерполяції
    final timeWeight = _calculateTimeWeight(approximate.timestamp, precise.timestamp, timeToReach);
    final distanceWeight = _calculateDistanceWeight(approximate.lat, approximate.lon, precise.lat, precise.lon);

    // Комбінована вага
    final combinedWeight = (timeWeight + distanceWeight) / 2.0;

    // Інтерполюємо дані
    final correctedWindSpeed = _interpolate(approximate.windSpeed, precise.windSpeed, combinedWeight);
    final correctedWindDirection = _interpolateDirection(approximate.windDirection, precise.windDirection, combinedWeight);
    final correctedWindGust = _interpolate(approximate.windGust, precise.windGust, combinedWeight);
    final correctedPrecipitation = _interpolate(approximate.precipitation, precise.precipitation, combinedWeight);
    final correctedHumidity = _interpolate(approximate.humidity, precise.humidity, combinedWeight);
    final correctedTemperature = _interpolate(approximate.temperature, precise.temperature, combinedWeight);
    final correctedVisibility = _interpolate(approximate.visibility, precise.visibility, combinedWeight);

    // Повертаємо скоректовані погодні дані (без розрахунку стану дороги)
    return approximate.copyWith(
      windSpeed: correctedWindSpeed,
      windDirection: correctedWindDirection,
      windGust: correctedWindGust,
      precipitation: correctedPrecipitation,
      humidity: correctedHumidity,
      temperature: correctedTemperature,
      visibility: correctedVisibility,
      source: 'Corrected',
    );
  }

  /// Пошук найближчих точкових даних
  WeatherData? _findNearestPreciseData(WeatherData approximate, List<WeatherData> preciseData) {
    if (preciseData.isEmpty) return null;

    WeatherData? nearest;
    double minDistance = double.infinity;

    for (final precise in preciseData) {
      final distance = _calculateDistance(
        approximate.lat,
        approximate.lon,
        precise.lat,
        precise.lon,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearest = precise;
      }
    }

    // Повертаємо тільки якщо відстань менше 10 км
    return minDistance < 10.0 ? nearest : null;
  }

  /// Розрахунок ваги на основі часу
  double _calculateTimeWeight(DateTime approximateTime, DateTime preciseTime, DateTime targetTime) {
    final timeDiff1 = (approximateTime.difference(targetTime).inMinutes).abs();
    final timeDiff2 = (preciseTime.difference(targetTime).inMinutes).abs();

    final totalDiff = timeDiff1 + timeDiff2;
    if (totalDiff == 0) return 0.5;

    return timeDiff2 / totalDiff;
  }

  /// Розрахунок ваги на основі відстані
  double _calculateDistanceWeight(double lat1, double lon1, double lat2, double lon2) {
    final distance = _calculateDistance(lat1, lon1, lat2, lon2);
    // Нормалізуємо відстань (0-10 км -> 0-1)
    return (distance / 10.0).clamp(0.0, 1.0);
  }

  /// Інтерполяція значень
  double _interpolate(double value1, double value2, double weight) {
    return value1 + (value2 - value1) * weight;
  }

  /// Інтерполяція напрямку вітру (з урахуванням циклічності 0-360)
  double _interpolateDirection(double direction1, double direction2, double weight) {
    double diff = direction2 - direction1;

    // Обробка переходу через 0/360
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;

    final interpolated = direction1 + diff * weight;
    return interpolated < 0 ? interpolated + 360 : interpolated % 360;
  }

  /// Розрахунок відстані між двома точками (км)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371.0; // км

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) + cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Розрахунок відстані від початку маршруту
  double _calculateDistanceFromStart(List<WeatherData> routePoints, int currentIndex) {
    double totalDistance = 0.0;

    for (int i = 0; i < currentIndex; i++) {
      if (i + 1 < routePoints.length) {
        totalDistance += _calculateDistance(
          routePoints[i].lat,
          routePoints[i].lon,
          routePoints[i + 1].lat,
          routePoints[i + 1].lon,
        );
      }
    }

    return totalDistance;
  }

  /// Конвертація градусів в радіани
  double _toRadians(double degrees) {
    return degrees * pi / 180.0;
  }
}
