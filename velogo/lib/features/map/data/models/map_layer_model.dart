import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/map_layer_entity.dart';

class MapLayerModel {
  final String id;
  final String name;
  final String displayName;
  final String type;
  final bool isVisible;
  final String urlTemplate;
  final List<String>? subdomains;
  final Map<String, dynamic>? options;
  final int? maxZoom;
  final int? minZoom;

  MapLayerModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.type,
    required this.isVisible,
    required this.urlTemplate,
    this.subdomains,
    this.options,
    this.maxZoom,
    this.minZoom,
  });

  factory MapLayerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MapLayerModel(
      id: doc.id,
      name: data['name'] ?? '',
      displayName: data['displayName'] ?? '',
      type: data['type'] ?? 'standard',
      isVisible: data['isVisible'] ?? true,
      urlTemplate: data['urlTemplate'] ?? '',
      subdomains: data['subdomains']?.cast<String>(),
      options: data['options'],
      maxZoom: data['maxZoom'],
      minZoom: data['minZoom'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'displayName': displayName,
      'type': type,
      'isVisible': isVisible,
      'urlTemplate': urlTemplate,
      'subdomains': subdomains,
      'options': options,
      'maxZoom': maxZoom,
      'minZoom': minZoom,
    };
  }

  MapLayerEntity toEntity() {
    return MapLayerEntity(
      id: id,
      name: name,
      displayName: displayName,
      type: _parseLayerType(type),
      isVisible: isVisible,
      urlTemplate: urlTemplate,
      subdomains: subdomains,
      options: options,
      maxZoom: maxZoom,
      minZoom: minZoom,
    );
  }

  factory MapLayerModel.fromEntity(MapLayerEntity entity) {
    return MapLayerModel(
      id: entity.id,
      name: entity.name,
      displayName: entity.displayName,
      type: entity.type.name,
      isVisible: entity.isVisible,
      urlTemplate: entity.urlTemplate,
      subdomains: entity.subdomains,
      options: entity.options,
      maxZoom: entity.maxZoom,
      minZoom: entity.minZoom,
    );
  }

  MapLayerType _parseLayerType(String type) {
    switch (type) {
      case 'standard':
        return MapLayerType.standard;
      case 'satellite':
        return MapLayerType.satellite;
      case 'terrain':
        return MapLayerType.terrain;
      case 'wind':
        return MapLayerType.wind;
      case 'weather':
        return MapLayerType.weather;
      case 'traffic':
        return MapLayerType.traffic;
      case 'cycling':
        return MapLayerType.cycling;
      case 'custom':
        return MapLayerType.custom;
      default:
        return MapLayerType.standard;
    }
  }
}

class WindLayerModel {
  final String id;
  final String name;
  final bool isVisible;
  final bool isAnimated;
  final double opacity;
  final int animationSpeed;
  final WindDataModel windData;

  WindLayerModel({
    required this.id,
    required this.name,
    required this.isVisible,
    required this.isAnimated,
    required this.opacity,
    required this.animationSpeed,
    required this.windData,
  });

  factory WindLayerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WindLayerModel(
      id: doc.id,
      name: data['name'] ?? '',
      isVisible: data['isVisible'] ?? true,
      isAnimated: data['isAnimated'] ?? false,
      opacity: (data['opacity'] ?? 1.0).toDouble(),
      animationSpeed: data['animationSpeed'] ?? 1000,
      windData: WindDataModel.fromFirestore(data['windData'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'isVisible': isVisible,
      'isAnimated': isAnimated,
      'opacity': opacity,
      'animationSpeed': animationSpeed,
      'windData': windData.toFirestore(),
    };
  }

  WindLayerEntity toEntity() {
    return WindLayerEntity(
      id: id,
      name: name,
      isVisible: isVisible,
      isAnimated: isAnimated,
      opacity: opacity,
      animationSpeed: animationSpeed,
      windData: windData.toEntity(),
    );
  }

  factory WindLayerModel.fromEntity(WindLayerEntity entity) {
    return WindLayerModel(
      id: entity.id,
      name: entity.name,
      isVisible: entity.isVisible,
      isAnimated: entity.isAnimated,
      opacity: entity.opacity,
      animationSpeed: entity.animationSpeed,
      windData: WindDataModel.fromEntity(entity.windData),
    );
  }
}

class WindDataModel {
  final double windSpeed;
  final double windDirection;
  final double windGust;
  final DateTime timestamp;
  final LatLng coordinates;

  WindDataModel({
    required this.windSpeed,
    required this.windDirection,
    required this.windGust,
    required this.timestamp,
    required this.coordinates,
  });

  factory WindDataModel.fromFirestore(Map<String, dynamic> data) {
    final coordData = data['coordinates'] as Map<String, dynamic>;
    return WindDataModel(
      windSpeed: (data['windSpeed'] ?? 0.0).toDouble(),
      windDirection: (data['windDirection'] ?? 0.0).toDouble(),
      windGust: (data['windGust'] ?? 0.0).toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      coordinates: LatLng(
        (coordData['latitude'] ?? 0.0).toDouble(),
        (coordData['longitude'] ?? 0.0).toDouble(),
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'windGust': windGust,
      'timestamp': Timestamp.fromDate(timestamp),
      'coordinates': {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
      },
    };
  }

  WindDataEntity toEntity() {
    return WindDataEntity(
      windSpeed: windSpeed,
      windDirection: windDirection,
      windGust: windGust,
      timestamp: timestamp,
      coordinates: coordinates,
    );
  }

  factory WindDataModel.fromEntity(WindDataEntity entity) {
    return WindDataModel(
      windSpeed: entity.windSpeed,
      windDirection: entity.windDirection,
      windGust: entity.windGust,
      timestamp: entity.timestamp,
      coordinates: entity.coordinates,
    );
  }
}
