import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'map_layer_entity.freezed.dart';

@freezed
class MapLayerEntity with _$MapLayerEntity {
  const factory MapLayerEntity({
    required String id,
    required String name,
    required String displayName,
    required MapLayerType type,
    @Default(true) bool isVisible,
    required String urlTemplate,
    List<String>? subdomains,
    Map<String, dynamic>? options,
    int? maxZoom,
    int? minZoom,
  }) = _MapLayerEntity;
}

enum MapLayerType {
  standard, // Звичайна карта
  satellite, // Супутникова карта
  terrain, // Рельєфна карта
  wind, // Вітрові потоки
  weather, // Погодні умови
  traffic, // Дорожній рух
  cycling, // Велосипедні маршрути
  custom, // Користувацький шар
}

@freezed
class WindLayerEntity with _$WindLayerEntity {
  const factory WindLayerEntity({
    required String id,
    required String name,
    @Default(true) bool isVisible,
    @Default(false) bool isAnimated,
    @Default(1.0) double opacity,
    @Default(1000) int animationSpeed,
    required WindDataEntity windData,
  }) = _WindLayerEntity;
}

@freezed
class WindDataEntity with _$WindDataEntity {
  const factory WindDataEntity({
    required double windSpeed,
    required double windDirection,
    required double windGust,
    required DateTime timestamp,
    required LatLng coordinates,
  }) = _WindDataEntity;
}
