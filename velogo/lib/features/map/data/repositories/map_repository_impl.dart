import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/map_layer_entity.dart';
import '../../domain/entities/marker_entity.dart';
import '../../domain/repositories/map_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../models/map_layer_model.dart';
import '../models/marker_model.dart';
import '../datasources/map_remote_data_source.dart';

// Helper function for Unit
Either<Failure, Unit> _successUnit() => Right(unit);

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;
  final String _markersBoxName = "markers_cache";
  final String _layersBoxName = "layers_cache";

  MapRepositoryImpl({required this.remoteDataSource});

  Future<Box<MarkerModel>> _openMarkersBox() async {
    return await Hive.openBox<MarkerModel>(_markersBoxName);
  }

  Future<Box<MapLayerModel>> _openLayersBox() async {
    return await Hive.openBox<MapLayerModel>(_layersBoxName);
  }

  @override
  Future<Either<Failure, List<MapLayerEntity>>> getAvailableLayers() async {
    try {
      final layers = await remoteDataSource.getAvailableLayers();
      return Right(layers.map((layer) => layer.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get map layers: $e'));
    }
  }

  @override
  Future<Either<Failure, MapLayerEntity>> getLayerById(String layerId) async {
    try {
      final layer = await remoteDataSource.getLayerById(layerId);
      return Right(layer.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get map layer: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> setLayerVisibility(String layerId, bool isVisible) async {
    try {
      await remoteDataSource.setLayerVisibility(layerId, isVisible);
      return _successUnit();
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to set layer visibility: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MapLayerEntity>>> getVisibleLayers() async {
    try {
      final layers = await remoteDataSource.getAvailableLayers();
      final visibleLayers = layers.where((layer) => layer.isVisible).toList();
      return Right(visibleLayers.map((layer) => layer.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get visible layers: $e'));
    }
  }

  @override
  Future<Either<Failure, WindLayerEntity>> getWindLayer() async {
    try {
      final windLayer = await remoteDataSource.getWindLayer();
      return Right(windLayer.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get wind layer: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateWindLayer(WindLayerEntity windLayer) async {
    try {
      final windLayerModel = WindLayerModel.fromEntity(windLayer);
      await remoteDataSource.updateWindLayer(windLayerModel);
      return _successUnit();
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update wind layer: $e'));
    }
  }

  @override
  Future<Either<Failure, List<WindDataEntity>>> getWindDataForArea({
    required LatLng topLeft,
    required LatLng bottomRight,
  }) async {
    try {
      final windData = await remoteDataSource.getWindDataForArea(
        topLeft: topLeft,
        bottomRight: bottomRight,
      );
      return Right(windData.map((data) => data.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get wind data: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MarkerEntity>>> getAllMarkers() async {
    try {
      final markers = await remoteDataSource.getAllMarkers();
      return Right(markers.map((marker) => marker.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get markers: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MarkerEntity>>> getMarkersByType(MarkerType type) async {
    try {
      final markers = await remoteDataSource.getMarkersByType(type.name);
      return Right(markers.map((marker) => marker.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get markers by type: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MarkerEntity>>> getMarkersByCategory(String categoryId) async {
    try {
      final markers = await remoteDataSource.getMarkersByCategory(categoryId);
      return Right(markers.map((marker) => marker.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get markers by category: $e'));
    }
  }

  @override
  Future<Either<Failure, MarkerEntity>> getMarkerById(String markerId) async {
    try {
      final marker = await remoteDataSource.getMarkerById(markerId);
      return Right(marker.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get marker: $e'));
    }
  }

  @override
  Future<Either<Failure, MarkerSearchResultEntity>> searchMarkers({
    required String query,
    MarkerType? type,
    String? categoryId,
    LatLng? center,
    double? radius,
    MarkerSearchType searchType = MarkerSearchType.byName,
  }) async {
    try {
      final result = await remoteDataSource.searchMarkers(
        query: query,
        type: type?.name,
        categoryId: categoryId,
        center: center,
        radius: radius,
        searchType: searchType.name,
      );
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to search markers: $e'));
    }
  }

  @override
  Future<Either<Failure, LatLng>> geocodeAddress(String address) async {
    try {
      final coordinates = await remoteDataSource.geocodeAddress(address);
      return Right(coordinates);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to geocode address: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> reverseGeocode(LatLng coordinates) async {
    try {
      final address = await remoteDataSource.reverseGeocode(coordinates);
      return Right(address);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to reverse geocode: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MarkerCategoryEntity>>> getMarkerCategories() async {
    try {
      final categories = await remoteDataSource.getMarkerCategories();
      return Right(categories.map((category) => category.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get marker categories: $e'));
    }
  }

  @override
  Future<Either<Failure, MarkerCategoryEntity>> getCategoryById(String categoryId) async {
    try {
      final category = await remoteDataSource.getCategoryById(categoryId);
      return Right(category.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get marker category: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> setCategoryVisibility(String categoryId, bool isVisible) async {
    try {
      await remoteDataSource.setCategoryVisibility(categoryId, isVisible);
      return _successUnit();
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to set category visibility: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> cacheMarkers(List<MarkerEntity> markers) async {
    try {
      final box = await _openMarkersBox();
      for (final marker in markers) {
        final markerModel = MarkerModel.fromEntity(marker);
        await box.put(marker.id, markerModel);
      }
      return _successUnit();
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to cache markers: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MarkerEntity>?>> getCachedMarkers() async {
    try {
      final box = await _openMarkersBox();
      final markers = box.values.toList();
      if (markers.isNotEmpty) {
        return Right(markers.map((marker) => marker.toEntity()).toList());
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get cached markers: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearMarkerCache() async {
    try {
      final box = await _openMarkersBox();
      await box.clear();
      return _successUnit();
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to clear marker cache: $e'));
    }
  }
}
