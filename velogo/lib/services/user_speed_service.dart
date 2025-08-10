import 'dart:convert';
import 'package:hive/hive.dart';
import '../features/weather/data/models/weather_data.dart';
import '../features/map/data/models/road_surface.dart';
import '../features/map/data/datasources/route_difficulty_service.dart';
import 'log_service.dart';

/// Модель для збереження статистики швидкості користувача
class UserSpeedStats {
  final String userId;
  final double averageSpeed; // км/год
  final Map<String, double> speedByDifficulty; // Швидкість за рівнем складності
  final Map<String, double> speedBySurface; // Швидкість за типом покриття
  final int totalRides;
  final DateTime lastUpdated;
  final DateTime createdAt;

  UserSpeedStats({
    required this.userId,
    required this.averageSpeed,
    required this.speedByDifficulty,
    required this.speedBySurface,
    required this.totalRides,
    required this.lastUpdated,
    required this.createdAt,
  });

  /// Створення з JSON
  factory UserSpeedStats.fromJson(Map<String, dynamic> json) {
    return UserSpeedStats(
      userId: json['userId'],
      averageSpeed: json['averageSpeed']?.toDouble() ?? 15.0,
      speedByDifficulty: Map<String, double>.from(json['speedByDifficulty'] ?? {}),
      speedBySurface: Map<String, double>.from(json['speedBySurface'] ?? {}),
      totalRides: json['totalRides'] ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Конвертація в JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'averageSpeed': averageSpeed,
      'speedByDifficulty': speedByDifficulty,
      'speedBySurface': speedBySurface,
      'totalRides': totalRides,
      'lastUpdated': lastUpdated.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Копіювання з новими значеннями
  UserSpeedStats copyWith({
    String? userId,
    double? averageSpeed,
    Map<String, double>? speedByDifficulty,
    Map<String, double>? speedBySurface,
    int? totalRides,
    DateTime? lastUpdated,
    DateTime? createdAt,
  }) {
    return UserSpeedStats(
      userId: userId ?? this.userId,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      speedByDifficulty: speedByDifficulty ?? this.speedByDifficulty,
      speedBySurface: speedBySurface ?? this.speedBySurface,
      totalRides: totalRides ?? this.totalRides,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Сервіс для відстеження та розрахунку індивідуальних швидкостей користувача
class UserSpeedService {
  static final UserSpeedService _instance = UserSpeedService._internal();
  factory UserSpeedService() => _instance;
  UserSpeedService._internal();

  final Map<String, UserSpeedStats> _userStats = {};
  final String _statsBoxName = "user_speed_stats";
  final RouteDifficultyService _routeDifficultyService = RouteDifficultyService();

  /// Отримання середньої швидкості користувача для конкретної складності
  double getUserSpeedForDifficulty(String userId, double difficulty) {
    try {
      final stats = _userStats[userId];
      if (stats == null) {
        LogService.log('⚠️ [UserSpeedService] Статистика не знайдена для користувача: $userId');
        return 15.0; // Швидкість за замовчуванням
      }

      // Визначаємо рівень складності
      final difficultyLevel = _routeDifficultyService.getDifficultyLevel(difficulty);
      final speedForDifficulty = stats.speedByDifficulty[difficultyLevel];

      if (speedForDifficulty != null) {
        LogService.log('🏃 [UserSpeedService] Швидкість для складності $difficultyLevel: ${speedForDifficulty}км/год');
        return speedForDifficulty;
      }

      // Якщо немає даних для цієї складності, використовуємо загальну середню
      LogService.log('🏃 [UserSpeedService] Використовуємо загальну середню швидкість: ${stats.averageSpeed}км/год');
      return stats.averageSpeed;
    } catch (e) {
      LogService.log('❌ [UserSpeedService] Помилка отримання швидкості: $e');
      return 15.0;
    }
  }

  /// Отримання середньої швидкості користувача для конкретного типу покриття
  double getUserSpeedForSurface(String userId, RoadSurface surface) {
    try {
      final stats = _userStats[userId];
      if (stats == null) {
        LogService.log('⚠️ [UserSpeedService] Статистика не знайдена для користувача: $userId');
        return 15.0;
      }

      final surfaceKey = surface.displayName;
      final speedForSurface = stats.speedBySurface[surfaceKey];

      if (speedForSurface != null) {
        LogService.log('🏃 [UserSpeedService] Швидкість для покриття $surfaceKey: ${speedForSurface}км/год');
        return speedForSurface;
      }

      LogService.log('🏃 [UserSpeedService] Використовуємо загальну середню швидкість: ${stats.averageSpeed}км/год');
      return stats.averageSpeed;
    } catch (e) {
      LogService.log('❌ [UserSpeedService] Помилка отримання швидкості для покриття: $e');
      return 15.0;
    }
  }

  /// Оновлення статистики користувача після завершення маршруту
  Future<void> updateUserStats(
    String userId,
    List<Map<String, double>> routePoints,
    List<WeatherData> weatherData,
    List<RoadSurface> roadSurfaces,
    double actualAverageSpeed,
    Duration rideDuration,
  ) async {
    try {
      LogService.log('📊 [UserSpeedService] Оновлення статистики для користувача: $userId');

      final stats = _userStats[userId] ?? _createDefaultStats(userId);

      // Розраховуємо складність для кожної точки
      final difficulties = <double>[];
      for (int i = 0; i < routePoints.length; i++) {
        final weather = i < weatherData.length ? weatherData[i] : weatherData.last;
        final surface = i < roadSurfaces.length ? roadSurfaces[i] : RoadSurface.asphalt;

        final difficulty = _routeDifficultyService.calculateRouteDifficulty(
          [weather],
          [surface],
          [routePoints[i]],
          DateTime.now(),
        );
        difficulties.add(difficulty);
      }

      // Оновлюємо статистику
      final updatedStats = _updateStats(stats, difficulties, roadSurfaces, actualAverageSpeed);
      _userStats[userId] = updatedStats;

      // Зберігаємо в кеш
      await _saveStatsToCache();

      LogService.log('✅ [UserSpeedService] Статистика оновлена: середня швидкість=${updatedStats.averageSpeed}км/год, поїздок=${updatedStats.totalRides}');
    } catch (e) {
      LogService.log('❌ [UserSpeedService] Помилка оновлення статистики: $e');
    }
  }

  /// Створення статистики за замовчуванням
  UserSpeedStats _createDefaultStats(String userId) {
    return UserSpeedStats(
      userId: userId,
      averageSpeed: 15.0,
      speedByDifficulty: {
        'Легкий': 18.0,
        'Помірний': 15.0,
        'Складний': 12.0,
        'Дуже складний': 9.0,
        'Екстремальний': 6.0,
      },
      speedBySurface: {
        'Асфальт': 18.0,
        'Бетон': 17.0,
        'Гравій': 14.0,
        'Ґрунт': 12.0,
        'Багно': 8.0,
      },
      totalRides: 0,
      lastUpdated: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  /// Оновлення статистики на основі нових даних
  UserSpeedStats _updateStats(
    UserSpeedStats stats,
    List<double> difficulties,
    List<RoadSurface> roadSurfaces,
    double actualAverageSpeed,
  ) {
    // Оновлюємо загальну середню швидкість
    final newAverageSpeed = _calculateWeightedAverage(
      stats.averageSpeed,
      actualAverageSpeed,
      stats.totalRides,
    );

    // Оновлюємо швидкість за складністю
    final updatedSpeedByDifficulty = Map<String, double>.from(stats.speedByDifficulty);
    for (final difficulty in difficulties) {
      final difficultyLevel = _routeDifficultyService.getDifficultyLevel(difficulty);
      final currentSpeed = updatedSpeedByDifficulty[difficultyLevel] ?? stats.averageSpeed;
      final newSpeed = _calculateWeightedAverage(currentSpeed, actualAverageSpeed, 1);
      updatedSpeedByDifficulty[difficultyLevel] = newSpeed;
    }

    // Оновлюємо швидкість за покриттям
    final updatedSpeedBySurface = Map<String, double>.from(stats.speedBySurface);
    for (final surface in roadSurfaces) {
      final surfaceKey = surface.displayName;
      final currentSpeed = updatedSpeedBySurface[surfaceKey] ?? stats.averageSpeed;
      final newSpeed = _calculateWeightedAverage(currentSpeed, actualAverageSpeed, 1);
      updatedSpeedBySurface[surfaceKey] = newSpeed;
    }

    return stats.copyWith(
      averageSpeed: newAverageSpeed,
      speedByDifficulty: updatedSpeedByDifficulty,
      speedBySurface: updatedSpeedBySurface,
      totalRides: stats.totalRides + 1,
      lastUpdated: DateTime.now(),
    );
  }

  /// Розрахунок зваженої середньої
  double _calculateWeightedAverage(double currentAverage, double newValue, int currentCount) {
    if (currentCount == 0) return newValue;

    // Використовуємо експоненціальне згладжування
    const double alpha = 0.3; // Коефіцієнт згладжування
    return currentAverage * (1 - alpha) + newValue * alpha;
  }

  /// Періодичне оновлення статистики (викликається автоматично)
  Future<void> periodicUpdate() async {
    try {
      LogService.log('🔄 [UserSpeedService] Періодичне оновлення статистики');

      for (final stats in _userStats.values) {
        // Перевіряємо чи потрібно оновлення (раз на тиждень)
        final daysSinceUpdate = DateTime.now().difference(stats.lastUpdated).inDays;
        if (daysSinceUpdate >= 7) {
          // Тут можна додати логіку для автоматичного оновлення
          // Наприклад, зменшення ваги старих даних
          LogService.log('📊 [UserSpeedService] Автоматичне оновлення для користувача: ${stats.userId}');
        }
      }

      await _saveStatsToCache();
    } catch (e) {
      LogService.log('❌ [UserSpeedService] Помилка періодичного оновлення: $e');
    }
  }

  /// Збереження статистики в кеш
  Future<void> _saveStatsToCache() async {
    try {
      final box = await Hive.openBox<String>(_statsBoxName);

      for (final stats in _userStats.values) {
        await box.put(stats.userId, jsonEncode(stats.toJson()));
      }

      LogService.log('💾 [UserSpeedService] Статистика збережена в кеш');
    } catch (e) {
      LogService.log('❌ [UserSpeedService] Помилка збереження статистики: $e');
    }
  }

  /// Завантаження статистики з кешу
  Future<void> _loadStatsFromCache() async {
    try {
      final box = await Hive.openBox<String>(_statsBoxName);

      for (final key in box.keys) {
        final statsJson = jsonDecode(box.get(key)!);
        final stats = UserSpeedStats.fromJson(statsJson);
        _userStats[stats.userId] = stats;
      }

      LogService.log('📦 [UserSpeedService] Статистика завантажена з кешу: ${_userStats.length} користувачів');
    } catch (e) {
      LogService.log('❌ [UserSpeedService] Помилка завантаження статистики: $e');
    }
  }

  /// Ініціалізація сервісу
  Future<void> initialize() async {
    await _loadStatsFromCache();
  }

  /// Отримання статистики користувача
  UserSpeedStats? getUserStats(String userId) {
    return _userStats[userId];
  }

  /// Очищення статистики користувача
  Future<void> clearUserStats(String userId) async {
    _userStats.remove(userId);
    final box = await Hive.openBox<String>(_statsBoxName);
    await box.delete(userId);
    LogService.log('🗑️ [UserSpeedService] Статистика очищена для користувача: $userId');
  }
}
