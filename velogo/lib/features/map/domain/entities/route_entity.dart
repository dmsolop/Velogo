import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'route_entity.freezed.dart';

@freezed
class RouteEntity with _$RouteEntity {
  const factory RouteEntity({
    required String id,
    required String name,
    required String description,
    required List<LatLng> coordinates,
    required double totalDistance,
    required double totalElevationGain,
    required double averageDifficulty,
    required RouteDifficulty difficulty,
    required List<RouteSectionEntity> sections,
    required List<PointOfInterestEntity> pointsOfInterest,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? userId,
    @Default(false) bool isPublic,
    @Default(false) bool isFavorite,
  }) = _RouteEntity;
}

@freezed
class RouteSectionEntity with _$RouteSectionEntity {
  const factory RouteSectionEntity({
    required String id,
    required List<LatLng> coordinates,
    required double distance,
    required double elevationGain,
    required RoadSurfaceType surfaceType,
    required double windEffect,
    required double difficulty,
    required double averageSpeed,
    String? notes,
  }) = _RouteSectionEntity;
}

@freezed
class PointOfInterestEntity with _$PointOfInterestEntity {
  const factory PointOfInterestEntity({
    required String id,
    required String name,
    required String type,
    required LatLng coordinates,
    required String description,
    String? imageUrl,
    double? rating,
    Map<String, dynamic>? metadata,
  }) = _PointOfInterestEntity;
}

enum RouteDifficulty {
  easy,
  moderate,
  hard,
  expert,
}

enum RoadSurfaceType {
  asphalt,
  concrete,
  gravel,
  dirt,
  cobblestone,
  grass,
  sand,
}
