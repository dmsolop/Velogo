import '../features/weather/data/models/weather_data.dart';
import '../models/road_surface.dart';
import 'log_service.dart';

/// Сервіс для розрахунку стану дороги на основі погоди та типу покриття
class RoadConditionService {
  static final RoadConditionService _instance = RoadConditionService._internal();
  factory RoadConditionService() => _instance;
  RoadConditionService._internal();

  /// Розрахунок стану дороги на основі погоди та типу покриття
  double calculateRoadCondition(WeatherData weather, RoadSurface surface) {
    try {
      LogService.log('🛣️ [RoadConditionService] Розрахунок стану дороги: surface=${surface.displayName}, precipitation=${weather.precipitation}mm/h');

      if (weather.precipitation == 0.0) {
        return 0.0; // Сухо
      }

      // Базовий стан залежно від типу опадів
      double baseCondition = weather.precipitationType == 1 ? 1.0 : 2.0; // 1=дощ, 2=сніг

      // Корекція залежно від типу покриття
      baseCondition *= surface.precipitationImpact;

      // Додатковий вплив інтенсивності опадів
      if (weather.precipitation > 10.0) {
        baseCondition *= 1.2; // Сильні опади
      }

      // Вплив вологості
      if (weather.humidity > 80.0) {
        baseCondition += 0.3;
      }

      // Вплив температури (для снігу)
      if (weather.precipitationType == 2.0 && weather.temperature > 0.0) {
        baseCondition *= 1.5; // Танець сніг
      }

      LogService.log('🛣️ [RoadConditionService] Результат: $baseCondition');
      return baseCondition;
    } catch (e) {
      LogService.log('❌ [RoadConditionService] Помилка розрахунку стану дороги: $e');
      return 0.0;
    }
  }

  /// Отримання текстового опису стану дороги
  String getRoadConditionDescription(double roadCondition) {
    if (roadCondition < 0.5) {
      return 'Сухо';
    } else if (roadCondition < 1.0) {
      return 'Мокро';
    } else if (roadCondition < 2.0) {
      return 'Багнисто';
    } else if (roadCondition < 3.0) {
      return 'Дуже багнисто';
    } else {
      return 'Непрохідно';
    }
  }
}
