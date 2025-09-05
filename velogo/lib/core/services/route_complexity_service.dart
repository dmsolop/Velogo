import 'package:dartz/dartz.dart';
import '../error/failures.dart';
import 'health_metrics.dart';
import 'personalization_engine.dart';
import 'health_integration_service.dart';
import '../../features/profile/domain/entities/profile_entity.dart';
import '../../features/weather/data/models/weather_data.dart';
import '../../features/map/data/models/road_surface.dart';
import '../../features/map/domain/entities/route_entity.dart';
import '../services/log_service.dart';

/// Основний сервіс для розрахунку складності маршруту з персоналізацією
class RouteComplexityService {
  static final RouteComplexityService _instance = RouteComplexityService._internal();
  factory RouteComplexityService() => _instance;
  RouteComplexityService._internal();

  final PersonalizationEngine _personalizationEngine = PersonalizationEngine();
  final HealthIntegrationService _healthIntegrationService = HealthIntegrationServiceFactory.create();

  /// Розрахунок загальної складності маршруту з персоналізацією
  Future<Either<Failure, PersonalizedDifficultyResult>> calculateRouteComplexity({
    required RouteEntity route,
    required ProfileEntity userProfile,
    DateTime? startTime,
    bool useHealthData = true,
  }) async {
    try {
      LogService.log('🎯 [RouteComplexityService] Розрахунок складності маршруту: ${route.name}');
      LogService.log('👤 [RouteComplexityService] Користувач: ${userProfile.name} (${userProfile.fitnessLevel})');

      // 1. Розраховуємо базову складність маршруту
      final baseDifficulty = _calculateBaseRouteDifficulty(route);

      // 2. Отримуємо health-метрики (якщо дозволено)
      HealthMetrics? healthMetrics;
      if (useHealthData && userProfile.healthDataIntegration) {
        final healthResult = await _healthIntegrationService.getCurrentHealthMetrics();
        healthResult.fold(
          (failure) => LogService.log('⚠️ [RouteComplexityService] Не вдалося отримати health-дані: $failure'),
          (metrics) => healthMetrics = metrics,
        );
      }

      // 3. Розраховуємо персоналізовану складність
      final personalizedResult = _personalizationEngine.calculatePersonalizedDifficulty(
        baseDifficulty: baseDifficulty,
        profile: userProfile,
        healthMetrics: healthMetrics,
      );

      LogService.log('✅ [RouteComplexityService] Розрахунок завершено: ${personalizedResult.personalizedDifficulty}');

      return Right(personalizedResult);
    } catch (e) {
      LogService.log('❌ [RouteComplexityService] Помилка розрахунку: $e');
      return Left(ServerFailure('Failed to calculate route complexity: $e'));
    }
  }

  /// Розрахунок складності для конкретної секції маршруту
  Future<Either<Failure, PersonalizedDifficultyResult>> calculateSectionComplexity({
    required RouteSectionEntity section,
    required ProfileEntity userProfile,
    WeatherData? weatherData,
    HealthMetrics? healthMetrics,
  }) async {
    try {
      LogService.log('📍 [RouteComplexityService] Розрахунок складності секції: ${section.id}');

      // Розраховуємо базову складність секції
      final baseDifficulty = _calculateBaseSectionDifficulty(section, weatherData);

      // Розраховуємо персоналізовану складність
      final personalizedResult = _personalizationEngine.calculatePersonalizedDifficulty(
        baseDifficulty: baseDifficulty,
        profile: userProfile,
        healthMetrics: healthMetrics,
        currentWeather: weatherData,
        currentSurface: _mapToRoadSurface(section.surfaceType),
      );

      return Right(personalizedResult);
    } catch (e) {
      LogService.log('❌ [RouteComplexityService] Помилка розрахунку секції: $e');
      return Left(ServerFailure('Failed to calculate section complexity: $e'));
    }
  }

  /// Розрахунок складності в реальному часі під час поїздки
  Future<Either<Failure, PersonalizedDifficultyResult>> calculateRealTimeComplexity({
    required RouteEntity route,
    required ProfileEntity userProfile,
    required int currentSectionIndex,
    WeatherData? currentWeather,
    HealthMetrics? currentHealthMetrics,
  }) async {
    try {
      LogService.log('⏱️ [RouteComplexityService] Розрахунок складності в реальному часі');

      if (currentSectionIndex >= route.sections.length) {
        return Left(ServerFailure('Invalid section index: $currentSectionIndex'));
      }

      final currentSection = route.sections[currentSectionIndex];

      // Розраховуємо складність поточної секції
      final sectionResult = await calculateSectionComplexity(
        section: currentSection,
        userProfile: userProfile,
        weatherData: currentWeather,
        healthMetrics: currentHealthMetrics,
      );

      return sectionResult;
    } catch (e) {
      LogService.log('❌ [RouteComplexityService] Помилка розрахунку в реальному часі: $e');
      return Left(ServerFailure('Failed to calculate real-time complexity: $e'));
    }
  }

  /// Розрахунок базової складності маршруту
  double _calculateBaseRouteDifficulty(RouteEntity route) {
    double totalDifficulty = 0.0;

    for (final section in route.sections) {
      totalDifficulty += section.difficulty;
    }

    // Середня складність маршруту
    final averageDifficulty = totalDifficulty / route.sections.length;

    // Корекція на загальну відстань та підйом
    final distanceFactor = _calculateDistanceFactor(route.totalDistance);
    final elevationFactor = _calculateElevationFactor(route.totalElevationGain);

    return averageDifficulty * distanceFactor * elevationFactor;
  }

