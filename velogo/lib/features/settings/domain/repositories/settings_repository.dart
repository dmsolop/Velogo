import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/features/settings/domain/entities/settings_entity.dart';

/// Абстрактний репозиторій для управління налаштуваннями додатку
/// 
/// Функціональність:
/// - Визначає контракт для роботи з налаштуваннями
/// - Надає методи для отримання, збереження та оновлення налаштувань
/// - Використовує Either<Failure, T> для обробки помилок
/// - Слідує Clean Architecture принципам
/// 
/// Використовується в: SettingsRepositoryImpl, Use Cases
abstract class SettingsRepository {
  /// Отримання поточних налаштувань
  /// Повертає: Either<Failure, SettingsEntity> - налаштування або помилку
  Future<Either<Failure, SettingsEntity>> getSettings();
  
  /// Збереження налаштувань
  /// Параметри: settings - налаштування для збереження
  /// Повертає: Either<Failure, Unit> - результат операції
  Future<Either<Failure, Unit>> saveSettings(SettingsEntity settings);
  
  /// Оновлення голосових інструкцій
  /// Параметри: value - нове значення (true/false)
  Future<Either<Failure, Unit>> updateVoiceInstructions(bool value);
  
  /// Оновлення одиниць вимірювання
  /// Параметри: value - нові одиниці (metric/imperial)
  Future<Either<Failure, Unit>> updateUnitsOfMeasurement(String value);
  
  /// Оновлення стилю карти
  /// Параметри: value - новий стиль карти
  Future<Either<Failure, Unit>> updateMapStyle(String value);
  
  /// Оновлення загальних сповіщень
  /// Параметри: value - нове значення (true/false)
  Future<Either<Failure, Unit>> updateNotifications(bool value);
  
  /// Оновлення сповіщень про маршрути
  /// Параметри: value - нове значення (true/false)
  Future<Either<Failure, Unit>> updateRouteAlerts(bool value);
  
  /// Оновлення сповіщень про погоду
  /// Параметри: value - нове значення (true/false)
  Future<Either<Failure, Unit>> updateWeatherAlerts(bool value);
  
  /// Оновлення загальних сповіщень
  /// Параметри: value - нове значення (true/false)
  Future<Either<Failure, Unit>> updateGeneralNotifications(bool value);
  
  /// Оновлення інтеграції з даними здоров'я
  /// Параметри: value - нове значення (true/false)
  Future<Either<Failure, Unit>> updateHealthDataIntegration(bool value);
  
  /// Оновлення налаштування перетягування маршрутів
  /// Параметри: value - нове значення (true/false)
  Future<Either<Failure, Unit>> updateRouteDragging(bool value);
  
  /// Оновлення профілю маршрутизації
  /// Параметри: value - новий профіль (cycling-regular, driving-car, foot-walking)
  Future<Either<Failure, Unit>> updateRouteProfile(String value);
}
