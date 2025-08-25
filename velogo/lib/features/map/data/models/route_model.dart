import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/route_entity.dart';

class RouteModel {
  final String id;
  final String name;
  final String description;
  final List<LatLng> coordinates;
  final double totalDistance;
  final double totalElevationGain;
  final double averageDifficulty;
  final String difficulty;
  final List<RouteSectionModel> sections;
  final List<PointOfInterestModel> pointsOfInterest;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;
  final bool isPublic;
  final bool isFavorite;

  RouteModel({
    required this.id,
    required this.name,
    required this.description,
    required this.coordinates,
    required this.totalDistance,
    required this.totalElevationGain,
    required this.averageDifficulty,
    required this.difficulty,
    required this.sections,
    required this.pointsOfInterest,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.isPublic = false,
    this.isFavorite = false,
  });

  factory RouteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RouteModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      coordinates: _parseCoordinates(data['coordinates'] ?? []),
      totalDistance: (data['totalDistance'] ?? 0.0).toDouble(),
      totalElevationGain: (data['totalElevationGain'] ?? 0.0).toDouble(),
      averageDifficulty: (data['averageDifficulty'] ?? 0.0).toDouble(),
      difficulty: data['difficulty'] ?? 'moderate',
      sections: _parseSections(data['sections'] ?? []),
      pointsOfInterest: _parsePointsOfInterest(data['pointsOfInterest'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      userId: data['userId'],
      isPublic: data['isPublic'] ?? false,
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'coordinates': coordinates
          .map((coord) => {
                'latitude': coord.latitude,
                'longitude': coord.longitude,
              })
          .toList(),
      'totalDistance': totalDistance,
      'totalElevationGain': totalElevationGain,
      'averageDifficulty': averageDifficulty,
      'difficulty': difficulty,
      'sections': sections.map((section) => section.toFirestore()).toList(),
      'pointsOfInterest': pointsOfInterest.map((poi) => poi.toFirestore()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'userId': userId,
      'isPublic': isPublic,
      'isFavorite': isFavorite,
    };
  }

  static List<LatLng> _parseCoordinates(List<dynamic> coordinates) {
    return coordinates.map((coord) {
      final data = coord as Map<String, dynamic>;
      return LatLng(
        (data['latitude'] ?? 0.0).toDouble(),
        (data['longitude'] ?? 0.0).toDouble(),
      );
    }).toList();
  }

  static List<RouteSectionModel> _parseSections(List<dynamic> sections) {
    return sections.map((section) => RouteSectionModel.fromFirestore(section)).toList();
  }

  static List<PointOfInterestModel> _parsePointsOfInterest(List<dynamic> points) {
    return points.map((point) => PointOfInterestModel.fromFirestore(point)).toList();
  }

  // Конвертація до Entity
  RouteEntity toEntity() {
    return RouteEntity(
      id: id,
      name: name,
      description: description,
      coordinates: coordinates,
      totalDistance: totalDistance,
      totalElevationGain: totalElevationGain,
      averageDifficulty: averageDifficulty,
      difficulty: _parseDifficulty(difficulty),
      sections: sections.map((section) => section.toEntity()).toList(),
      pointsOfInterest: pointsOfInterest.map((poi) => poi.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      userId: userId,
      isPublic: isPublic,
      isFavorite: isFavorite,
    );
  }

  // Конвертація з Entity
  factory RouteModel.fromEntity(RouteEntity entity) {
    return RouteModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      coordinates: entity.coordinates,
      totalDistance: entity.totalDistance,
      totalElevationGain: entity.totalElevationGain,
      averageDifficulty: entity.averageDifficulty,
      difficulty: entity.difficulty.name,
      sections: entity.sections.map((section) => RouteSectionModel.fromEntity(section)).toList(),
      pointsOfInterest: entity.pointsOfInterest.map((poi) => PointOfInterestModel.fromEntity(poi)).toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      userId: entity.userId,
      isPublic: entity.isPublic,
      isFavorite: entity.isFavorite,
    );
  }

  RouteDifficulty _parseDifficulty(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return RouteDifficulty.easy;
      case 'moderate':
        return RouteDifficulty.moderate;
      case 'hard':
        return RouteDifficulty.hard;
      case 'expert':
        return RouteDifficulty.expert;
      default:
        return RouteDifficulty.moderate;
    }
  }
}

