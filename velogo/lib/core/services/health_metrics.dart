import 'package:freezed_annotation/freezed_annotation.dart';
import '../../features/map/domain/entities/route_entity.dart';

part 'health_metrics.freezed.dart';
part 'health_metrics.g.dart';

/// Модель для health-метрик з нативних додатків
@freezed
class HealthMetrics with _$HealthMetrics {
  const factory HealthMetrics({
    // Серцево-судинні показники
    int? restingHeartRate, // Пульс спокою (BPM)
    int? maxHeartRate, // Максимальний пульс
    double? bloodPressure, // Тиск (систолічний)
    int? heartRateVariability, // Варіабельність пульсу

    // Фізична активність
    int? dailySteps, // Кроки за день
    double? activeMinutes, // Активні хвилини
    double? caloriesBurned, // Спалені калорії
    String? activityLevel, // Рівень активності

    // Відновлення та втома
    double? sleepQuality, // Якість сну (0-1)
    int? sleepDuration, // Тривалість сну (хвилини)
    double? stressLevel, // Рівень стресу (0-1)
    double? recoveryScore, // Оцінка відновлення (0-1)

    // Метадані
    DateTime? lastUpdated, // Час останнього оновлення
    String? source, // Джерело даних (HealthKit, Google Fit)
  }) = _HealthMetrics;

  factory HealthMetrics.fromJson(Map<String, dynamic> json) => _$HealthMetricsFromJson(json);
}

/// Результат розрахунку персоналізованої складності
@freezed
class PersonalizedDifficultyResult with _$PersonalizedDifficultyResult {
  const factory PersonalizedDifficultyResult({
    required double baseDifficulty, // Базова складність
    required double personalizedDifficulty, // Персоналізована складність
    required double personalizationFactor, // Коефіцієнт персоналізації
    required List<DifficultyFactor> factors, // Фактори впливу
    required String difficultyLevel, // Рівень складності (текст)
    required int difficultyColor, // Колір складності
    DateTime? calculatedAt, // Час розрахунку
  }) = _PersonalizedDifficultyResult;

  factory PersonalizedDifficultyResult.fromJson(Map<String, dynamic> json) => _$PersonalizedDifficultyResultFromJson(json);
}

/// Фактор впливу на складність
@freezed
class DifficultyFactor with _$DifficultyFactor {
  const factory DifficultyFactor({
    required String name, // Назва фактора
    required String description, // Опис впливу
    required double impact, // Вплив на складність (-1.0 до 1.0)
    required String category, // Категорія (age, fitness, health, weather, terrain)
    required bool isPositive, // Чи позитивний вплив (зменшує складність)
  }) = _DifficultyFactor;

  factory DifficultyFactor.fromJson(Map<String, dynamic> json) => _$DifficultyFactorFromJson(json);
}

/// Рівні складності
enum DifficultyLevel {
  easy('Легкий', 0xFF4CAF50),
  moderate('Помірний', 0xFFFF9800),
  hard('Складний', 0xFFFF5722),
  veryHard('Дуже складний', 0xFF9C27B0),
  extreme('Екстремальний', 0xFF000000);

  const DifficultyLevel(this.displayName, this.color);
  final String displayName;
  final int color;
}

/// Параметри секції маршруту
/// 
/// Містить всі розраховані параметри для однієї секції маршруту
@freezed
class SectionParameters with _$SectionParameters {
  const factory SectionParameters({
    required double elevationGain,      // Набір висоти в метрах
    required double windEffect,          // Вплив вітру (може бути негативним для попутного)
    required RoadSurfaceType surfaceType, // Тип покриття дороги
    required double difficulty,          // Складність секції (0-10)
    required double averageSpeed,         // Середня швидкість км/год
    required double distance,             // Відстань секції в метрах
  }) = _SectionParameters;

  factory SectionParameters.fromJson(Map<String, dynamic> json) => _$SectionParametersFromJson(json);
}