  /// Розрахунок базової складності секції
  double _calculateBaseSectionDifficulty(RouteSectionEntity section, WeatherData? weather) {
    double difficulty = section.difficulty;

    // Корекція на погоду
    if (weather != null) {
      difficulty *= _calculateWeatherFactor(weather);
    }

    // Корекція на покриття
    difficulty *= _calculateSurfaceFactor(section.surfaceType);

    return difficulty;
  }

  /// Фактор відстані
  double _calculateDistanceFactor(double distance) {
    if (distance < 10) return 1.0; // Короткі маршрути
    if (distance < 25) return 1.1; // Середні маршрути
    if (distance < 50) return 1.2; // Довгі маршрути
    return 1.3; // Дуже довгі маршрути
  }

  /// Фактор підйому
  double _calculateElevationFactor(double elevationGain) {
    if (elevationGain < 100) return 1.0; // Рівнинний
    if (elevationGain < 300) return 1.1; // Помірний підйом
    if (elevationGain < 600) return 1.2; // Крутий підйом
    if (elevationGain < 1000) return 1.3; // Дуже крутий підйом
    return 1.4; // Екстремальний підйом
  }

  /// Фактор погоди
  double _calculateWeatherFactor(WeatherData weather) {
    double factor = 1.0;

    // Вплив вітру
    if (weather.windSpeed > 15) {
      factor += 0.2; // Сильний вітер
    } else if (weather.windSpeed > 10) {
      factor += 0.1; // Помірний вітер
    }

    // Вплив опадів
    if (weather.precipitation > 5) {
      factor += 0.3; // Дощ
    } else if (weather.precipitation > 0) {
      factor += 0.1; // Легкі опади
    }

    // Вплив температури
    if (weather.temperature < 0 || weather.temperature > 35) {
      factor += 0.2; // Екстремальна температура
    }

    return factor;
  }

  /// Фактор покриття дороги
  double _calculateSurfaceFactor(RoadSurfaceType surfaceType) {
    switch (surfaceType) {
      case RoadSurfaceType.asphalt:
        return 1.0; // Оптимальне покриття
      case RoadSurfaceType.concrete:
        return 1.05; // Трохи гірше
      case RoadSurfaceType.gravel:
        return 1.2; // Помірно гірше
      case RoadSurfaceType.dirt:
        return 1.4; // Значно гірше
      case RoadSurfaceType.cobblestone:
        return 1.3; // Висока вібрація
      case RoadSurfaceType.grass:
        return 1.5; // Дуже важко
      case RoadSurfaceType.sand:
        return 1.8; // Екстремально важко
    }
  }

  /// Мапінг типу покриття
  RoadSurface _mapToRoadSurface(RoadSurfaceType surfaceType) {
    switch (surfaceType) {
      case RoadSurfaceType.asphalt:
        return RoadSurface.asphalt;
      case RoadSurfaceType.concrete:
        return RoadSurface.concrete;
      case RoadSurfaceType.gravel:
        return RoadSurface.gravel;
      case RoadSurfaceType.dirt:
        return RoadSurface.dirt;
      case RoadSurfaceType.cobblestone:
        return RoadSurface.asphalt; // Найближчий аналог
      case RoadSurfaceType.grass:
        return RoadSurface.dirt; // Найближчий аналог
      case RoadSurfaceType.sand:
        return RoadSurface.mud; // Найближчий аналог
    }
  }

  /// Отримання рекомендацій на основі складності
  List<String> getRecommendations(PersonalizedDifficultyResult result) {
    final recommendations = <String>[];

    // Рекомендації на основі рівня складності
    switch (result.difficultyLevel) {
      case 'Легкий':
        recommendations.add('Ідеальний маршрут для початківців');
        recommendations.add('Можна взяти з собою дітей');
        break;
      case 'Помірний':
        recommendations.add('Підходить для досвідчених велосипедистів');
        recommendations.add('Рекомендується взяти воду та перекус');
        break;
      case 'Складний':
        recommendations.add('Потребує досвіду та підготовки');
        recommendations.add('Обов\'язково взяти воду, їжу та ремонтний набір');
        break;
      case 'Дуже складний':
        recommendations.add('Тільки для експертів');
        recommendations.add('Рекомендується їхати в групі');
        recommendations.add('Перевірте погоду перед виїздом');
        break;
      case 'Екстремальний':
        recommendations.add('Небезпечний маршрут');
        recommendations.add('Обов\'язково в групі з досвідченим гідом');
        recommendations.add('Повна екіпіровка та запасні частини');
        break;
    }

    // Рекомендації на основі факторів
    for (final factor in result.factors) {
      if (factor.impact > 0.1) {
        switch (factor.category) {
          case 'health':
            recommendations.add('Уважно стежте за показниками здоров\'я');
            break;
          case 'weather':
            recommendations.add('Перевірте прогноз погоди');
            break;
          case 'surface':
            recommendations.add('Підготуйте велосипед до типу покриття');
            break;
        }
      }
    }

    return recommendations;
  }

  /// Отримання статистики складності
  Map<String, dynamic> getComplexityStats(PersonalizedDifficultyResult result) {
    return {
      'baseDifficulty': result.baseDifficulty,
      'personalizedDifficulty': result.personalizedDifficulty,
      'personalizationFactor': result.personalizationFactor,
      'difficultyLevel': result.difficultyLevel,
      'factorsCount': result.factors.length,
      'positiveFactors': result.factors.where((f) => f.isPositive).length,
      'negativeFactors': result.factors.where((f) => !f.isPositive).length,
      'calculatedAt': result.calculatedAt?.toIso8601String(),
    };
  }
}
