import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/map_layer_entity.dart';
import '../entities/marker_entity.dart';
import 'package:latlong2/latlong.dart';

abstract class MapRepository {
  // Управління шарами карти
  Future<Either<Failure, List<MapLayerEntity>>> getAvailableLayers();
  Future<Either<Failure, MapLayerEntity>> getLayerById(String layerId);
  Future<Either<Failure, Unit>> setLayerVisibility(String layerId, bool isVisible);
  Future<Either<Failure, List<MapLayerEntity>>> getVisibleLayers();

  // Вітрові шари
  Future<Either<Failure, WindLayerEntity>> getWindLayer();
  Future<Either<Failure, Unit>> updateWindLayer(WindLayerEntity windLayer);
  Future<Either<Failure, List<WindDataEntity>>> getWindDataForArea({
    required LatLng topLeft,
    required LatLng bottomRight,
  });

  // Управління мітками
  Future<Either<Failure, List<MarkerEntity>>> getAllMarkers();
  Future<Either<Failure, List<MarkerEntity>>> getMarkersByType(MarkerType type);
  Future<Either<Failure, List<MarkerEntity>>> getMarkersByCategory(String categoryId);
  Future<Either<Failure, MarkerEntity>> getMarkerById(String markerId);

  // Пошук міток
  Future<Either<Failure, MarkerSearchResultEntity>> searchMarkers({
    required String query,
    MarkerType? type,
    String? categoryId,
    LatLng? center,
    double? radius,
    MarkerSearchType searchType = MarkerSearchType.byName,
  });

  // Геокодування
  Future<Either<Failure, LatLng>> geocodeAddress(String address);
  Future<Either<Failure, String>> reverseGeocode(LatLng coordinates);

  // Категорії міток
  Future<Either<Failure, List<MarkerCategoryEntity>>> getMarkerCategories();
  Future<Either<Failure, MarkerCategoryEntity>> getCategoryById(String categoryId);
  Future<Either<Failure, Unit>> setCategoryVisibility(String categoryId, bool isVisible);

  // Кешування
  Future<Either<Failure, Unit>> cacheMarkers(List<MarkerEntity> markers);
  Future<Either<Failure, List<MarkerEntity>?>> getCachedMarkers();
  Future<Either<Failure, Unit>> clearMarkerCache();
}
