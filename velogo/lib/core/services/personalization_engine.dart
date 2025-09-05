import 'dart:math';
import 'health_metrics.dart';
import '../../features/profile/domain/entities/profile_entity.dart';
import '../../features/weather/data/models/weather_data.dart';
import '../../features/map/data/models/road_surface.dart';
import '../services/log_service.dart';

/// Двигун персоналізації для розрахунку індивідуальної складності маршруту
class PersonalizationEngine {
  static final PersonalizationEngine _instance = PersonalizationEngine._internal();
  factory PersonalizationEngine() => _instance;
  PersonalizationEngine._internal();

  /// Розрахунок персоналізованої складності на основі профілю та health-метрик
  PersonalizedDifficultyResult calculatePersonalizedDifficulty({
    required double baseDifficulty,
    required ProfileEntity profile,
    HealthMetrics? healthMetrics,
    WeatherData? currentWeather,
    RoadSurface? currentSurface,
  }) {
    try {
      LogService.log('🎯 [PersonalizationEngine] Розрахунок персоналізованої складності');
      LogService.log('📊 [PersonalizationEngine] Базова складність: $baseDifficulty');
      LogService.log('👤 [PersonalizationEngine] Профіль: ${profile.fitnessLevel}, вік: ${profile.age}');

      final factors = <DifficultyFactor>[];
      double personalizationFactor = 1.0;

      // 1. Фактори профілю користувача
      final profileFactors = _calculateProfileFactors(profile);
      factors.addAll(profileFactors);
      personalizationFactor *= _getProfileMultiplier(profileFactors);

      // 2. Фактори health-метрик
      if (healthMetrics != null) {
        final healthFactors = _calculateHealthFactors(healthMetrics);
        factors.addAll(healthFactors);
        personalizationFactor *= _getHealthMultiplier(healthFactors);
      }

      // 3. Фактори поточної погоди
      if (currentWeather != null) {
        final weatherFactors = _calculateWeatherFactors(currentWeather);
        factors.addAll(weatherFactors);
        personalizationFactor *= _getWeatherMultiplier(weatherFactors);
      }

      // 4. Фактори покриття дороги
      if (currentSurface != null) {
        final surfaceFactors = _calculateSurfaceFactors(currentSurface);
        factors.addAll(surfaceFactors);
        personalizationFactor *= _getSurfaceMultiplier(surfaceFactors);
      }

      final personalizedDifficulty = baseDifficulty * personalizationFactor;
      final difficultyLevel = _getDifficultyLevel(personalizedDifficulty);
      final difficultyColor = difficultyLevel.color;

      LogService.log('✅ [PersonalizationEngine] Результат: $personalizedDifficulty (фактор: $personalizationFactor)');

      return PersonalizedDifficultyResult(
        baseDifficulty: baseDifficulty,
        personalizedDifficulty: personalizedDifficulty,
        personalizationFactor: personalizationFactor,
        factors: factors,
        difficultyLevel: difficultyLevel.displayName,
        difficultyColor: difficultyColor,
        calculatedAt: DateTime.now(),
      );
    } catch (e) {
      LogService.log('❌ [PersonalizationEngine] Помилка розрахунку: $e');
      // Повертаємо базову складність у разі помилки
      return PersonalizedDifficultyResult(
        baseDifficulty: baseDifficulty,
        personalizedDifficulty: baseDifficulty,
        personalizationFactor: 1.0,
        factors: [],
        difficultyLevel: _getDifficultyLevel(baseDifficulty).displayName,
        difficultyColor: _getDifficultyLevel(baseDifficulty).color,
        calculatedAt: DateTime.now(),
      );
    }
  }

  /// Розрахунок факторів профілю користувача
  List<DifficultyFactor> _calculateProfileFactors(ProfileEntity profile) {
    final factors = <DifficultyFactor>[];

    // Вік
    if (profile.age > 0) {
      if (profile.age > 50) {
        factors.add(DifficultyFactor(
          name: 'Вік',
          description: 'Вік понад 50 років зменшує витривалість',
          impact: 0.2,
          category: 'age',
          isPositive: false,
        ));
      } else if (profile.age < 25) {
        factors.add(DifficultyFactor(
          name: 'Вік',
          description: 'Молодий вік підвищує витривалість',
          impact: -0.1,
          category: 'age',
          isPositive: true,
        ));
      }
    }

    // Рівень фітнесу
    switch (profile.fitnessLevel.toLowerCase()) {
      case 'beginner':
        factors.add(DifficultyFactor(
          name: 'Рівень фітнесу',
          description: 'Початківець - знижена витривалість',
          impact: 0.3,
          category: 'fitness',
          isPositive: false,
        ));
        break;
      case 'intermediate':
        factors.add(DifficultyFactor(
          name: 'Рівень фітнесу',
          description: 'Середній рівень - помірна витривалість',
          impact: 0.1,
          category: 'fitness',
          isPositive: false,
        ));
        break;
      case 'advanced':
        factors.add(DifficultyFactor(
          name: 'Рівень фітнесу',
          description: 'Просунутий рівень - висока витривалість',
          impact: -0.1,
          category: 'fitness',
          isPositive: true,
        ));
        break;
      case 'expert':
        factors.add(DifficultyFactor(
          name: 'Рівень фітнесу',
          description: 'Експертний рівень - максимальна витривалість',
          impact: -0.2,
          category: 'fitness',
          isPositive: true,
        ));
        break;
    }

    // Досвід (кількість поїздок)
    if (profile.totalRides > 100) {
      factors.add(DifficultyFactor(
        name: 'Досвід',
        description: 'Великий досвід велосипедиста',
        impact: -0.15,
        category: 'experience',
        isPositive: true,
      ));
    } else if (profile.totalRides < 10) {
      factors.add(DifficultyFactor(
        name: 'Досвід',
        description: 'Малий досвід велосипедиста',
        impact: 0.2,
        category: 'experience',
        isPositive: false,
      ));
    }

    return factors;
  }

