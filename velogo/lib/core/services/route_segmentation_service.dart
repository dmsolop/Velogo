import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'log_service.dart';
import 'road_routing_service.dart';
import '../../features/map/domain/entities/route_entity.dart';

/// Сервіс для автоматичного розбиття координат маршруту на секції
///
/// Функціональність:
/// - Розбиває координати від API на підсекції за різними критеріями
/// - Критерії: фіксована довжина, зміна напряму, висоти, покриття, вітру
/// - Створює RouteSectionEntity для кожної секції
///
/// Використовується в: CreateRouteScreen при створенні маршруту
class RouteSegmentationService {
  // Константи для розбиття
  static const double minSectionLength = 300.0; // Мінімальна довжина секції в метрах
  static const double maxSectionLength = 500.0; // Максимальна довжина секції в метрах
  static const double elevationThreshold = 30.0; // Поріг зміни висоти в метрах
  static const double directionChangeThreshold = 30.0; // Поріг зміни напряму в градусах
  static const double windDirectionChangeThreshold = 45.0; // Поріг зміни напряму вітру в градусах

  /// Розбиття координат на секції за всіма критеріями
  ///
  /// Параметри:
  /// - coordinates: координати маршруту від API
  /// - startPoint: початкова точка (для розрахунку elevationGain)
  /// - endPoint: кінцева точка
  ///
  /// Повертає: список індексів координат, де потрібно розбити маршрут
  ///
  /// Використовується в: CreateRouteScreen перед створенням секцій
  static List<int> findSplitPoints(List<LatLng> coordinates) {
    if (coordinates.length < 2) return [];

    final splitPoints = <int>[0]; // Початок маршруту
    double currentDistance = 0.0;
    double currentElevation = 0.0;
    double? previousBearing;
    double? previousWindDirection;

    for (int i = 1; i < coordinates.length; i++) {
      final prevPoint = coordinates[i - 1];
      final currentPoint = coordinates[i];

      // Розраховуємо відстань від попередньої точки
      final segmentDistance = _calculateDistance(prevPoint, currentPoint);
      currentDistance += segmentDistance;

      // Розраховуємо зміну висоти (спрощено - потрібно отримувати з API)
      final elevationChange = _estimateElevationChange(prevPoint, currentPoint);
      currentElevation += elevationChange;

      // Розраховуємо напрямок руху
      final bearing = _calculateBearing(prevPoint, currentPoint);

      // Перевірка критеріїв розбиття

      // 1. Фіксована довжина
      if (currentDistance >= maxSectionLength) {
        splitPoints.add(i);
        currentDistance = 0.0;
        currentElevation = 0.0;
        previousBearing = null;
        previousWindDirection = null;
        continue;
      }

      // 2. Зміна напряму дороги
      if (previousBearing != null) {
        final directionChange = _calculateDirectionChange(previousBearing, bearing);
        if (directionChange > directionChangeThreshold) {
          splitPoints.add(i);
          currentDistance = 0.0;
          currentElevation = 0.0;
          previousBearing = null;
          previousWindDirection = null;
          continue;
        }
      }

      // 3. Зміна висоти
      if (currentElevation.abs() >= elevationThreshold) {
        splitPoints.add(i);
        currentDistance = 0.0;
        currentElevation = 0.0;
        previousBearing = null;
        previousWindDirection = null;
        continue;
      }

      // 4. Мінімальна довжина (якщо досягнуто мінімум і немає інших причин)
      if (currentDistance >= minSectionLength && i == coordinates.length - 1) {
        // Остання точка - завжди додаємо
        if (!splitPoints.contains(i)) {
          splitPoints.add(i);
        }
      }

      previousBearing = bearing;
    }

    // Додаємо останню точку якщо її немає
    if (!splitPoints.contains(coordinates.length - 1)) {
      splitPoints.add(coordinates.length - 1);
    }

    LogService.log('📊 [RouteSegmentationService] Знайдено ${splitPoints.length} точок розбиття для ${coordinates.length} координат');
    return splitPoints;
  }

  /// Створення секцій з координат на основі точок розбиття
  ///
  /// Параметри:
  /// - coordinates: всі координати маршруту
  /// - splitPoints: індекси точок розбиття
  ///
  /// Повертає: список координат для кожної секції
  ///
  /// Використовується в: CreateRouteScreen для створення RouteSectionEntity
  static List<List<LatLng>> createSectionsFromSplitPoints(
    List<LatLng> coordinates,
    List<int> splitPoints,
  ) {
    if (splitPoints.length < 2) {
      return [coordinates];
    }

    final sections = <List<LatLng>>[];

    for (int i = 0; i < splitPoints.length - 1; i++) {
      final startIndex = splitPoints[i];
      final endIndex = splitPoints[i + 1] + 1; // +1 щоб включити останню точку

      if (endIndex <= coordinates.length) {
        final sectionCoordinates = coordinates.sublist(startIndex, endIndex);
        if (sectionCoordinates.length >= 2) {
          sections.add(sectionCoordinates);
        }
      }
    }

    LogService.log('✅ [RouteSegmentationService] Створено ${sections.length} секцій');
    return sections;
  }

  /// Розрахунок відстані між двома точками (Haversine formula)
  static double _calculateDistance(LatLng point1, LatLng point2) {
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

  /// Оцінка зміни висоти між двома точками
  ///
  /// Примітка: Це спрощена оцінка. Для точності потрібно отримувати дані з Elevation API
  static double _estimateElevationChange(LatLng point1, LatLng point2) {
    // TODO: Інтегрувати з Elevation API для точних даних
    // Поки що повертаємо 0 - буде розраховуватися через RoutingRepository.calculateElevationGain
    return 0.0;
  }

  /// Розрахунок азимуту (напрямку) між двома точками
  static double _calculateBearing(LatLng point1, LatLng point2) {
    final lat1Rad = point1.latitude * pi / 180;
    final lat2Rad = point2.latitude * pi / 180;
    final deltaLonRad = (point2.longitude - point1.longitude) * pi / 180;

    final y = sin(deltaLonRad) * cos(lat2Rad);
    final x = cos(lat1Rad) * sin(lat2Rad) -
        sin(lat1Rad) * cos(lat2Rad) * cos(deltaLonRad);

    final bearing = atan2(y, x);
    return (bearing * 180 / pi + 360) % 360; // Конвертуємо в градуси 0-360
  }

  /// Розрахунок зміни напряму між двома азимутами
  static double _calculateDirectionChange(double bearing1, double bearing2) {
    double diff = (bearing2 - bearing1).abs();
    if (diff > 180) {
      diff = 360 - diff;
    }
    return diff;
  }
}

