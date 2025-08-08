import 'dart:math';
import '../hive/models/weather_data.dart';
import '../models/road_surface.dart';
import 'log_service.dart';

/// Сервіс для розрахунку складності маршруту
class RouteDifficultyService {
  static final RouteDifficultyService _instance = RouteDifficultyService._internal();
  factory RouteDifficultyService() => _instance;
  RouteDifficultyService._internal();

  /// Розрахунок складності маршруту з урахуванням погоди та покриття
  double calculateRouteDifficulty(
    List<WeatherData> weatherDataList,
    List<RoadSurface> roadSurfaces,
    List<Map<String, double>> routePoints,
    DateTime startTime,
  ) {
    try {
      LogService.log('🎯 [RouteDifficultyService] Розрахунок складності маршруту: ${routePoints.length} точок');

      if (weatherDataList.isEmpty || roadSurfaces.isEmpty || routePoints.isEmpty) {
        LogService.log('⚠️ [RouteDifficultyService] Недостатньо даних для розрахунку');
        return 0.0;
      }

      double totalDifficulty = 0.0;
      final averageSpeed = 15.0; // км/год - середня швидкість велосипедиста

      for (int i = 0; i < routePoints.length; i++) {
        final point = routePoints[i];
        final weather = i < weatherDataList.length ? weatherDataList[i] : weatherDataList.last;
        final surface = i < roadSurfaces.length ? roadSurfaces[i] : RoadSurface.asphalt;

        // Розраховуємо час досягнення цієї точки
        final distanceFromStart = _calculateDistanceFromStart(routePoints, i);
        final timeToReach = startTime.add(Duration(minutes: (distanceFromStart / averageSpeed * 60).round()));

        // Розраховуємо складність для цієї точки
        final pointDifficulty = _calculatePointDifficulty(weather, surface, timeToReach);
        totalDifficulty += pointDifficulty;

        LogService.log('📍 [RouteDifficultyService] Точка $i: складність=${pointDifficulty.toStringAsFixed(2)}, поверхня=${surface.displayName}, час=$timeToReach');
      }

      final averageDifficulty = totalDifficulty / routePoints.length;
      LogService.log('✅ [RouteDifficultyService] Середня складність маршруту: ${averageDifficulty.toStringAsFixed(2)}');

      return averageDifficulty;
    } catch (e) {
      LogService.log('❌ [RouteDifficultyService] Помилка розрахунку складності: $e');
      return 0.0;
    }
  }

  /// Розрахунок складності для однієї точки
  double _calculatePointDifficulty(WeatherData weather, RoadSurface surface, DateTime time) {
    double difficulty = 0.0;

    // 1. Вплив вітру
    difficulty += _calculateWindDifficulty(weather);

    // 2. Вплив опадів на покриття
    difficulty += _calculatePrecipitationDifficulty(weather, surface);

    // 3. Вплив температури
    difficulty += _calculateTemperatureDifficulty(weather);

    // 4. Вплив видимості
    difficulty += _calculateVisibilityDifficulty(weather);

    // 5. Вплив часу доби
    difficulty += _calculateTimeDifficulty(time);

    return difficulty;
  }

  /// Розрахунок впливу вітру
  double _calculateWindDifficulty(WeatherData weather) {
    double difficulty = 0.0;

    // Базовий вплив швидкості вітру
    difficulty += weather.windSpeed * 0.5;

    // Додатковий вплив поривів
    if (weather.windGust > weather.windSpeed) {
      difficulty += (weather.windGust - weather.windSpeed) * 0.3;
    }

    // Вплив напрямку вітру (проти вітру = складніше)
    final windDirection = weather.windDirection;
    if (windDirection >= 45 && windDirection <= 135) {
      difficulty += weather.windSpeed * 0.2; // Проти вітру
    }

    return difficulty;
  }

  /// Розрахунок впливу опадів на покриття
  double _calculatePrecipitationDifficulty(WeatherData weather, RoadSurface surface) {
    if (weather.precipitation == 0.0) {
      return 0.0; // Без опадів
    }

    double difficulty = 0.0;

    // Базовий вплив опадів
    difficulty += weather.precipitation * 0.1;

    // Корекція залежно від типу покриття
    difficulty *= surface.precipitationImpact;

    // Додатковий вплив типу опадів
    if (weather.precipitationType == 2.0) {
      // Сніг
      difficulty *= 1.5;
    }

    // Вплив вологості
    if (weather.humidity > 80.0) {
      difficulty += 0.5;
    }

    return difficulty;
  }

  /// Розрахунок впливу температури
  double _calculateTemperatureDifficulty(WeatherData weather) {
    double difficulty = 0.0;

    // Холодна погода
    if (weather.temperature < 5.0) {
      difficulty += (5.0 - weather.temperature) * 0.1;
    }

    // Гаряча погода
    if (weather.temperature > 30.0) {
      difficulty += (weather.temperature - 30.0) * 0.05;
    }

    return difficulty;
  }

  /// Розрахунок впливу видимості
  double _calculateVisibilityDifficulty(WeatherData weather) {
    if (weather.visibility >= 10.0) {
      return 0.0; // Хороша видимість
    }

    return (10.0 - weather.visibility) * 0.2;
  }

  /// Розрахунок впливу часу доби
  double _calculateTimeDifficulty(DateTime time) {
    final hour = time.hour;

    // Нічний час (22:00 - 06:00)
    if (hour >= 22 || hour <= 6) {
      return 1.0;
    }

    // Ранкові/вечірні години пік
    if ((hour >= 7 && hour <= 9) || (hour >= 17 && hour <= 19)) {
      return 0.5;
    }

    return 0.0;
  }

  /// Розрахунок відстані від початку маршруту
  double _calculateDistanceFromStart(List<Map<String, double>> routePoints, int currentIndex) {
    double totalDistance = 0.0;

    for (int i = 0; i < currentIndex; i++) {
      if (i + 1 < routePoints.length) {
        totalDistance += _calculateDistance(
          routePoints[i]['lat']!,
          routePoints[i]['lon']!,
          routePoints[i + 1]['lat']!,
          routePoints[i + 1]['lon']!,
        );
      }
    }

    return totalDistance;
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

  /// Конвертація градусів в радіани
  double _toRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  /// Отримання рівня складності (текстовий опис)
  String getDifficultyLevel(double difficulty) {
    if (difficulty < 2.0) {
      return 'Легкий';
    } else if (difficulty < 4.0) {
      return 'Помірний';
    } else if (difficulty < 6.0) {
      return 'Складний';
    } else if (difficulty < 8.0) {
      return 'Дуже складний';
    } else {
      return 'Екстремальний';
    }
  }

  /// Отримання кольору складності
  int getDifficultyColor(double difficulty) {
    if (difficulty < 2.0) {
      return 0xFF4CAF50; // Зелений
    } else if (difficulty < 4.0) {
      return 0xFFFF9800; // Помаранчевий
    } else if (difficulty < 6.0) {
      return 0xFFFF5722; // Червоний
    } else if (difficulty < 8.0) {
      return 0xFF9C27B0; // Фіолетовий
    } else {
      return 0xFF000000; // Чорний
    }
  }
}
