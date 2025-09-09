import 'dart:math';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'map_context_service.dart';
import 'map_zoom_config.dart';
import '../services/log_service.dart';

/// Калькулятор для розрахунку оптимального масштабу карти
class MapZoomCalculator {
  static const double _earthRadius = 6371000; // Радіус Землі в метрах
  static const double _minZoom = 1.0;
  static const double _maxZoom = 20.0;

  /// Розрахувати оптимальний масштаб для заданих точок та контексту
  static double calculateOptimalZoom({
    required List<LatLng> points,
    required MapContext context,
    required Size screenSize,
    double? currentZoom,
  }) {
    LogService.log('🧮 [MapZoomCalculator] Розрахунок оптимального масштабу: points=${points.length}, context=$context, screen=${screenSize.width}x${screenSize.height}');

    if (points.isEmpty) {
      final defaultZoom = _getDefaultZoomForContext(context);
      LogService.log('📍 [MapZoomCalculator] Немає точок, використовуємо дефолтний zoom: $defaultZoom');
      return defaultZoom;
    }

    // Розрахунок bounding box
    final bounds = _calculateBounds(points);
    final distance = _calculateDistance(bounds);

    // Адаптація під розмір екрану
    final screenFactor = _calculateScreenFactor(screenSize);

    // Формула розрахунку zoom
    final optimalZoom = _calculateZoomFromDistance(distance, screenFactor);

    // Обмеження в межах контексту
    final clampedZoom = _clampZoom(optimalZoom, context);

    LogService.log('✅ [MapZoomCalculator] Оптимальний zoom: $optimalZoom -> обмежений: $clampedZoom');

    return clampedZoom;
  }

  /// Розрахувати центр карти для заданих точок
  static LatLng calculateCenter(List<LatLng> points) {
    if (points.isEmpty) {
      return LatLng(48.4131760, 35.0710294); // Дніпро як дефолт
    }

    if (points.length == 1) {
      return points.first;
    }

    double totalLat = 0;
    double totalLng = 0;

    for (final point in points) {
      totalLat += point.latitude;
      totalLng += point.longitude;
    }

    return LatLng(
      totalLat / points.length,
      totalLng / points.length,
    );
  }

  /// Розрахувати bounding box для точок
  static MapBounds _calculateBounds(List<LatLng> points) {
    if (points.isEmpty) {
      return MapBounds(
        north: 0,
        south: 0,
        east: 0,
        west: 0,
      );
    }

    double north = points.first.latitude;
    double south = points.first.latitude;
    double east = points.first.longitude;
    double west = points.first.longitude;

    for (final point in points) {
      north = max(north, point.latitude);
      south = min(south, point.latitude);
      east = max(east, point.longitude);
      west = min(west, point.longitude);
    }

    return MapBounds(
      north: north,
      south: south,
      east: east,
      west: west,
    );
  }

  /// Розрахувати відстань між крайніми точками
  static double _calculateDistance(MapBounds bounds) {
    final lat1 = bounds.north;
    final lat2 = bounds.south;
    final lng1 = bounds.east;
    final lng2 = bounds.west;

    // Розрахунок відстані по діагоналі
    final latDistance = _calculateLatitudeDistance(lat1, lat2);
    final lngDistance = _calculateLongitudeDistance(lng1, lng2, (lat1 + lat2) / 2);

    return sqrt(pow(latDistance, 2) + pow(lngDistance, 2));
  }

  /// Розрахунок відстані по широті
  static double _calculateLatitudeDistance(double lat1, double lat2) {
    return (lat1 - lat2) * pi / 180 * _earthRadius;
  }

  /// Розрахунок відстані по довготі
  static double _calculateLongitudeDistance(double lng1, double lng2, double avgLat) {
    return (lng1 - lng2) * pi / 180 * _earthRadius * cos(avgLat * pi / 180);
  }

  /// Розрахунок фактора екрану
  static double _calculateScreenFactor(Size screenSize) {
    // Базовий розмір екрану (iPhone 12 Pro)
    const baseWidth = 390.0;
    const baseHeight = 844.0;

    // Розрахунок коефіцієнта масштабування
    final widthFactor = screenSize.width / baseWidth;
    final heightFactor = screenSize.height / baseHeight;

    // Використовуємо середнє значення
    return (widthFactor + heightFactor) / 2;
  }

  /// Розрахунок zoom на основі відстані
  static double _calculateZoomFromDistance(double distance, double screenFactor) {
    if (distance <= 0) return 18.0; // Максимальний zoom для дуже малих відстаней

    // Формула розрахунку zoom на основі відстані
    // Базовий zoom для відстані 1000м
    const baseDistance = 1000.0; // 1 км
    const baseZoom = 15.0;

    // Логарифмічний розрахунок
    final zoom = baseZoom - log(distance / baseDistance) / ln2;

    // Адаптація під розмір екрану
    final adjustedZoom = zoom + (screenFactor - 1.0) * 0.5;

    return adjustedZoom;
  }

  /// Обмежити zoom в межах контексту
  static double _clampZoom(double zoom, MapContext context) {
    final config = MapContextService.getConfig(context);
    return zoom.clamp(config.minZoom, config.maxZoom);
  }

  /// Отримати дефолтний zoom для контексту
  static double _getDefaultZoomForContext(MapContext context) {
    return MapContextService.getConfig(context).defaultZoom;
  }

  /// Розрахувати zoom для показу всіх точок з певним відступом
  static double calculateZoomToFit({
    required List<LatLng> points,
    required Size screenSize,
    required MapContext context,
    double padding = 0.1, // 10% відступу
  }) {
    if (points.isEmpty) {
      return _getDefaultZoomForContext(context);
    }

    final bounds = _calculateBounds(points);
    final distance = _calculateDistance(bounds);

    // Додаємо відступ
    final distanceWithPadding = distance * (1 + padding);

    // Розраховуємо zoom
    final zoom = _calculateZoomFromDistance(distanceWithPadding, _calculateScreenFactor(screenSize));

    return _clampZoom(zoom, context);
  }

  /// Перевірити чи можна збільшити масштаб
  static bool canZoomIn(MapContext context, double currentZoom) {
    final config = MapContextService.getConfig(context);
    return currentZoom < config.maxZoom;
  }

  /// Перевірити чи можна зменшити масштаб
  static bool canZoomOut(MapContext context, double currentZoom) {
    final config = MapContextService.getConfig(context);
    return currentZoom > config.minZoom;
  }
}

/// Модель для bounding box
class MapBounds {
  final double north;
  final double south;
  final double east;
  final double west;

  const MapBounds({
    required this.north,
    required this.south,
    required this.east,
    required this.west,
  });

  /// Розрахунок ширини в градусах
  double get width => east - west;

  /// Розрахунок висоти в градусах
  double get height => north - south;

  /// Розрахунок центру
  LatLng get center => LatLng(
        (north + south) / 2,
        (east + west) / 2,
      );

  @override
  String toString() {
    return 'MapBounds(north: $north, south: $south, east: $east, west: $west)';
  }
}
