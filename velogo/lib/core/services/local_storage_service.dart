import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../services/log_service.dart';

/// Сервіс для локального зберігання даних з використанням Hive
class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static const String _weatherBoxName = 'weather_data';
  static const String _routeBoxName = 'route_data';
  static const String _complexityBoxName = 'complexity_data';
  static const String _userBoxName = 'user_data';

  late Box _weatherBox;
  late Box _routeBox;
  late Box _complexityBox;
  late Box _userBox;

  /// Ініціалізація Hive та створення боксів
  Future<void> init() async {
    try {
      // Ініціалізація Hive
      await Hive.initFlutter();

      // Отримання директорії для зберігання
      final directory = await getApplicationDocumentsDirectory();
      LogService.log('LocalStorageService: Hive directory: ${directory.path}');

      // Відкриття боксів
      _weatherBox = await Hive.openBox(_weatherBoxName);
      _routeBox = await Hive.openBox(_routeBoxName);
      _complexityBox = await Hive.openBox(_complexityBoxName);
      _userBox = await Hive.openBox(_userBoxName);

      LogService.log('LocalStorageService: Hive boxes initialized successfully');
    } catch (e) {
      LogService.log('LocalStorageService: Failed to initialize Hive: $e');
      rethrow;
    }
  }

  /// Збереження погодних даних
  Future<void> saveWeatherData(String key, Map<String, dynamic> weatherData) async {
    try {
      await _weatherBox.put(key, weatherData);
      LogService.log('LocalStorageService: Weather data saved for key: $key');
    } catch (e) {
      LogService.log('LocalStorageService: Failed to save weather data: $e');
    }
  }

  /// Отримання погодних даних
  Map<String, dynamic>? getWeatherData(String key) {
    try {
      final data = _weatherBox.get(key);
      if (data != null) {
        LogService.log('LocalStorageService: Weather data retrieved for key: $key');
        return Map<String, dynamic>.from(data);
      }
      return null;
    } catch (e) {
      LogService.log('LocalStorageService: Failed to get weather data: $e');
      return null;
    }
  }

  /// Збереження даних маршруту
  Future<void> saveRouteData(String key, Map<String, dynamic> routeData) async {
    try {
      await _routeBox.put(key, routeData);
      LogService.log('LocalStorageService: Route data saved for key: $key');
    } catch (e) {
      LogService.log('LocalStorageService: Failed to save route data: $e');
    }
  }

  /// Отримання даних маршруту
  Map<String, dynamic>? getRouteData(String key) {
    try {
      final data = _routeBox.get(key);
      if (data != null) {
        LogService.log('LocalStorageService: Route data retrieved for key: $key');
        return Map<String, dynamic>.from(data);
      }
      return null;
    } catch (e) {
      LogService.log('LocalStorageService: Failed to get route data: $e');
      return null;
    }
  }

  /// Збереження результатів розрахунку складності
  Future<void> saveComplexityData(String key, Map<String, dynamic> complexityData) async {
    try {
      await _complexityBox.put(key, complexityData);
      LogService.log('LocalStorageService: Complexity data saved for key: $key');
    } catch (e) {
      LogService.log('LocalStorageService: Failed to save complexity data: $e');
    }
  }

  /// Отримання результатів розрахунку складності
  Map<String, dynamic>? getComplexityData(String key) {
    try {
      final data = _complexityBox.get(key);
      if (data != null) {
        LogService.log('LocalStorageService: Complexity data retrieved for key: $key');
        return Map<String, dynamic>.from(data);
      }
      return null;
    } catch (e) {
      LogService.log('LocalStorageService: Failed to get complexity data: $e');
      return null;
    }
  }

  /// Збереження даних користувача
  Future<void> saveUserData(String key, Map<String, dynamic> userData) async {
    try {
      await _userBox.put(key, userData);
      LogService.log('LocalStorageService: User data saved for key: $key');
    } catch (e) {
      LogService.log('LocalStorageService: Failed to save user data: $e');
    }
  }

  /// Отримання даних користувача
  Map<String, dynamic>? getUserData(String key) {
    try {
      final data = _userBox.get(key);
      if (data != null) {
        LogService.log('LocalStorageService: User data retrieved for key: $key');
        return Map<String, dynamic>.from(data);
      }
      return null;
    } catch (e) {
      LogService.log('LocalStorageService: Failed to get user data: $e');
      return null;
    }
  }

  /// Видалення даних за ключем
  Future<void> deleteData(String boxName, String key) async {
    try {
      Box box;
      switch (boxName) {
        case _weatherBoxName:
          box = _weatherBox;
          break;
        case _routeBoxName:
          box = _routeBox;
          break;
        case _complexityBoxName:
          box = _complexityBox;
          break;
        case _userBoxName:
          box = _userBox;
          break;
        default:
          throw ArgumentError('Unknown box name: $boxName');
      }

      await box.delete(key);
      LogService.log('LocalStorageService: Data deleted for key: $key in box: $boxName');
    } catch (e) {
      LogService.log('LocalStorageService: Failed to delete data: $e');
    }
  }

  /// Очищення всіх даних
  Future<void> clearAllData() async {
    try {
      await _weatherBox.clear();
      await _routeBox.clear();
      await _complexityBox.clear();
      await _userBox.clear();
      LogService.log('LocalStorageService: All data cleared');
    } catch (e) {
      LogService.log('LocalStorageService: Failed to clear all data: $e');
    }
  }

  /// Отримання статистики зберігання
  Map<String, int> getStorageStats() {
    return {
      'weather_entries': _weatherBox.length,
      'route_entries': _routeBox.length,
      'complexity_entries': _complexityBox.length,
      'user_entries': _userBox.length,
    };
  }

  /// Закриття всіх боксів
  Future<void> close() async {
    try {
      await _weatherBox.close();
      await _routeBox.close();
      await _complexityBox.close();
      await _userBox.close();
      LogService.log('LocalStorageService: All boxes closed');
    } catch (e) {
      LogService.log('LocalStorageService: Failed to close boxes: $e');
    }
  }
}
