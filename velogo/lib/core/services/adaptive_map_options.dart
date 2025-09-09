import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'map_context_service.dart';
import 'map_zoom_calculator.dart';
import '../services/log_service.dart';

/// Адаптивні опції карти, які автоматично налаштовуються під контекст
class AdaptiveMapOptions {
  final MapContext context;
  final List<LatLng>? routePoints;
  final Size screenSize;
  final LatLng? customCenter;
  final double? customZoom;
  final bool enableAutoFit;
  final double padding;

  const AdaptiveMapOptions({
    required this.context,
    this.routePoints,
    required this.screenSize,
    this.customCenter,
    this.customZoom,
    this.enableAutoFit = true,
    this.padding = 0.1,
  });

  /// Конвертувати в MapOptions для FlutterMap
  MapOptions toMapOptions() {
    LogService.log('🗺️ [AdaptiveMapOptions] Створення MapOptions для контексту: ${MapContextService.getContextDescription(context)}');

    final config = MapContextService.getConfig(context);
    final center = _calculateCenter();
    final zoom = _calculateZoom();

    LogService.log('📍 [AdaptiveMapOptions] Центр: $center, Zoom: $zoom');

    return MapOptions(
      initialCenter: center,
      initialZoom: zoom,
      minZoom: config.minZoom,
      maxZoom: config.maxZoom,
      interactionOptions: InteractionOptions(
        flags: InteractiveFlag.all,
        rotationThreshold: 25.0,
        pinchZoomThreshold: 1.0,
        scrollWheelVelocity: 0.01,
      ),
    );
  }

  /// Розрахувати центр карти
  LatLng _calculateCenter() {
    // Якщо задано кастомний центр, використовуємо його
    if (customCenter != null) {
      return customCenter!;
    }

    // Якщо є точки маршруту, розраховуємо центр
    if (routePoints != null && routePoints!.isNotEmpty) {
      return MapZoomCalculator.calculateCenter(routePoints!);
    }

    // Дефолтний центр (Дніпро)
    return LatLng(48.4131760, 35.0710294);
  }

  /// Розрахувати масштаб карти
  double _calculateZoom() {
    // Якщо задано кастомний zoom, використовуємо його
    if (customZoom != null) {
      return customZoom!;
    }

    // Якщо увімкнено автоматичне підлаштування та є точки
    if (enableAutoFit && routePoints != null && routePoints!.isNotEmpty) {
      return MapZoomCalculator.calculateZoomToFit(
        points: routePoints!,
        screenSize: screenSize,
        context: context,
        padding: padding,
      );
    }

    // Розраховуємо оптимальний zoom
    return MapZoomCalculator.calculateOptimalZoom(
      points: routePoints ?? [],
      context: context,
      screenSize: screenSize,
    );
  }

  /// Створити копію з новими параметрами
  AdaptiveMapOptions copyWith({
    MapContext? context,
    List<LatLng>? routePoints,
    Size? screenSize,
    LatLng? customCenter,
    double? customZoom,
    bool? enableAutoFit,
    double? padding,
  }) {
    return AdaptiveMapOptions(
      context: context ?? this.context,
      routePoints: routePoints ?? this.routePoints,
      screenSize: screenSize ?? this.screenSize,
      customCenter: customCenter ?? this.customCenter,
      customZoom: customZoom ?? this.customZoom,
      enableAutoFit: enableAutoFit ?? this.enableAutoFit,
      padding: padding ?? this.padding,
    );
  }

  /// Фабричний метод для створення опцій для створення маршруту
  factory AdaptiveMapOptions.forRouteCreation({
    required Size screenSize,
    List<LatLng>? existingPoints,
    LatLng? customCenter,
  }) {
    return AdaptiveMapOptions(
      context: MapContext.routeCreation,
      routePoints: existingPoints,
      screenSize: screenSize,
      customCenter: customCenter,
      enableAutoFit: false, // Не підлаштовуємо автоматично при створенні
    );
  }

  /// Фабричний метод для створення опцій для перегляду маршруту
  factory AdaptiveMapOptions.forRouteViewing({
    required Size screenSize,
    required List<LatLng> routePoints,
    double? customZoom,
  }) {
    return AdaptiveMapOptions(
      context: MapContext.routeViewing,
      routePoints: routePoints,
      screenSize: screenSize,
      customZoom: customZoom,
      enableAutoFit: true, // Підлаштовуємо під маршрут
      padding: 0.15, // Більший відступ для кращого огляду
    );
  }

  /// Фабричний метод для створення опцій для детального аналізу
  factory AdaptiveMapOptions.forDetailAnalysis({
    required Size screenSize,
    required LatLng centerPoint,
    double? customZoom,
  }) {
    return AdaptiveMapOptions(
      context: MapContext.detailAnalysis,
      routePoints: [centerPoint],
      screenSize: screenSize,
      customCenter: centerPoint,
      customZoom: customZoom,
      enableAutoFit: false,
    );
  }

  /// Фабричний метод для створення опцій для пошуку
  factory AdaptiveMapOptions.forPointSearch({
    required Size screenSize,
    LatLng? searchCenter,
  }) {
    return AdaptiveMapOptions(
      context: MapContext.pointSearch,
      routePoints: searchCenter != null ? [searchCenter] : null,
      screenSize: screenSize,
      customCenter: searchCenter,
      enableAutoFit: false,
    );
  }

  /// Фабричний метод для створення опцій для навігації
  factory AdaptiveMapOptions.forNavigation({
    required Size screenSize,
    required List<LatLng> routePoints,
    LatLng? currentLocation,
  }) {
    return AdaptiveMapOptions(
      context: MapContext.navigation,
      routePoints: routePoints,
      screenSize: screenSize,
      customCenter: currentLocation,
      enableAutoFit: false, // Не підлаштовуємо автоматично при навігації
    );
  }

  /// Фабричний метод для створення опцій для загального огляду
  factory AdaptiveMapOptions.forOverview({
    required Size screenSize,
    List<LatLng>? points,
  }) {
    return AdaptiveMapOptions(
      context: MapContext.overview,
      routePoints: points,
      screenSize: screenSize,
      enableAutoFit: true,
      padding: 0.2, // Великий відступ для загального огляду
    );
  }

  @override
  String toString() {
    return 'AdaptiveMapOptions(context: $context, points: ${routePoints?.length}, screen: ${screenSize.width}x${screenSize.height}, autoFit: $enableAutoFit)';
  }
}
