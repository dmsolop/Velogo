import 'package:flutter/material.dart';

/// Конфігурація масштабування карти для різних контекстів
class MapZoomConfig {
  final double defaultZoom;
  final double minZoom;
  final double maxZoom;
  final bool autoFit; // Автоматично підлаштовувати під контент
  final Duration animationDuration;
  final Curve animationCurve;

  const MapZoomConfig({
    required this.defaultZoom,
    required this.minZoom,
    required this.maxZoom,
    this.autoFit = false,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOut,
  });

  /// Копіювання з можливістю зміни параметрів
  MapZoomConfig copyWith({
    double? defaultZoom,
    double? minZoom,
    double? maxZoom,
    bool? autoFit,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return MapZoomConfig(
      defaultZoom: defaultZoom ?? this.defaultZoom,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      autoFit: autoFit ?? this.autoFit,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }

  @override
  String toString() {
    return 'MapZoomConfig(defaultZoom: $defaultZoom, minZoom: $minZoom, maxZoom: $maxZoom, autoFit: $autoFit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapZoomConfig && other.defaultZoom == defaultZoom && other.minZoom == minZoom && other.maxZoom == maxZoom && other.autoFit == autoFit && other.animationDuration == animationDuration && other.animationCurve == animationCurve;
  }

  @override
  int get hashCode {
    return defaultZoom.hashCode ^ minZoom.hashCode ^ maxZoom.hashCode ^ autoFit.hashCode ^ animationDuration.hashCode ^ animationCurve.hashCode;
  }
}
