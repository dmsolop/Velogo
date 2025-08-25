import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/exceptions.dart';
import '../models/map_layer_model.dart';
import '../models/marker_model.dart';

abstract class MapRemoteDataSource {
  // Шари карти
  Future<List<MapLayerModel>> getAvailableLayers();
  Future<MapLayerModel> getLayerById(String layerId);
  Future<void> setLayerVisibility(String layerId, bool isVisible);

  // Вітрові дані
  Future<WindLayerModel> getWindLayer();
  Future<void> updateWindLayer(WindLayerModel windLayer);
  Future<List<WindDataModel>> getWindDataForArea({
    required LatLng topLeft,
    required LatLng bottomRight,
  });

  // Мітки
  Future<List<MarkerModel>> getAllMarkers();
  Future<List<MarkerModel>> getMarkersByType(String type);
  Future<List<MarkerModel>> getMarkersByCategory(String categoryId);
  Future<MarkerModel> getMarkerById(String markerId);

  // Пошук міток
  Future<MarkerSearchResultModel> searchMarkers({
    required String query,
    String? type,
    String? categoryId,
    LatLng? center,
    double? radius,
    String searchType = 'byName',
  });

  // Геокодування
  Future<LatLng> geocodeAddress(String address);
  Future<String> reverseGeocode(LatLng coordinates);

  // Категорії міток
  Future<List<MarkerCategoryModel>> getMarkerCategories();
  Future<MarkerCategoryModel> getCategoryById(String categoryId);
  Future<void> setCategoryVisibility(String categoryId, bool isVisible);
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final FirebaseFirestore firestore;

  MapRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<MapLayerModel>> getAvailableLayers() async {
    try {
      final querySnapshot = await firestore.collection('map_layers').get();
      return querySnapshot.docs.map((doc) => MapLayerModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException('Failed to get map layers: $e');
    }
  }

  @override
  Future<MapLayerModel> getLayerById(String layerId) async {
    try {
      final doc = await firestore.collection('map_layers').doc(layerId).get();
      if (!doc.exists) {
        throw ServerException('Map layer not found');
      }
      return MapLayerModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Failed to get map layer: $e');
    }
  }

  @override
  Future<void> setLayerVisibility(String layerId, bool isVisible) async {
    try {
      await firestore.collection('map_layers').doc(layerId).update({'isVisible': isVisible});
    } catch (e) {
      throw ServerException('Failed to update layer visibility: $e');
    }
  }

  @override
  Future<WindLayerModel> getWindLayer() async {
    try {
      final doc = await firestore.collection('wind_layers').doc('current').get();
      if (!doc.exists) {
        throw ServerException('Wind layer not found');
      }
      return WindLayerModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Failed to get wind layer: $e');
    }
  }

  @override
  Future<void> updateWindLayer(WindLayerModel windLayer) async {
    try {
      await firestore.collection('wind_layers').doc('current').set(windLayer.toFirestore());
    } catch (e) {
      throw ServerException('Failed to update wind layer: $e');
    }
  }

  @override
  Future<List<WindDataModel>> getWindDataForArea({
    required LatLng topLeft,
    required LatLng bottomRight,
  }) async {
    try {
      // TODO: Implement wind data retrieval from external API
      // This would integrate with weather services like OpenWeatherMap
      return [];
    } catch (e) {
      throw ServerException('Failed to get wind data: $e');
    }
  }

  @override
  Future<List<MarkerModel>> getAllMarkers() async {
    try {
      final querySnapshot = await firestore.collection('markers').get();
      return querySnapshot.docs.map((doc) => MarkerModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException('Failed to get markers: $e');
    }
  }

  @override
  Future<List<MarkerModel>> getMarkersByType(String type) async {
    try {
      final querySnapshot = await firestore.collection('markers').where('type', isEqualTo: type).get();
      return querySnapshot.docs.map((doc) => MarkerModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException('Failed to get markers by type: $e');
    }
  }

  @override
  Future<List<MarkerModel>> getMarkersByCategory(String categoryId) async {
    try {
      final querySnapshot = await firestore.collection('markers').where('categoryId', isEqualTo: categoryId).get();
      return querySnapshot.docs.map((doc) => MarkerModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException('Failed to get markers by category: $e');
    }
  }

  @override
  Future<MarkerModel> getMarkerById(String markerId) async {
    try {
      final doc = await firestore.collection('markers').doc(markerId).get();
      if (!doc.exists) {
        throw ServerException('Marker not found');
      }
      return MarkerModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Failed to get marker: $e');
    }
  }

  @override
  Future<MarkerSearchResultModel> searchMarkers({
    required String query,
    String? type,
    String? categoryId,
    LatLng? center,
    double? radius,
    String searchType = 'byName',
  }) async {
    try {
      // TODO: Implement marker search logic
      // This would integrate with geocoding services
      return MarkerSearchResultModel(
        markers: [],
        totalCount: 0,
        searchQuery: query,
        searchType: searchType,
      );
    } catch (e) {
      throw ServerException('Failed to search markers: $e');
    }
  }

  @override
  Future<LatLng> geocodeAddress(String address) async {
    try {
      // TODO: Implement geocoding with external service
      // This would integrate with services like Google Maps Geocoding API
      return LatLng(0, 0);
    } catch (e) {
      throw ServerException('Failed to geocode address: $e');
    }
  }

  @override
  Future<String> reverseGeocode(LatLng coordinates) async {
    try {
      // TODO: Implement reverse geocoding with external service
      return 'Unknown location';
    } catch (e) {
      throw ServerException('Failed to reverse geocode: $e');
    }
  }

  @override
  Future<List<MarkerCategoryModel>> getMarkerCategories() async {
    try {
      final querySnapshot = await firestore.collection('marker_categories').get();
      return querySnapshot.docs.map((doc) => MarkerCategoryModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException('Failed to get marker categories: $e');
    }
  }

  @override
  Future<MarkerCategoryModel> getCategoryById(String categoryId) async {
    try {
      final doc = await firestore.collection('marker_categories').doc(categoryId).get();
      if (!doc.exists) {
        throw ServerException('Marker category not found');
      }
      return MarkerCategoryModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Failed to get marker category: $e');
    }
  }

  @override
  Future<void> setCategoryVisibility(String categoryId, bool isVisible) async {
    try {
      await firestore.collection('marker_categories').doc(categoryId).update({'isVisible': isVisible});
    } catch (e) {
      throw ServerException('Failed to update category visibility: $e');
    }
  }
}
