import 'dart:math';
import '../../../weather/data/models/weather_data.dart';
import '../models/road_surface.dart';
import '../../../weather/data/datasources/road_condition_service.dart';
import '../../../weather/data/datasources/user_speed_service.dart';
import '../../../../core/services/log_service.dart';

/// Сервіс для розрахунку загальної складності проходження маршруту
class RouteDifficultyService {
  static final RouteDifficultyService _instance = RouteDifficultyService._internal();
  factory RouteDifficultyService() => _instance;
  RouteDifficultyService._internal();

  /// Розрахунок загальної складності маршруту
  double calculateRouteDifficulty(
    List<WeatherData> weatherDataList,
    List<RoadSurface> roadSurfaces,
    List<Map<String, double>> routePoints,
    DateTime startTime, {
    String? userId,
  }) {
    try {
      LogService.log('🎯 [RouteDifficultyService] Розрахунок загальної складності маршруту: ${routePoints.length} точок');

      if (weatherDataList.isEmpty || roadSurfaces.isEmpty || routePoints.isEmpty) {
        LogService.log('⚠️ [RouteDifficultyService] Недостатньо даних для розрахунку');
        return 0.0;
      }

      double totalDifficulty = 0.0;
      final userSpeedService = UserSpeedService();

      for (int i = 0; i < routePoints.length; i++) {
        final point = routePoints[i];
        final weather = i < weatherDataList.length ? weatherDataList[i] : weatherDataList.last;
        final surface = i < roadSurfaces.length ? roadSurfaces[i] : RoadSurface.asphalt;

        // Отримуємо індивідуальну швидкість користувача
        double userSpeed = 15.0; // Швидкість за замовчуванням
        if (userId != null) {
          // Спочатку пробуємо отримати швидкість для конкретного типу покриття
          userSpeed = userSpeedService.getUserSpeedForSurface(userId, surface);
        }

        // Розраховуємо час досягнення цієї точки
        final distanceFromStart = _calculateDistanceFromStart(routePoints, i);
        final timeToReach = startTime.add(Duration(minutes: (distanceFromStart / userSpeed * 60).round()));

        // Розраховуємо загальну складність для цієї точки
        final pointDifficulty = _calculatePointDifficulty(weather, surface, point, timeToReach, routePoints, i);
        totalDifficulty += pointDifficulty;

        LogService.log('📍 [RouteDifficultyService] Точка $i: складність=${pointDifficulty.toStringAsFixed(2)}, поверхня=${surface.displayName}, швидкість=${userSpeed}км/год, час=$timeToReach');
      }

      final averageDifficulty = totalDifficulty / routePoints.length;
      LogService.log('✅ [RouteDifficultyService] Середня складність маршруту: ${averageDifficulty.toStringAsFixed(2)}');

      return averageDifficulty;
    } catch (e) {
      LogService.log('❌ [RouteDifficultyService] Помилка розрахунку складності: $e');
      return 0.0;
    }
  }

  /// Розрахунок загальної складності для однієї точки
  double _calculatePointDifficulty(
    WeatherData weather,
    RoadSurface surface,
    Map<String, double> point,
    DateTime time,
    List<Map<String, double>> routePoints,
    int currentIndex,
  ) {
    double difficulty = 0.0;

    // 1. Стан дороги (вплив опадів на покриття)
    difficulty += _calculateRoadConditionDifficulty(weather, surface);

    // 2. Супротив вітряному потоку (може бути позитивним або негативним)
    difficulty += _calculateWindResistanceDifficulty(weather, point, routePoints, currentIndex);

    // 3. Уклон ландшафту (може бути позитивним або негативним)
    difficulty += _calculateTerrainDifficulty(point);

    // 4. Додаткові фактори
    difficulty += _calculateAdditionalFactors(weather, time);

    return difficulty;
  }

