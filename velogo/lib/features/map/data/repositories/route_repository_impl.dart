import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/route_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../models/route_model.dart';
import '../datasources/route_remote_data_source.dart';

// Helper function for Unit
Either<Failure, Unit> _successUnit() => Right(unit);

class RouteRepositoryImpl implements RouteRepository {
  final RouteRemoteDataSource remoteDataSource;
  final String _boxName = "routes_cache";

  RouteRepositoryImpl({required this.remoteDataSource});

  Future<Box<RouteModel>> _openBox() async {
    return await Hive.openBox<RouteModel>(_boxName);
  }

  @override
  Future<Either<Failure, List<RouteEntity>>> getAllRoutes() async {
    try {
      final routes = await remoteDataSource.getAllRoutes();
      return Right(routes.map((route) => route.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get routes: $e'));
    }
  }

  @override
  Future<Either<Failure, RouteEntity>> getRouteById(String routeId) async {
    try {
      final route = await remoteDataSource.getRouteById(routeId);
      return Right(route.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get route: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RouteEntity>>> getRoutesByUserId(String userId) async {
    try {
      final routes = await remoteDataSource.getRoutesByUserId(userId);
      return Right(routes.map((route) => route.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get user routes: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RouteEntity>>> getPublicRoutes() async {
    try {
      final routes = await remoteDataSource.getPublicRoutes();
      return Right(routes.map((route) => route.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get public routes: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RouteEntity>>> getFavoriteRoutes(String userId) async {
    try {
      final routes = await remoteDataSource.getRoutesByUserId(userId);
      final favoriteRoutes = routes.where((route) => route.isFavorite).toList();
      return Right(favoriteRoutes.map((route) => route.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get favorite routes: $e'));
    }
  }

  @override
  Future<Either<Failure, RouteEntity>> createRoute(RouteEntity route) async {
    try {
      final routeModel = RouteModel.fromEntity(route);
      final createdRoute = await remoteDataSource.createRoute(routeModel);
      return Right(createdRoute.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to create route: $e'));
    }
  }

  @override
  Future<Either<Failure, RouteEntity>> updateRoute(RouteEntity route) async {
    try {
      final routeModel = RouteModel.fromEntity(route);
      final updatedRoute = await remoteDataSource.updateRoute(routeModel);
      return Right(updatedRoute.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update route: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRoute(String routeId) async {
    try {
      await remoteDataSource.deleteRoute(routeId);
      return _successUnit();
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to delete route: $e'));
    }
  }

  @override
  Future<Either<Failure, RouteEntity>> createAutomaticRoute({
    required LatLng startPoint,
    required LatLng endPoint,
    required RouteDifficulty difficulty,
    required double distance,
    String? userId,
  }) async {
    try {
      final route = await remoteDataSource.createAutomaticRoute(
        startPoint: startPoint,
        endPoint: endPoint,
        difficulty: difficulty.name,
        distance: distance,
        userId: userId,
      );
      return Right(route.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to create automatic route: $e'));
    }
  }

  @override
  Future<Either<Failure, RouteEntity>> editRouteSegment({
    required String routeId,
    required int segmentIndex,
    required List<LatLng> newCoordinates,
  }) async {
    try {
      // TODO: Implement route segment editing logic
      // This would involve updating the route with new coordinates
      final route = await remoteDataSource.getRouteById(routeId);
      return Right(route.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to edit route segment: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RouteEntity>>> searchRoutes({
    required String query,
    RouteDifficulty? difficulty,
    double? minDistance,
    double? maxDistance,
    String? userId,
  }) async {
    try {
      // TODO: Implement route search logic
      // This would involve filtering routes based on criteria
      final routes = await remoteDataSource.getAllRoutes();
      return Right(routes.map((route) => route.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to search routes: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> cacheRoute(RouteEntity route) async {
    try {
      final box = await _openBox();
      final routeModel = RouteModel.fromEntity(route);
      await box.put(route.id, routeModel);
      return _successUnit();
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to cache route: $e'));
    }
  }

  @override
  Future<Either<Failure, RouteEntity?>> getCachedRoute(String routeId) async {
    try {
      final box = await _openBox();
      final routeModel = box.get(routeId);
      if (routeModel != null) {
        return Right(routeModel.toEntity());
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get cached route: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearRouteCache() async {
    try {
      final box = await _openBox();
      await box.clear();
      return _successUnit();
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to clear route cache: $e'));
    }
  }
}
