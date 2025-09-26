import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'road_routing_service.dart';
import '../services/log_service.dart';

/// Сервіс для перетягування маршрутів з підлаштуванням під найближчі дороги
/// 
/// Основні функції:
/// - Управління станом перетягування (увімкнено/вимкнено)
/// - Перетягування точок маршруту з прилипанням до доріг
/// - Перерахунок маршрутів після перетягування
/// - Синхронізація з налаштуваннями користувача
/// 
/// Використовується в: CreateRouteScreen, SettingsCubit
class RouteDragService {
  static bool _isDragEnabled = false;
  static const double _snapDistance = 0.0001; // Відстань для "прилипання" до дороги
  static const int _maxSnapAttempts = 3; // Максимальна кількість спроб знайти найближчу дорогу

  /// Увімкнути/вимкнути режим перетягування маршрутів
  /// 
  /// Встановлює глобальний стан перетягування для всього додатку
  /// 
  /// Використовується в: SettingsCubit, ініціалізації додатку
  static void setDragEnabled(bool enabled) {
    _isDragEnabled = enabled;
    LogService.log('🔄 [RouteDragService] Режим перетягування маршрутів: ${enabled ? "увімкнено" : "вимкнено"}');
  }

  /// Перевірка чи увімкнено режим перетягування
  /// 
  /// Повертає поточний стан перетягування
  /// 
  /// Використовується в: CreateRouteScreen._handleLongPressOnRoute()
  static bool get isDragEnabled => _isDragEnabled;

  /// Оновлення стану з налаштувань користувача
  /// 
  /// Синхронізує стан сервісу з налаштуваннями з SettingsCubit
  /// 
  /// Використовується в: SettingsCubit.loadSettings(), SettingsCubit.toggleRouteDragging()
  static void updateFromSettings(bool enabled) {
    _isDragEnabled = enabled;
    LogService.log('🔄 [RouteDragService] Стан оновлено з налаштувань: ${enabled ? "увімкнено" : "вимкнено"}');
  }

  /// Перетягування точки маршруту з прилипанням до найближчої дороги
  /// 
  /// Функціональність:
  /// - Перевіряє чи увімкнено перетягування
  /// - Знаходить найближчу дорогу до нової позиції
  /// - Перераховує маршрут з новою точкою
  /// - Повертає оновлену точку
  /// 
  /// Параметри:
  /// - originalPoint: оригінальна позиція точки
  /// - newPosition: нова позиція після перетягування
  /// - routePoints: всі точки маршруту
  /// - pointIndex: індекс перетягуваної точки
  /// - profile: профіль маршрутизації
  /// 
  /// Використовується в: CreateRouteScreen (через _moveRouteSection)
  static Future<LatLng> dragRoutePoint({
    required LatLng originalPoint,
    required LatLng newPosition,
    required List<LatLng> routePoints,
    required int pointIndex,
    String profile = 'cycling-regular',
  }) async {
    if (!_isDragEnabled) {
      LogService.log('⚠️ [RouteDragService] Режим перетягування вимкнено, повертаємо оригінальну точку');
      return originalPoint;
    }

    LogService.log('🔄 [RouteDragService] Перетягування точки $pointIndex: ${originalPoint.latitude},${originalPoint.longitude} -> ${newPosition.latitude},${newPosition.longitude}');

    try {
      // Спробуємо знайти найближчу дорогу для нової позиції
      final snappedPoint = await _snapToNearestRoad(newPosition, profile);

      // Перерахуємо маршрут з новою точкою
      final updatedRoute = await _recalculateRouteWithNewPoint(
        routePoints: routePoints,
        newPoint: snappedPoint,
        pointIndex: pointIndex,
        profile: profile,
      );

      if (updatedRoute.isNotEmpty) {
        LogService.log('✅ [RouteDragService] Маршрут успішно перерахувано з ${updatedRoute.length} точками');
        return snappedPoint;
      } else {
        LogService.log('⚠️ [RouteDragService] Не вдалося перерахувати маршрут, використовуємо нову позицію');
        return newPosition;
      }
    } catch (e) {
      LogService.log('❌ [RouteDragService] Помилка при перетягуванні: $e');
      return newPosition; // Повертаємо нову позицію як fallback
    }
  }