  /// Розрахунок складності через стан дороги
  double _calculateRoadConditionDifficulty(WeatherData weather, RoadSurface surface) {
    final roadCondition = RoadConditionService().calculateRoadCondition(weather, surface);

    // Конвертуємо стан дороги в складність (0-5)
    if (roadCondition < 0.5) {
      return 0.0; // Сухо - без додаткової складності
    } else if (roadCondition < 1.0) {
      return 1.0; // Мокро - легка складність
    } else if (roadCondition < 2.0) {
      return 2.0; // Багнисто - помірна складність
    } else if (roadCondition < 3.0) {
      return 3.5; // Дуже багнисто - висока складність
    } else {
      return 5.0; // Непрохідно - критична складність
    }
  }

  /// Розрахунок складності через супротив вітряному потоку
  double _calculateWindResistanceDifficulty(WeatherData weather, Map<String, double> point, List<Map<String, double>> routePoints, int currentIndex) {
    double difficulty = 0.0;

    // Базовий вплив швидкості вітру
    final windSpeed = weather.windSpeed;
    final windDirection = weather.windDirection;
    final routeDirection = _calculateRouteDirectionInContext(routePoints, currentIndex);

    // Розраховуємо коефіцієнт впливу вітру
    final windResistance = _calculateWindResistance(windDirection, routeDirection);

    // Вплив може бути як позитивним (допомога), так і негативним (супротив)
    if (windResistance > 1.0) {
      // Супротив вітру - додаємо складність
      difficulty += windSpeed * 0.3 * (windResistance - 1.0);
    } else if (windResistance < 1.0) {
      // Попутний вітер - зменшуємо складність (негативне значення)
      difficulty -= windSpeed * 0.2 * (1.0 - windResistance);
    }

    // Додатковий вплив поривів
    if (weather.windGust > weather.windSpeed) {
      final gustImpact = (weather.windGust - weather.windSpeed) * 0.2;
      if (windResistance > 1.0) {
        difficulty += gustImpact; // Додаткова складність
      } else {
        difficulty -= gustImpact * 0.5; // Додаткова допомога
      }
    }

    return difficulty;
  }

  /// Розрахунок складності через уклон ландшафту
  double _calculateTerrainDifficulty(Map<String, double> point) {
    // Отримуємо уклон з точки маршруту
    final slope = point['slope'] ?? 0.0; // Уклон в градусах (позитивний = підйом, негативний = спуск)

    // Уклон може бути як позитивним (підйом), так і негативним (спуск)
    if (slope > 0) {
      // Підйом - додаємо складність
      if (slope < 5.0) {
        return slope * 0.2; // Легкий підйом
      } else if (slope < 10.0) {
        return 1.0 + (slope - 5.0) * 0.3; // Помірний підйом
      } else if (slope < 15.0) {
        return 2.5 + (slope - 10.0) * 0.4; // Крутий підйом
      } else if (slope < 20.0) {
        return 4.5 + (slope - 15.0) * 0.5; // Дуже крутий підйом
      } else {
        return 7.0 + (slope - 20.0) * 0.6; // Екстремальний підйом
      }
    } else if (slope < 0) {
      // Спуск - зменшуємо складність (негативне значення)
      final absSlope = slope.abs();
      if (absSlope < 5.0) {
        return -absSlope * 0.1; // Легкий спуск - невелика допомога
      } else if (absSlope < 10.0) {
        return -0.5 - (absSlope - 5.0) * 0.2; // Помірний спуск
      } else if (absSlope < 15.0) {
        return -1.5 - (absSlope - 10.0) * 0.3; // Крутий спуск
      } else {
        return -3.0 - (absSlope - 15.0) * 0.4; // Дуже крутий спуск
      }
    }

    return 0.0; // Рівнина
  }

