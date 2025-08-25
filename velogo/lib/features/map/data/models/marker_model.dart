import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/marker_entity.dart';

class MarkerModel {
  final String id;
  final String name;
  final String type;
  final LatLng coordinates;
  final String description;
  final String? iconPath;
  final String? imageUrl;
  final double? rating;
  final Map<String, dynamic>? metadata;
  final bool isVisible;
  final bool isSelected;

  MarkerModel({
    required this.id,
    required this.name,
    required this.type,
    required this.coordinates,
    required this.description,
    this.iconPath,
    this.imageUrl,
    this.rating,
    this.metadata,
    this.isVisible = true,
    this.isSelected = false,
  });

  factory MarkerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final coordData = data['coordinates'] as Map<String, dynamic>;
    return MarkerModel(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      coordinates: LatLng(
        (coordData['latitude'] ?? 0.0).toDouble(),
        (coordData['longitude'] ?? 0.0).toDouble(),
      ),
      description: data['description'] ?? '',
      iconPath: data['iconPath'],
      imageUrl: data['imageUrl'],
      rating: data['rating']?.toDouble(),
      metadata: data['metadata'],
      isVisible: data['isVisible'] ?? true,
      isSelected: data['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'type': type,
      'coordinates': {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
      },
      'description': description,
      'iconPath': iconPath,
      'imageUrl': imageUrl,
      'rating': rating,
      'metadata': metadata,
      'isVisible': isVisible,
      'isSelected': isSelected,
    };
  }

  MarkerEntity toEntity() {
    return MarkerEntity(
      id: id,
      name: name,
      type: _parseMarkerType(type),
      coordinates: coordinates,
      description: description,
      iconPath: iconPath,
      imageUrl: imageUrl,
      rating: rating,
      metadata: metadata,
      isVisible: isVisible,
      isSelected: isSelected,
    );
  }

  factory MarkerModel.fromEntity(MarkerEntity entity) {
    return MarkerModel(
      id: entity.id,
      name: entity.name,
      type: entity.type.name,
      coordinates: entity.coordinates,
      description: entity.description,
      iconPath: entity.iconPath,
      imageUrl: entity.imageUrl,
      rating: entity.rating,
      metadata: entity.metadata,
      isVisible: entity.isVisible,
      isSelected: entity.isSelected,
    );
  }

  MarkerType _parseMarkerType(String type) {
    switch (type) {
      case 'start':
        return MarkerType.start;
      case 'end':
        return MarkerType.end;
      case 'waypoint':
        return MarkerType.waypoint;
      case 'historical':
        return MarkerType.historical;
      case 'shop':
        return MarkerType.shop;
      case 'water':
        return MarkerType.water;
      case 'parking':
        return MarkerType.parking;
      case 'cafe':
        return MarkerType.cafe;
      case 'hotel':
        return MarkerType.hotel;
      case 'gasStation':
        return MarkerType.gasStation;
      case 'repair':
        return MarkerType.repair;
      case 'toilet':
        return MarkerType.toilet;
      case 'viewpoint':
        return MarkerType.viewpoint;
      case 'park':
        return MarkerType.park;
      case 'forest':
        return MarkerType.forest;
      case 'lake':
        return MarkerType.lake;
      case 'busStop':
        return MarkerType.busStop;
      case 'trainStation':
        return MarkerType.trainStation;
      case 'bikeRental':
        return MarkerType.bikeRental;
      case 'police':
        return MarkerType.police;
      case 'hospital':
        return MarkerType.hospital;
      case 'pharmacy':
        return MarkerType.pharmacy;
      case 'custom':
        return MarkerType.custom;
      default:
        return MarkerType.custom;
    }
  }
}

class MarkerCategoryModel {
  final String id;
  final String name;
  final String displayName;
  final List<String> markerTypes;
  final String iconPath;
  final bool isVisible;
  final int order;
  final String? description;

  MarkerCategoryModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.markerTypes,
    required this.iconPath,
    required this.isVisible,
    required this.order,
    this.description,
  });

  factory MarkerCategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MarkerCategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      displayName: data['displayName'] ?? '',
      markerTypes: List<String>.from(data['markerTypes'] ?? []),
      iconPath: data['iconPath'] ?? '',
      isVisible: data['isVisible'] ?? true,
      order: data['order'] ?? 0,
      description: data['description'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'displayName': displayName,
      'markerTypes': markerTypes,
      'iconPath': iconPath,
      'isVisible': isVisible,
      'order': order,
      'description': description,
    };
  }

  MarkerCategoryEntity toEntity() {
    return MarkerCategoryEntity(
      id: id,
      name: name,
      displayName: displayName,
      markerTypes: markerTypes.map((type) => _parseMarkerType(type)).toList(),
      iconPath: iconPath,
      isVisible: isVisible,
      order: order,
      description: description,
    );
  }

  factory MarkerCategoryModel.fromEntity(MarkerCategoryEntity entity) {
    return MarkerCategoryModel(
      id: entity.id,
      name: entity.name,
      displayName: entity.displayName,
      markerTypes: entity.markerTypes.map((type) => type.name).toList(),
      iconPath: entity.iconPath,
      isVisible: entity.isVisible,
      order: entity.order,
      description: entity.description,
    );
  }

  MarkerType _parseMarkerType(String type) {
    // Використовуємо ту ж логіку що й в MarkerModel
    switch (type) {
      case 'start':
        return MarkerType.start;
      case 'end':
        return MarkerType.end;
      case 'waypoint':
        return MarkerType.waypoint;
      case 'historical':
        return MarkerType.historical;
      case 'shop':
        return MarkerType.shop;
      case 'water':
        return MarkerType.water;
      case 'parking':
        return MarkerType.parking;
      case 'cafe':
        return MarkerType.cafe;
      case 'hotel':
        return MarkerType.hotel;
      case 'gasStation':
        return MarkerType.gasStation;
      case 'repair':
        return MarkerType.repair;
      case 'toilet':
        return MarkerType.toilet;
      case 'viewpoint':
        return MarkerType.viewpoint;
      case 'park':
        return MarkerType.park;
      case 'forest':
        return MarkerType.forest;
      case 'lake':
        return MarkerType.lake;
      case 'busStop':
        return MarkerType.busStop;
      case 'trainStation':
        return MarkerType.trainStation;
      case 'bikeRental':
        return MarkerType.bikeRental;
      case 'police':
        return MarkerType.police;
      case 'hospital':
        return MarkerType.hospital;
      case 'pharmacy':
        return MarkerType.pharmacy;
      case 'custom':
        return MarkerType.custom;
      default:
        return MarkerType.custom;
    }
  }
}

class MarkerSearchResultModel {
  final List<MarkerModel> markers;
  final int totalCount;
  final String searchQuery;
  final String searchType;
  final List<MarkerCategoryModel>? categories;

  MarkerSearchResultModel({
    required this.markers,
    required this.totalCount,
    required this.searchQuery,
    required this.searchType,
    this.categories,
  });

  factory MarkerSearchResultModel.fromFirestore(Map<String, dynamic> data) {
    return MarkerSearchResultModel(
      markers: (data['markers'] as List<dynamic>?)?.map((marker) => MarkerModel.fromFirestore(marker as DocumentSnapshot)).toList() ?? [],
      totalCount: data['totalCount'] ?? 0,
      searchQuery: data['searchQuery'] ?? '',
      searchType: data['searchType'] ?? 'byName',
      categories: (data['categories'] as List<dynamic>?)?.map((category) => MarkerCategoryModel.fromFirestore(category as DocumentSnapshot)).toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'markers': markers.map((marker) => marker.toFirestore()).toList(),
      'totalCount': totalCount,
      'searchQuery': searchQuery,
      'searchType': searchType,
      'categories': categories?.map((category) => category.toFirestore()).toList(),
    };
  }

  MarkerSearchResultEntity toEntity() {
    return MarkerSearchResultEntity(
      markers: markers.map((marker) => marker.toEntity()).toList(),
      totalCount: totalCount,
      searchQuery: searchQuery,
      searchType: _parseSearchType(searchType),
      categories: categories?.map((category) => category.toEntity()).toList(),
    );
  }

  factory MarkerSearchResultModel.fromEntity(MarkerSearchResultEntity entity) {
    return MarkerSearchResultModel(
      markers: entity.markers.map((marker) => MarkerModel.fromEntity(marker)).toList(),
      totalCount: entity.totalCount,
      searchQuery: entity.searchQuery,
      searchType: entity.searchType.name,
      categories: entity.categories?.map((category) => MarkerCategoryModel.fromEntity(category)).toList(),
    );
  }

  MarkerSearchType _parseSearchType(String searchType) {
    switch (searchType) {
      case 'byName':
        return MarkerSearchType.byName;
      case 'byType':
        return MarkerSearchType.byType;
      case 'byCategory':
        return MarkerSearchType.byCategory;
      case 'byLocation':
        return MarkerSearchType.byLocation;
      case 'byRadius':
        return MarkerSearchType.byRadius;
      case 'custom':
        return MarkerSearchType.custom;
      default:
        return MarkerSearchType.byName;
    }
  }
}