  /// Знайти найближчу дорогу для точки
  static Future<LatLng> _snapToNearestRoad(LatLng point, String profile) async {
    LogService.log('🔍 [RouteDragService] Пошук найближчої дороги для точки: ${point.latitude},${point.longitude}');

    // Створюємо кілька тестових точок навколо поточної позиції
    final testPoints = _generateTestPoints(point);

    for (int attempt = 0; attempt < _maxSnapAttempts; attempt++) {
      for (final testPoint in testPoints) {
        try {
          // Перевіряємо чи можна дістатися до цієї точки по дорогах
          final route = await RoadRoutingService.calculateRoute(
            startPoint: point,
            endPoint: testPoint,
            profile: profile,
          );

          if (route.isNotEmpty && route.length > 1) {
            // Якщо маршрут існує, повертаємо тестову точку
            LogService.log('✅ [RouteDragService] Знайдено найближчу дорогу: ${testPoint.latitude},${testPoint.longitude}');
            return testPoint;
          }
        } catch (e) {
          LogService.log('⚠️ [RouteDragService] Помилка при перевірці точки ${testPoint.latitude},${testPoint.longitude}: $e');
        }
      }

      // Збільшуємо радіус пошуку для наступної спроби
      final newTestPoints = _generateTestPoints(point, radius: _snapDistance * (attempt + 2));
      testPoints.addAll(newTestPoints);
    }

    LogService.log('⚠️ [RouteDragService] Не знайдено найближчу дорогу, повертаємо оригінальну точку');
    return point;
  }

  /// Генерувати тестові точки навколо заданої точки
  static List<LatLng> _generateTestPoints(LatLng center, {double radius = _snapDistance}) {
    final points = <LatLng>[];

    // Генеруємо точки по колу
    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * pi) / 8;
      final lat = center.latitude + radius * cos(angle);
      final lng = center.longitude + radius * sin(angle);
      points.add(LatLng(lat, lng));
    }

    // Додаємо точки по діагоналях
    points.add(LatLng(center.latitude + radius, center.longitude + radius));
    points.add(LatLng(center.latitude + radius, center.longitude - radius));
    points.add(LatLng(center.latitude - radius, center.longitude + radius));
    points.add(LatLng(center.latitude - radius, center.longitude - radius));

    return points;
  }

  /// Перерахувати маршрут з новою точкою
  static Future<List<LatLng>> _recalculateRouteWithNewPoint({
    required List<LatLng> routePoints,
    required LatLng newPoint,
    required int pointIndex,
    required String profile,
  }) async {
    LogService.log('🔄 [RouteRoutingService] Перерахунок маршруту з новою точкою $pointIndex');

    // Створюємо новий список точок з заміненою точкою
    final updatedPoints = List<LatLng>.from(routePoints);
    updatedPoints[pointIndex] = newPoint;

    // Якщо це перша або остання точка, просто перераховуємо весь маршрут
    if (pointIndex == 0 || pointIndex == routePoints.length - 1) {
      return await RoadRoutingService.calculateRouteWithWaypoints(
        waypoints: updatedPoints,
        profile: profile,
      );
    }

    // Для проміжних точок перераховуємо сегменти
    final segments = <List<LatLng>>[];

    // Сегмент до нової точки
    if (pointIndex > 0) {
      final segment1 = await RoadRoutingService.calculateRouteWithWaypoints(
        waypoints: updatedPoints.sublist(0, pointIndex + 1),
        profile: profile,
      );
      if (segment1.isNotEmpty) segments.add(segment1);
    }

    // Сегмент після нової точки
    if (pointIndex < routePoints.length - 1) {
      final segment2 = await RoadRoutingService.calculateRouteWithWaypoints(
        waypoints: updatedPoints.sublist(pointIndex),
        profile: profile,
      );
      if (segment2.isNotEmpty) segments.add(segment2);
    }

    // Об'єднуємо сегменти
    final combinedRoute = <LatLng>[];
    for (final segment in segments) {
      if (combinedRoute.isEmpty) {
        combinedRoute.addAll(segment);
      } else {
        // Додаємо сегмент без першої точки (щоб уникнути дублювання)
        combinedRoute.addAll(segment.skip(1));
      }
    }

    return combinedRoute;
  }

  /// Перевірити чи можна перетягнути точку маршруту
  static bool canDragPoint(List<LatLng> routePoints, int pointIndex) {
    if (!_isDragEnabled) return false;
    if (routePoints.isEmpty) return false;
    if (pointIndex < 0 || pointIndex >= routePoints.length) return false;

    // Не дозволяємо перетягувати першу та останню точки (якщо маршрут має менше 3 точок)
    if (routePoints.length <= 2) return false;

    return true;
  }

  /// Отримати інформацію про режим перетягування
  static Map<String, dynamic> getDragInfo() {
    return {
      'enabled': _isDragEnabled,
      'snapDistance': _snapDistance,
      'maxSnapAttempts': _maxSnapAttempts,
    };
  }
}
