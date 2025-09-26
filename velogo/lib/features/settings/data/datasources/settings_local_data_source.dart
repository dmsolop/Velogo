import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velogo/core/error/exceptions.dart';
import 'package:velogo/features/settings/data/models/settings_model.dart';

/// Абстрактний локальний джерело даних для налаштувань
/// 
/// Функціональність:
/// - Визначає контракт для роботи з локальним сховищем налаштувань
/// - Надає методи для збереження та отримання налаштувань
/// - Використовує SharedPreferences для персистентності
/// - Слідує Clean Architecture принципам
/// 
/// Використовується в: SettingsLocalDataSourceImpl, SettingsRepositoryImpl
abstract class SettingsLocalDataSource {
  /// Отримання налаштувань з локального сховища
  /// Повертає: SettingsModel - налаштування або дефолтні значення
  Future<SettingsModel> getSettings();
  
  /// Збереження налаштувань в локальне сховище
  /// Параметри: settings - налаштування для збереження
  Future<void> saveSettings(SettingsModel settings);
  
  /// Оновлення голосових інструкцій
  /// Параметри: value - нове значення (true/false)
  Future<void> updateVoiceInstructions(bool value);
  
  /// Оновлення одиниць вимірювання
  /// Параметри: value - нові одиниці (metric/imperial)
  Future<void> updateUnitsOfMeasurement(String value);
  
  /// Оновлення стилю карти
  /// Параметри: value - новий стиль карти
  Future<void> updateMapStyle(String value);
  
  /// Оновлення загальних сповіщень
  /// Параметри: value - нове значення (true/false)
  Future<void> updateNotifications(bool value);
  
  /// Оновлення сповіщень про маршрути
  /// Параметри: value - нове значення (true/false)
  Future<void> updateRouteAlerts(bool value);
  
  /// Оновлення сповіщень про погоду
  /// Параметри: value - нове значення (true/false)
  Future<void> updateWeatherAlerts(bool value);
  
  /// Оновлення загальних сповіщень
  /// Параметри: value - нове значення (true/false)
  Future<void> updateGeneralNotifications(bool value);
  
  /// Оновлення інтеграції з даними здоров'я
  /// Параметри: value - нове значення (true/false)
  Future<void> updateHealthDataIntegration(bool value);
  
  /// Оновлення налаштування перетягування маршрутів
  /// Параметри: value - нове значення (true/false)
  Future<void> updateRouteDragging(bool value);
  
  /// Оновлення профілю маршрутизації
  /// Параметри: value - новий профіль (cycling-regular, driving-car, foot-walking)
  Future<void> updateRouteProfile(String value);
}

/// Реалізація локального джерела даних для налаштувань
/// 
/// Функціональність:
/// - Реалізує роботу з SharedPreferences для збереження налаштувань
/// - Обробляє JSON серіалізацію/десеріалізацію налаштувань
/// - Надає дефолтні значення при відсутності збережених налаштувань
/// - Викидає CacheException при помилках
/// 
/// Використовується в: SettingsRepositoryImpl через Dependency Injection
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String settingsKey = 'settings';

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final jsonString = sharedPreferences.getString(settingsKey);
      if (jsonString != null) {
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        return SettingsModel.fromJson(jsonMap);
      } else {
        return const SettingsModel(); // Return default settings
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      final jsonString = json.encode(settings.toJson());
      await sharedPreferences.setString(settingsKey, jsonString);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateVoiceInstructions(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(voiceInstructions: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateUnitsOfMeasurement(String value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(unitsOfMeasurement: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateMapStyle(String value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(mapStyle: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateNotifications(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(notifications: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateRouteAlerts(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(routeAlerts: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateWeatherAlerts(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(weatherAlerts: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateGeneralNotifications(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(generalNotifications: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateHealthDataIntegration(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(healthDataIntegration: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateRouteDragging(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(routeDragging: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateRouteProfile(String value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(routeProfile: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }
}
