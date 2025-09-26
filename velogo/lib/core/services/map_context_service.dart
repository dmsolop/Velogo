import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'map_zoom_config.dart';
import '../services/log_service.dart';

/// Контексти використання карти в додатку
/// 
/// Визначає різні режими роботи з картою, кожен з яких має свої налаштування
/// масштабування та поведінки
enum MapContext {
  routeCreation, // Створення маршруту - високий zoom для точного додавання точок
  routeViewing, // Перегляд маршруту - автоматичне підлаштування під маршрут
  detailAnalysis, // Детальний аналіз - максимальний zoom для деталей
  pointSearch, // Пошук точки - середній zoom для пошуку
  navigation, // Навігація - динамічний zoom залежно від швидкості
  overview, // Загальний огляд - низький zoom для огляду великих територій
}

/// Сервіс для управління контекстами карти та їх конфігураціями
/// 
/// Основні функції:
/// - Визначення контексту карти на основі поточного стану
/// - Надання конфігурацій масштабування для кожного контексту
/// - Адаптивне налаштування карти під різні сценарії використання
/// - Управління анімаціями та переходами між контекстами
/// 
/// Використовується в: CreateRouteScreen, RouteScreen, AdaptiveMapOptions
class MapContextService {
  static final Map<MapContext, MapZoomConfig> _contextConfigs = {
    MapContext.routeCreation: MapZoomConfig(
      defaultZoom: 16.5, // Збільшено з 15.5
      minZoom: 10.0,
      maxZoom: 18.0,
      autoFit: false,
      animationDuration: Duration(milliseconds: 600),
      animationCurve: Curves.easeInOut,
    ),
    MapContext.routeViewing: MapZoomConfig(
      defaultZoom: 15.0, // Збільшено з 13.0
      minZoom: 10.0,
      maxZoom: 16.0,
      autoFit: true, // Автоматично підлаштовувати під маршрут
      animationDuration: Duration(milliseconds: 800),
      animationCurve: Curves.easeInOutCubic,
    ),
    MapContext.detailAnalysis: MapZoomConfig(
      defaultZoom: 17.0,
      minZoom: 15.0,
      maxZoom: 19.0,
      autoFit: false,
      animationDuration: Duration(milliseconds: 400),
      animationCurve: Curves.easeIn,
    ),
    MapContext.pointSearch: MapZoomConfig(
      defaultZoom: 16.0,
      minZoom: 14.0,
      maxZoom: 18.0,
      autoFit: false,
      animationDuration: Duration(milliseconds: 500),
      animationCurve: Curves.easeOut,
    ),
    MapContext.navigation: MapZoomConfig(
      defaultZoom: 16.5,
      minZoom: 15.0,
      maxZoom: 18.0,
      autoFit: false,
      animationDuration: Duration(milliseconds: 300),
      animationCurve: Curves.linear,
    ),
    MapContext.overview: MapZoomConfig(
      defaultZoom: 12.0,
      minZoom: 8.0,
      maxZoom: 15.0,
      autoFit: true,
      animationDuration: Duration(milliseconds: 1000),
      animationCurve: Curves.easeInOutCubic,
    ),
  };

  /// Отримання конфігурації масштабування для заданого контексту
  /// 
  /// Функціональність:
  /// - Повертає конфігурацію масштабування для контексту
  /// - Використовує дефолтну конфігурацію якщо контекст не знайдено
  /// - Логує попередження при використанні дефолтної конфігурації
  /// 
  /// Використовується в: AdaptiveMapOptions для отримання налаштувань карти
  static MapZoomConfig getConfig(MapContext context) {
    final config = _contextConfigs[context];
    if (config == null) {
      LogService.log('⚠️ [MapContextService] Конфігурація для контексту $context не знайдена, використовуємо дефолтну');
      return _contextConfigs[MapContext.overview]!;
    }
    return config;
  }

  /// Визначення контексту карти на основі поточного стану додатку
  /// 
  /// Функціональність:
  /// - Аналізує поточний екран та стан додатку
  /// - Визначає найбільш підходящий контекст карти
  /// - Враховує пріоритети (навігація > аналіз екрану > загальний стан)
  /// 
  /// Параметри:
  /// - currentScreen: назва поточного екрану
  /// - routePoints: точки маршруту (якщо є)
  /// - isDrawingMode: чи активний режим малювання
  /// - hasSelectedPoint: чи вибрана точка
  /// - isNavigationActive: чи активна навігація
  /// 
  /// Використовується в: AdaptiveMapOptions для визначення налаштувань карти
  static MapContext determineContext({
    required String currentScreen,
    required List<LatLng>? routePoints,
    required bool isDrawingMode,
    required bool hasSelectedPoint,
    required bool isNavigationActive,
  }) {
    LogService.log('🔍 [MapContextService] Визначення контексту: screen=$currentScreen, points=${routePoints?.length}, drawing=$isDrawingMode, selected=$hasSelectedPoint, nav=$isNavigationActive');

    // Навігація має найвищий пріоритет
    if (isNavigationActive) {
      return MapContext.navigation;
    }

    // Аналіз екрану
    switch (currentScreen.toLowerCase()) {
      case 'create_route':
      case 'create_route_screen':
        if (isDrawingMode) {
          return hasSelectedPoint ? MapContext.detailAnalysis : MapContext.routeCreation;
        }
        return MapContext.routeCreation;

      case 'route_screen':
      case 'route_view':
        if (routePoints != null && routePoints.isNotEmpty) {
          return MapContext.routeViewing;
        }
        return MapContext.overview;

      case 'search':
      case 'point_search':
        return MapContext.pointSearch;

      default:
        // Загальна логіка
        if (routePoints != null && routePoints.isNotEmpty) {
          return MapContext.routeViewing;
        }
        if (hasSelectedPoint) {
          return MapContext.detailAnalysis;
        }
        return MapContext.overview;
    }
  }

  /// Отримати всі доступні контексти
  static List<MapContext> getAllContexts() {
    return MapContext.values;
  }

  /// Перевірити чи контекст підтримує автоматичне підлаштування
  static bool supportsAutoFit(MapContext context) {
    return getConfig(context).autoFit;
  }

  /// Отримати опис контексту для логування
  static String getContextDescription(MapContext context) {
    switch (context) {
      case MapContext.routeCreation:
        return 'Створення маршруту';
      case MapContext.routeViewing:
        return 'Перегляд маршруту';
      case MapContext.detailAnalysis:
        return 'Детальний аналіз';
      case MapContext.pointSearch:
        return 'Пошук точки';
      case MapContext.navigation:
        return 'Навігація';
      case MapContext.overview:
        return 'Загальний огляд';
    }
  }

  /// Оновити конфігурацію для контексту (для тестування або налаштувань)
  static void updateConfig(MapContext context, MapZoomConfig newConfig) {
    LogService.log('⚙️ [MapContextService] Оновлення конфігурації для $context: $newConfig');
    _contextConfigs[context] = newConfig;
  }
}