  /// Розрахунок факторів health-метрик
  List<DifficultyFactor> _calculateHealthFactors(HealthMetrics health) {
    final factors = <DifficultyFactor>[];

    // Пульс спокою
    if (health.restingHeartRate != null) {
      if (health.restingHeartRate! > 80) {
        factors.add(DifficultyFactor(
          name: 'Пульс спокою',
          description: 'Високий пульс спокою - знижена витривалість',
          impact: 0.2,
          category: 'health',
          isPositive: false,
        ));
      } else if (health.restingHeartRate! < 60) {
        factors.add(DifficultyFactor(
          name: 'Пульс спокою',
          description: 'Низький пульс спокою - висока витривалість',
          impact: -0.1,
          category: 'health',
          isPositive: true,
        ));
      }
    }

    // Якість сну
    if (health.sleepQuality != null) {
      if (health.sleepQuality! < 0.6) {
        factors.add(DifficultyFactor(
          name: 'Якість сну',
          description: 'Погана якість сну - знижена продуктивність',
          impact: 0.15,
          category: 'health',
          isPositive: false,
        ));
      } else if (health.sleepQuality! > 0.8) {
        factors.add(DifficultyFactor(
          name: 'Якість сну',
          description: 'Відмінна якість сну - підвищена продуктивність',
          impact: -0.1,
          category: 'health',
          isPositive: true,
        ));
      }
    }

    // Рівень стресу
    if (health.stressLevel != null) {
      if (health.stressLevel! > 0.7) {
        factors.add(DifficultyFactor(
          name: 'Рівень стресу',
          description: 'Високий рівень стресу - знижена концентрація',
          impact: 0.1,
          category: 'health',
          isPositive: false,
        ));
      }
    }

    // Оцінка відновлення
    if (health.recoveryScore != null) {
      if (health.recoveryScore! < 0.5) {
        factors.add(DifficultyFactor(
          name: 'Відновлення',
          description: 'Низька оцінка відновлення - знижена готовність',
          impact: 0.2,
          category: 'health',
          isPositive: false,
        ));
      } else if (health.recoveryScore! > 0.8) {
        factors.add(DifficultyFactor(
          name: 'Відновлення',
          description: 'Висока оцінка відновлення - підвищена готовність',
          impact: -0.15,
          category: 'health',
          isPositive: true,
        ));
      }
    }

    return factors;
  }

  /// Розрахунок факторів погоди
  List<DifficultyFactor> _calculateWeatherFactors(WeatherData weather) {
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

  /// Розрахунок факторів покриття дороги
  List<DifficultyFactor> _calculateSurfaceFactors(RoadSurface surface) {
    final factors = <DifficultyFactor>[];

    // Різні типи покриття мають різний вплив
    switch (surface) {
      case RoadSurface.gravel:
        factors.add(DifficultyFactor(
          name: 'Покриття',
          description: 'Гравій - знижена швидкість',
          impact: 0.1,
          category: 'surface',
          isPositive: false,
        ));
        break;
      case RoadSurface.dirt:
        factors.add(DifficultyFactor(
          name: 'Покриття',
          description: 'Ґрунт - значно знижена швидкість',
          impact: 0.2,
          category: 'surface',
          isPositive: false,
        ));
        break;
      case RoadSurface.mud:
        factors.add(DifficultyFactor(
          name: 'Покриття',
          description: 'Багно - критична складність',
          impact: 0.3,
          category: 'surface',
          isPositive: false,
        ));
        break;
      default:
        // Асфальт, бетон - без додаткового впливу
        break;
    }

    return factors;
  }

  /// Отримання множника профілю
  double _getProfileMultiplier(List<DifficultyFactor> factors) {
    double multiplier = 1.0;
    for (final factor in factors) {
      if (factor.category == 'age' || factor.category == 'fitness' || factor.category == 'experience') {
        multiplier += factor.impact;
      }
    }
    return max(0.5, min(2.0, multiplier)); // Обмежуємо діапазон
  }

  /// Отримання множника health-метрик
  double _getHealthMultiplier(List<DifficultyFactor> factors) {
    double multiplier = 1.0;
    for (final factor in factors) {
      if (factor.category == 'health') {
        multiplier += factor.impact;
      }
    }
    return max(0.5, min(2.0, multiplier)); // Обмежуємо діапазон
  }

  /// Отримання множника погоди
  double _getWeatherMultiplier(List<DifficultyFactor> factors) {
    double multiplier = 1.0;
    for (final factor in factors) {
      if (factor.category == 'weather') {
        multiplier += factor.impact;
      }
    }
    return max(0.5, min(2.0, multiplier)); // Обмежуємо діапазон
  }

  /// Отримання множника покриття
  double _getSurfaceMultiplier(List<DifficultyFactor> factors) {
    double multiplier = 1.0;
    for (final factor in factors) {
      if (factor.category == 'surface') {
        multiplier += factor.impact;
      }
    }
    return max(0.5, min(2.0, multiplier)); // Обмежуємо діапазон
  }

  /// Визначення рівня складності
  DifficultyLevel _getDifficultyLevel(double difficulty) {
    if (difficulty < 2.0) return DifficultyLevel.easy;
    if (difficulty < 4.0) return DifficultyLevel.moderate;
    if (difficulty < 6.0) return DifficultyLevel.hard;
    if (difficulty < 8.0) return DifficultyLevel.veryHard;
    return DifficultyLevel.extreme;
  }
}
