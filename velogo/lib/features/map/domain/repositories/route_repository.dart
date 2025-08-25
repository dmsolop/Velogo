import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failures.dart';
import '../entities/route_entity.dart';

abstract class RouteRepository {
  // Отримання маршрутів
  Future<Either<Failure, List<RouteEntity>>> getAllRoutes();
  Future<Either<Failure, RouteEntity>> getRouteById(String routeId);
  Future<Either<Failure, List<RouteEntity>>> getRoutesByUserId(String userId);
  Future<Either<Failure, List<RouteEntity>>> getPublicRoutes();
  Future<Either<Failure, List<RouteEntity>>> getFavoriteRoutes(String userId);

  // Створення та оновлення маршрутів
  Future<Either<Failure, RouteEntity>> createRoute(RouteEntity route);
  Future<Either<Failure, RouteEntity>> updateRoute(RouteEntity route);
  Future<Either<Failure, Unit>> deleteRoute(String routeId);

  // Автоматичне створення маршрутів
  Future<Either<Failure, RouteEntity>> createAutomaticRoute({
    required LatLng startPoint,
    required LatLng endPoint,
    required RouteDifficulty difficulty,
    required double distance,
    String? userId,
  });

  // Редагування маршрутів
  Future<Either<Failure, RouteEntity>> editRouteSegment({
    required String routeId,
    required int segmentIndex,
    required List<LatLng> newCoordinates,
  });

  // Пошук маршрутів
  Future<Either<Failure, List<RouteEntity>>> searchRoutes({
    required String query,
    RouteDifficulty? difficulty,
    double? minDistance,
    double? maxDistance,
    String? userId,
  });

  // Кешування
  Future<Either<Failure, Unit>> cacheRoute(RouteEntity route);
  Future<Either<Failure, RouteEntity?>> getCachedRoute(String routeId);
  Future<Either<Failure, Unit>> clearRouteCache();
}