  /// Розрахунок додаткових факторів
  double _calculateAdditionalFactors(WeatherData weather, DateTime time) {
    double difficulty = 0.0;

    // Вплив температури
    if (weather.temperature < 5.0) {
      difficulty += (5.0 - weather.temperature) * 0.1; // Холод
    } else if (weather.temperature > 30.0) {
      difficulty += (weather.temperature - 30.0) * 0.05; // Спека
    }

    // Вплив видимості
    if (weather.visibility < 5.0) {
      difficulty += (5.0 - weather.visibility) * 0.2;
    }

    // Вплив часу доби
    final hour = time.hour;
    if (hour >= 22 || hour <= 6) {
      difficulty += 1.0; // Нічний час
    } else if ((hour >= 7 && hour <= 9) || (hour >= 17 && hour <= 19)) {
      difficulty += 0.5; // Години пік
    }

    return difficulty;
  }

  /// Розрахунок напрямку маршруту в точці з урахуванням контексту
  double _calculateRouteDirectionInContext(List<Map<String, double>> routePoints, int currentIndex) {
    if (routePoints.isEmpty) return 0.0;

    // Якщо це перша точка, дивимося на наступну
    if (currentIndex == 0) {
      if (routePoints.length > 1) {
        return _calculateRouteDirectionBetweenPoints(routePoints[0], routePoints[1]);
      }
      return 0.0;
    }

    // Якщо це остання точка, дивимося на попередню
    if (currentIndex == routePoints.length - 1) {
      return _calculateRouteDirectionBetweenPoints(routePoints[currentIndex - 1], routePoints[currentIndex]);
    }

    // Інакше розраховуємо середній напрямок між попередньою та наступною точкою
    final prevDirection = _calculateRouteDirectionBetweenPoints(routePoints[currentIndex - 1], routePoints[currentIndex]);
    final nextDirection = _calculateRouteDirectionBetweenPoints(routePoints[currentIndex], routePoints[currentIndex + 1]);

    // Середній напрямок
    double avgDirection = (prevDirection + nextDirection) / 2.0;

    // Обробка переходу через 0/360
    if ((prevDirection - nextDirection).abs() > 180) {
      if (prevDirection > nextDirection) {
        avgDirection = (prevDirection + nextDirection + 360) / 2.0;
      } else {
        avgDirection = (prevDirection + 360 + nextDirection) / 2.0;
      }
    }

    return avgDirection % 360;
  }

  /// Розрахунок напрямку маршруту між двома точками
  double _calculateRouteDirectionBetweenPoints(Map<String, double> point1, Map<String, double> point2) {
    final lat1 = point1['lat']!;
    final lon1 = point1['lon']!;
    final lat2 = point2['lat']!;
    final lon2 = point2['lon']!;

    // Розраховуємо азимут між точками
    final dLon = _toRadians(lon2 - lon1);
    final lat1Rad = _toRadians(lat1);
    final lat2Rad = _toRadians(lat2);

    final y = sin(dLon) * cos(lat2Rad);
    final x = cos(lat1Rad) * sin(lat2Rad) - sin(lat1Rad) * cos(lat2Rad) * cos(dLon);

    double bearing = atan2(y, x);
    bearing = _toDegrees(bearing);

    // Нормалізуємо до 0-360
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  /// Розрахунок коефіцієнта супротиву вітру
  double _calculateWindResistance(double windDirection, double routeDirection) {
    // Розраховуємо кут між напрямком вітру та маршруту
    double angle = (windDirection - routeDirection).abs();
    if (angle > 180) angle = 360 - angle;

    // Коефіцієнт супротиву залежно від кута
    if (angle < 45) {
      return 1.5; // Проти вітру - супротив
    } else if (angle < 90) {
      return 1.2; // Бічний вітер - невеликий супротив
    } else if (angle < 135) {
      return 0.8; // Попутний вітер - допомога
    } else {
      return 0.5; // Сильний попутний вітер - сильна допомога
    }
  }

  /// Конвертація радіанів в градуси
  double _toDegrees(double radians) {
    return radians * 180.0 / pi;
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
}
