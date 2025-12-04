import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import '../error/failures.dart';
import 'health_metrics.dart';
import 'personalization_engine.dart';
import 'health_integration_service.dart';
import 'local_storage_service.dart';
import '../../features/profile/domain/entities/profile_entity.dart';
import '../../features/weather/data/models/weather_data.dart';
import '../../features/map/domain/entities/route_entity.dart';
import '../../features/map/domain/repositories/routing_repository.dart';
import '../services/log_service.dart';

/// Основний сервіс для розрахунку складності маршруту з персоналізацією
class RouteComplexityService {
  static final RouteComplexityService _instance = RouteComplexityService._internal();
  factory RouteComplexityService() => _instance;
  RouteComplexityService._internal();

  final PersonalizationEngine _personalizationEngine = PersonalizationEngine();
  final HealthIntegrationService _healthIntegrationService = HealthIntegrationServiceFactory.create();
  final LocalStorageService _localStorage = LocalStorageService();
  
  // Repository для розрахунку elevationGain та windEffect
  RoutingRepository? _routingRepository;
  
  /// Встановити RoutingRepository для розрахунку elevationGain та windEffect
  void setRoutingRepository(RoutingRepository repository) {
    _routingRepository = repository;
  }

  /// Розрахунок загальної складності маршруту з персоналізацією
  Future<Either<Failure, PersonalizedDifficultyResult>> calculateRouteComplexity({
    required RouteEntity route,
    required ProfileEntity userProfile,
    DateTime? startTime,
    bool useHealthData = true,
    bool useCache = true,
  }) async {
    try {
      LogService.log('🎯 [RouteComplexityService] Розрахунок складності маршруту: ${route.name}');
      LogService.log('👤 [RouteComplexityService] Користувач: ${userProfile.name} (${userProfile.fitnessLevel})');

      // 1. Перевірка кешу (якщо увімкнено)
      if (useCache) {
        final cachedResult = _getCachedComplexityResult(route.id);
        if (cachedResult != null && _isCacheValid(route.id)) {
          LogService.log('💾 [RouteComplexityService] Використовуємо кешований результат для маршруту: ${route.id}');
          return Right(cachedResult);
        }
      }

      // 2. Розраховуємо базову складність маршруту
      final baseDifficulty = _calculateBaseRouteDifficulty(route);

      // 3. Отримуємо health-метрики (якщо дозволено)
      HealthMetrics? healthMetrics;
      if (useHealthData && userProfile.healthDataIntegration) {
        final healthResult = await _healthIntegrationService.getCurrentHealthMetrics();
        healthResult.fold(
          (failure) => LogService.log('⚠️ [RouteComplexityService] Не вдалося отримати health-дані: $failure'),
          (metrics) => healthMetrics = metrics,
        );
      }

      // 4. Розраховуємо персоналізовану складність
      final personalizedResult = _personalizationEngine.calculatePersonalizedDifficulty(
        baseDifficulty: baseDifficulty,
        profile: userProfile,
        healthMetrics: healthMetrics,
      );

      // 5. Збереження в кеш
      if (useCache) {
        await _cacheComplexityResult(route.id, personalizedResult);
      }

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
      );

      return Right(personalizedResult);
    } catch (e) {
      LogService.log('❌ [RouteComplexityService] Помилка розрахунку секції: $e');
      return Left(ServerFailure('Failed to calculate section complexity: $e'));
    }
  }

  /// Розрахунок всіх параметрів секції на основі координат та профілю користувача
  ///
  /// Функціональність:
  /// - Розраховує elevationGain, windEffect, surfaceType, difficulty, averageSpeed
  /// - Враховує індивідуальні можливості користувача
  /// - Використовує погодні дані (якщо доступні)
  ///
  /// Параметри:
  /// - coordinates: координати секції
  /// - startPoint: початкова точка секції (для розрахунку elevationGain)
  /// - endPoint: кінцева точка секції
  /// - userProfile: профіль користувача
  /// - weatherData: погодні дані (опціонально)
  /// - healthMetrics: health-метрики (опціонально)
  ///
  /// Повертає: SectionParameters з усіма розрахованими параметрами
  ///
  /// Використовується в: CalculateSectionParametersUseCase
  Future<Either<Failure, SectionParameters>> calculateSectionParameters({
    required List<LatLng> coordinates,
    required LatLng startPoint,
    required LatLng endPoint,
    required ProfileEntity userProfile,
    WeatherData? weatherData,
    HealthMetrics? healthMetrics,
  }) async {
    try {
      LogService.log('📊 [RouteComplexityService] Розрахунок параметрів секції з ${coordinates.length} координатами');

      // 1. Розраховуємо відстань
      final distance = _calculateSectionDistance(coordinates);

      // 2. Розраховуємо elevationGain через Repository
      double elevationGain = 0.0;
      if (_routingRepository != null) {
        final elevationResult = await _routingRepository!.calculateElevationGain(
          startPoint: startPoint,
          endPoint: endPoint,
        );
        elevationGain = elevationResult.fold((_) => 0.0, (e) => e);
      }

      // 3. Розраховуємо windEffect через Repository
      double windEffect = 0.0;
      if (_routingRepository != null) {
        final windResult = await _routingRepository!.calculateWindEffect(
          startPoint: startPoint,
          endPoint: endPoint,
        );
        windEffect = windResult.fold((_) => 0.0, (w) => w);
      }

      // 4. Визначаємо surfaceType (тимчасово - за замовчуванням asphalt)
      // TODO: Реалізувати визначення типу покриття на основі координат
      final surfaceType = RoadSurfaceType.asphalt;

      // 5. Розраховуємо базову складність
      final baseDifficulty = _calculateBaseDifficultyFromParameters(
        elevationGain: elevationGain,
        windEffect: windEffect,
        surfaceType: surfaceType,
        distance: distance,
        weatherData: weatherData,
        coordinates: coordinates,
      );

      // 6. Розраховуємо персоналізовану складність
      final personalizedResult = _personalizationEngine.calculatePersonalizedDifficulty(
        baseDifficulty: baseDifficulty,
        profile: userProfile,
        healthMetrics: healthMetrics,
      );

      // 7. Розраховуємо averageSpeed на основі складності та профілю
      final averageSpeed = _calculateAverageSpeed(
        difficulty: personalizedResult.personalizedDifficulty,
        surfaceType: surfaceType,
        profile: userProfile,
      );

      final parameters = SectionParameters(
        elevationGain: elevationGain,
        windEffect: windEffect,
        surfaceType: surfaceType,
        difficulty: personalizedResult.personalizedDifficulty,
        averageSpeed: averageSpeed,
        distance: distance,
      );

      LogService.log('✅ [RouteComplexityService] Параметри секції розраховано: difficulty=${parameters.difficulty}, speed=${parameters.averageSpeed}');
      return Right(parameters);
    } catch (e) {
      LogService.log('❌ [RouteComplexityService] Помилка розрахунку параметрів секції: $e');
      return Left(ServerFailure('Failed to calculate section parameters: $e'));
    }
  }

  /// Розрахунок відстані секції
  double _calculateSectionDistance(List<LatLng> coordinates) {
    if (coordinates.length < 2) return 0.0;

    double totalDistance = 0.0;
    for (int i = 1; i < coordinates.length; i++) {
      totalDistance += _calculateDistanceBetweenPoints(coordinates[i - 1], coordinates[i]);
    }
    return totalDistance;
  }

  /// Розрахунок відстані між двома точками (Haversine formula)
  double _calculateDistanceBetweenPoints(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // Радіус Землі в метрах

    final lat1Rad = point1.latitude * pi / 180;
    final lat2Rad = point2.latitude * pi / 180;
    final deltaLatRad = (point2.latitude - point1.latitude) * pi / 180;
    final deltaLonRad = (point2.longitude - point1.longitude) * pi / 180;

    final a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLonRad / 2) * sin(deltaLonRad / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Розрахунок базової складності на основі параметрів
  double _calculateBaseDifficultyFromParameters({
    required double elevationGain,
    required double windEffect,
    required RoadSurfaceType surfaceType,
    required double distance,
    WeatherData? weatherData,
    required List<LatLng> coordinates,
  }) {
    double difficulty = 0.0;

    // Базовий фактор відстані
    difficulty += distance / 1000.0 * 0.1; // 0.1 на км

    // Фактор підйому
    difficulty += elevationGain / 100.0 * 0.5; // 0.5 на 100м підйому

    // Фактор покриття
    final surfaceFactor = _getBaseSurfaceFactor(surfaceType);
    difficulty *= surfaceFactor;

    // Фактор вітру
    if (weatherData != null && coordinates.isNotEmpty) {
      final routeBearing = _calculateRouteBearing(coordinates);
      final windImpact = _calculateWindEffect(weatherData, routeBearing);
      difficulty += windImpact;
    }

    // Фактор погоди на покриття
    if (weatherData != null) {
      difficulty *= _calculateSurfaceWeatherEffect(surfaceType, weatherData);
    }

    return difficulty.clamp(0.0, 10.0); // Обмежуємо до 0-10
  }

  /// Розрахунок середньої швидкості на основі складності та профілю
  double _calculateAverageSpeed({
    required double difficulty,
    required RoadSurfaceType surfaceType,
    required ProfileEntity profile,
  }) {
    // Базова швидкість залежно від профілю
    double baseSpeed = 15.0; // км/год за замовчуванням

    switch (profile.fitnessLevel.toLowerCase()) {
      case 'beginner':
        baseSpeed = 12.0;
        break;
      case 'intermediate':
        baseSpeed = 15.0;
        break;
      case 'advanced':
        baseSpeed = 18.0;
        break;
      case 'expert':
        baseSpeed = 22.0;
        break;
    }

    // Корекція на складність
    final difficultyFactor = 1.0 - (difficulty / 10.0) * 0.3; // До -30% при максимальній складності
    baseSpeed *= difficultyFactor;

    // Корекція на покриття
    final surfaceFactor = _getBaseSurfaceFactor(surfaceType);
    baseSpeed /= surfaceFactor;

    return baseSpeed.clamp(5.0, 30.0); // Обмежуємо до 5-30 км/год
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

    // 1. Розрахунок впливу вітру (векторний)
    if (weather != null) {
      final routeBearing = _calculateRouteBearing(section.coordinates);
      final windImpact = _calculateWindEffect(weather, routeBearing);
      difficulty += windImpact;
    }

    // 2. Розрахунок впливу покриття + дощу
    difficulty *= _calculateSurfaceWeatherEffect(section.surfaceType, weather);

    // 3. Розрахунок впливу підйому
    difficulty *= _calculateElevationFactor(section.elevationGain);

    return difficulty;
  }

  /// Розрахунок факторів погоди для детального аналізу
  List<DifficultyFactor> _calculateWeatherFactors(WeatherData weather, double routeBearing) {
    final factors = <DifficultyFactor>[];

    // Температура
    if (weather.temperature < 5.0) {
      factors.add(DifficultyFactor(
        name: 'Температура',
        description: 'Холодна погода - знижена продуктивність',
        impact: 0.1,
        category: 'weather',
        isPositive: false,
      ));
    } else if (weather.temperature > 30.0) {
      factors.add(DifficultyFactor(
        name: 'Температура',
        description: 'Спекотна погода - знижена витривалість',
        impact: 0.15,
        category: 'weather',
        isPositive: false,
      ));
    }

    // Вітер (векторний розрахунок)
    if (weather.windSpeed > 0) {
      final windImpact = _calculateWindEffect(weather, routeBearing);
      final windDirection = _getWindDirectionDescription(weather.windDirection, routeBearing);

      factors.add(DifficultyFactor(
        name: 'Вітер',
        description: '$windDirection - ${windImpact > 0 ? 'збільшує' : 'зменшує'} складність',
        impact: windImpact.abs(),
        category: 'weather',
        isPositive: windImpact < 0, // Негативний вплив = позитивний фактор
      ));
    }

    // Опади (тепер враховуються в покритті)
    if (weather.precipitation > 0) {
      factors.add(DifficultyFactor(
        name: 'Опади',
        description: 'Дощ впливає на покриття дороги',
        impact: weather.precipitation * 0.02,
        category: 'weather',
        isPositive: false,
      ));
    }

    // Видимість
    if (weather.visibility < 5.0) {
      factors.add(DifficultyFactor(
        name: 'Видимість',
        description: 'Погана видимість - знижена безпека',
        impact: 0.1,
        category: 'weather',
        isPositive: false,
      ));
    }

    return factors;
  }

  /// Отримання опису напрямку вітру відносно маршруту
  String _getWindDirectionDescription(double windDirection, double routeBearing) {
    double angleDifference = (routeBearing - windDirection).abs();
    if (angleDifference > 180) {
      angleDifference = 360 - angleDifference;
    }

    if (angleDifference <= 45) {
      return 'Попутний вітер';
    } else if (angleDifference <= 135) {
      return 'Боковий вітер';
    } else {
      return 'Зустрічний вітер';
    }
  }

  /// Розрахунок факторів покриття дороги для детального аналізу
  List<DifficultyFactor> _calculateSurfaceFactors(RoadSurfaceType surfaceType, WeatherData? weather) {
    final factors = <DifficultyFactor>[];

    // Базовий фактор покриття
    final baseFactor = _getBaseSurfaceFactor(surfaceType);
    final surfaceName = _getSurfaceName(surfaceType);

    if (baseFactor > 1.0) {
      factors.add(DifficultyFactor(
        name: 'Покриття',
        description: '$surfaceName - знижена швидкість',
        impact: baseFactor - 1.0,
        category: 'surface',
        isPositive: false,
      ));
    }

    // Вплив дощу на покриття
    if (weather != null && weather.precipitation > 0) {
      final rainEffect = _calculateSurfaceWeatherEffect(surfaceType, weather);
      final rainImpact = rainEffect - baseFactor;

      if (rainImpact.abs() > 0.01) {
        factors.add(DifficultyFactor(
          name: 'Дощ + Покриття',
          description: 'Дощ ${rainImpact > 0 ? 'погіршує' : 'покращує'} $surfaceName',
          impact: rainImpact.abs(),
          category: 'surface',
          isPositive: rainImpact < 0,
        ));
      }
    }

    return factors;
  }

  /// Отримання назви покриття
  String _getSurfaceName(RoadSurfaceType surfaceType) {
    switch (surfaceType) {
      case RoadSurfaceType.asphalt:
        return 'Асфальт';
      case RoadSurfaceType.concrete:
        return 'Бетон';
      case RoadSurfaceType.gravel:
        return 'Гравій';
      case RoadSurfaceType.dirt:
        return 'Ґрунт';
      case RoadSurfaceType.cobblestone:
        return 'Бруківка';
      case RoadSurfaceType.grass:
        return 'Трава';
      case RoadSurfaceType.sand:
        return 'Пісок';
    }
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

  /// Розрахунок впливу вітру з урахуванням бокового впливу
  double _calculateWindEffect(WeatherData weather, double routeBearing) {
    final windBearing = weather.windDirection;
    final windSpeed = weather.windSpeed;

    if (windSpeed == 0) return 0.0;

    // Розрахунок кута між напрямком вітру та напрямком руху
    double angleDifference = (routeBearing - windBearing).abs();
    if (angleDifference > 180) {
      angleDifference = 360 - angleDifference;
    }

    // Конвертуємо в радіани
    double angleRadians = angleDifference * (pi / 180);

    // Розрахунок ефективності вітру
    // cos(α) - 0.2×sin(α) враховує як попутний/зустрічний, так і боковий вплив
    double windEffectiveness = cos(angleRadians) - 0.2 * sin(angleRadians);

    // Розрахунок впливу на складність
    double windImpact = windSpeed * windEffectiveness * 0.02; // 2% на м/с

    return windImpact;
  }

  /// Розрахунок напрямку маршруту
  double _calculateRouteBearing(List<LatLng> coordinates) {
    if (coordinates.length < 2) return 0.0;

    final start = coordinates.first;
    final end = coordinates.last;

    final lat1 = start.latitude * (pi / 180);
    final lat2 = end.latitude * (pi / 180);
    final deltaLon = (end.longitude - start.longitude) * (pi / 180);

    final y = sin(deltaLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon);

    final bearing = atan2(y, x) * (180 / pi);
    return (bearing + 360) % 360; // Нормалізуємо до 0-360°
  }

  /// Розрахунок впливу покриття з урахуванням дощу
  double _calculateSurfaceWeatherEffect(RoadSurfaceType surface, WeatherData? weather) {
    double baseFactor = _getBaseSurfaceFactor(surface);
    double precipitation = weather?.precipitation ?? 0.0;

    if (precipitation == 0) {
      return baseFactor; // Без дощу - базовий фактор
    }

    switch (surface) {
      case RoadSurfaceType.sand:
        // Пісок під дощем стає кращим (щільнішим)
        return baseFactor * (1.0 - precipitation * 0.05); // -5% на мм дощу

      case RoadSurfaceType.dirt:
      case RoadSurfaceType.grass:
        // Ґрунт та трава стають гіршими (слизькими)
        return baseFactor * (1.0 + precipitation * 0.1); // +10% на мм дощу

      case RoadSurfaceType.gravel:
        // Гравій стає трохи гіршим
        return baseFactor * (1.0 + precipitation * 0.05); // +5% на мм дощу

      case RoadSurfaceType.asphalt:
      case RoadSurfaceType.concrete:
        // Асфальт та бетон майже не змінюються
        return baseFactor * (1.0 + precipitation * 0.02); // +2% на мм дощу

      case RoadSurfaceType.cobblestone:
        // Бруківка стає трохи гіршою
        return baseFactor * (1.0 + precipitation * 0.03); // +3% на мм дощу
    }
  }

  /// Базовий фактор покриття дороги
  double _getBaseSurfaceFactor(RoadSurfaceType surfaceType) {
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

  /// Отримання детальних факторів складності для секції
  List<DifficultyFactor> getDetailedComplexityFactors({
    required RouteSectionEntity section,
    WeatherData? weatherData,
  }) {
    final factors = <DifficultyFactor>[];

    // Розраховуємо напрямок маршруту
    final routeBearing = _calculateRouteBearing(section.coordinates);

    // Фактори погоди (з векторним розрахунком вітру)
    if (weatherData != null) {
      factors.addAll(_calculateWeatherFactors(weatherData, routeBearing));
    }

    // Фактори покриття (з урахуванням дощу)
    factors.addAll(_calculateSurfaceFactors(section.surfaceType, weatherData));

    // Фактори підйому
    if (section.elevationGain > 50) {
      factors.add(DifficultyFactor(
        name: 'Підйом',
        description: 'Підйом ${section.elevationGain.toStringAsFixed(0)}м - збільшена складність',
        impact: (section.elevationGain / 100) * 0.1,
        category: 'elevation',
        isPositive: false,
      ));
    }

    return factors;
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

  /// Збереження результатів розрахунку в локальному кеші
  Future<void> _cacheComplexityResult(String routeId, PersonalizedDifficultyResult result) async {
    try {
      final cacheData = {
        'routeId': routeId,
        'result': {
          'baseDifficulty': result.baseDifficulty,
          'personalizedDifficulty': result.personalizedDifficulty,
          'personalizationFactor': result.personalizationFactor,
          'difficultyLevel': result.difficultyLevel,
          'difficultyColor': result.difficultyColor,
          'factors': result.factors
              .map((f) => {
                    'name': f.name,
                    'description': f.description,
                    'impact': f.impact,
                    'category': f.category,
                    'isPositive': f.isPositive,
                  })
              .toList(),
          'calculatedAt': result.calculatedAt?.toIso8601String(),
        },
        'cachedAt': DateTime.now().toIso8601String(),
      };

      await _localStorage.saveComplexityData(routeId, cacheData);
      LogService.log('RouteComplexityService: Complexity result cached for route: $routeId');
    } catch (e) {
      LogService.log('RouteComplexityService: Failed to cache complexity result: $e');
    }
  }

  /// Отримання результатів з локального кешу
  PersonalizedDifficultyResult? _getCachedComplexityResult(String routeId) {
    try {
      final cacheData = _localStorage.getComplexityData(routeId);
      if (cacheData == null) return null;

      final result = cacheData['result'] as Map<String, dynamic>;
      final factors = (result['factors'] as List)
          .map((f) => DifficultyFactor(
                name: f['name'],
                description: f['description'],
                impact: f['impact'],
                category: f['category'],
                isPositive: f['isPositive'],
              ))
          .toList();

      return PersonalizedDifficultyResult(
        baseDifficulty: result['baseDifficulty'],
        personalizedDifficulty: result['personalizedDifficulty'],
        personalizationFactor: result['personalizationFactor'],
        difficultyLevel: result['difficultyLevel'],
        difficultyColor: result['difficultyColor'],
        factors: factors,
        calculatedAt: result['calculatedAt'] != null ? DateTime.parse(result['calculatedAt']) : null,
      );
    } catch (e) {
      LogService.log('RouteComplexityService: Failed to get cached complexity result: $e');
      return null;
    }
  }

  /// Перевірка чи кеш актуальний (не старіший 1 години)
  bool _isCacheValid(String routeId) {
    try {
      final cacheData = _localStorage.getComplexityData(routeId);
      if (cacheData == null) return false;

      final cachedAt = DateTime.parse(cacheData['cachedAt']);
      final now = DateTime.now();
      final difference = now.difference(cachedAt);

      return difference.inHours < 1; // Кеш актуальний 1 годину
    } catch (e) {
      LogService.log('RouteComplexityService: Failed to check cache validity: $e');
      return false;
    }
  }
}