class RouteSectionModel {
  final String id;
  final List<LatLng> coordinates;
  final double distance;
  final double elevationGain;
  final String surfaceType;
  final double windEffect;
  final double difficulty;
  final double averageSpeed;
  final String? notes;

  RouteSectionModel({
    required this.id,
    required this.coordinates,
    required this.distance,
    required this.elevationGain,
    required this.surfaceType,
    required this.windEffect,
    required this.difficulty,
    required this.averageSpeed,
    this.notes,
  });

  factory RouteSectionModel.fromFirestore(Map<String, dynamic> data) {
    return RouteSectionModel(
      id: data['id'] ?? '',
      coordinates: RouteModel._parseCoordinates(data['coordinates'] ?? []),
      distance: (data['distance'] ?? 0.0).toDouble(),
      elevationGain: (data['elevationGain'] ?? 0.0).toDouble(),
      surfaceType: data['surfaceType'] ?? 'asphalt',
      windEffect: (data['windEffect'] ?? 0.0).toDouble(),
      difficulty: (data['difficulty'] ?? 0.0).toDouble(),
      averageSpeed: (data['averageSpeed'] ?? 0.0).toDouble(),
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'coordinates': coordinates
          .map((coord) => {
                'latitude': coord.latitude,
                'longitude': coord.longitude,
              })
          .toList(),
      'distance': distance,
      'elevationGain': elevationGain,
      'surfaceType': surfaceType,
      'windEffect': windEffect,
      'difficulty': difficulty,
      'averageSpeed': averageSpeed,
      'notes': notes,
    };
  }

  RouteSectionEntity toEntity() {
    return RouteSectionEntity(
      id: id,
      coordinates: coordinates,
      distance: distance,
      elevationGain: elevationGain,
      surfaceType: _parseSurfaceType(surfaceType),
      windEffect: windEffect,
      difficulty: difficulty,
      averageSpeed: averageSpeed,
      notes: notes,
    );
  }

  factory RouteSectionModel.fromEntity(RouteSectionEntity entity) {
    return RouteSectionModel(
      id: entity.id,
      coordinates: entity.coordinates,
      distance: entity.distance,
      elevationGain: entity.elevationGain,
      surfaceType: entity.surfaceType.name,
      windEffect: entity.windEffect,
      difficulty: entity.difficulty,
      averageSpeed: entity.averageSpeed,
      notes: entity.notes,
    );
  }

  RoadSurfaceType _parseSurfaceType(String surfaceType) {
    switch (surfaceType) {
      case 'asphalt':
        return RoadSurfaceType.asphalt;
      case 'concrete':
        return RoadSurfaceType.concrete;
      case 'gravel':
        return RoadSurfaceType.gravel;
      case 'dirt':
        return RoadSurfaceType.dirt;
      case 'cobblestone':
        return RoadSurfaceType.cobblestone;
      case 'grass':
        return RoadSurfaceType.grass;
      case 'sand':
        return RoadSurfaceType.sand;
      default:
        return RoadSurfaceType.asphalt;
    }
  }
}

class PointOfInterestModel {
  final String id;
  final String name;
  final String type;
  final LatLng coordinates;
  final String description;
  final String? imageUrl;
  final double? rating;
  final Map<String, dynamic>? metadata;

  PointOfInterestModel({
    required this.id,
    required this.name,
    required this.type,
    required this.coordinates,
    required this.description,
    this.imageUrl,
    this.rating,
    this.metadata,
  });

  factory PointOfInterestModel.fromFirestore(Map<String, dynamic> data) {
    final coordData = data['coordinates'] as Map<String, dynamic>;
    return PointOfInterestModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      coordinates: LatLng(
        (coordData['latitude'] ?? 0.0).toDouble(),
        (coordData['longitude'] ?? 0.0).toDouble(),
      ),
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      rating: data['rating']?.toDouble(),
      metadata: data['metadata'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'coordinates': {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
      },
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'metadata': metadata,
    };
  }

  PointOfInterestEntity toEntity() {
    return PointOfInterestEntity(
      id: id,
      name: name,
      type: type,
      coordinates: coordinates,
      description: description,
      imageUrl: imageUrl,
      rating: rating,
      metadata: metadata,
    );
  }

  factory PointOfInterestModel.fromEntity(PointOfInterestEntity entity) {
    return PointOfInterestModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      coordinates: entity.coordinates,
      description: entity.description,
      imageUrl: entity.imageUrl,
      rating: entity.rating,
      metadata: entity.metadata,
    );
  }
}
