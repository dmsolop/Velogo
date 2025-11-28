import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/road_routing_service.dart';
import '../../domain/repositories/routing_repository.dart';

/// Реалізація репозиторію для маршрутизації
///
/// Використовує RoadRoutingService для розрахунку маршрутів
///
/// Використовується в: Dependency Injection контейнері
class RoutingRepositoryImpl implements RoutingRepository {
  @override
  Future<Either<Failure, List<LatLng>>> calculateRoute({
    required LatLng startPoint,
    required LatLng endPoint,
    required String profile,
  }) async {
    try {
      final result = await RoadRoutingService.calculateRouteWithErrorHandling(
        startPoint: startPoint,
        endPoint: endPoint,
        profile: profile,
      );

      if (result.isFailure) {
        // Мапимо RouteCalculationError на Failure
        switch (result.error!) {
          case RouteCalculationError.noInternet:
            return Left(NetworkFailure('Немає інтернет-з\'єднання. Перевірте підключення до мережі.'));
          case RouteCalculationError.noApiKey:
            return Left(ServerFailure('API ключ не налаштовано. Зверніться до адміністратора.'));
          case RouteCalculationError.apiError:
            return Left(ServerFailure('Помилка API маршрутизації: ${result.errorMessage}'));
          case RouteCalculationError.noOfflineMaps:
            return Left(CacheFailure('Немає офлайн карт для цієї області. Завантажте карти або перевірте інтернет.'));
          case RouteCalculationError.offlineCalculationFailed:
            return Left(ServerFailure('Не вдалося розрахувати маршрут. Спробуйте пізніше або змініть точки маршруту.'));
          case RouteCalculationError.unknown:
            return Left(ServerFailure('Сталася неочікувана помилка: ${result.errorMessage}'));
        }
      }

      return Right(result.coordinates!);
    } catch (e) {
      return Left(ServerFailure('Помилка розрахунку маршруту: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateRouteDistance(List<LatLng> coordinates) async {
    try {
      if (coordinates.length < 2) {
        return Right(0.0);
      }

      final distance = RoadRoutingService.calculateRouteDistance(coordinates);
      return Right(distance);
    } catch (e) {
      return Left(ServerFailure('Помилка розрахунку відстані: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateElevationGain({
    required LatLng startPoint,
    required LatLng endPoint,
  }) async {
    try {
      // TODO: Реалізувати реальний розрахунок набору висоти через API або офлайн дані
      // Поки що повертаємо заглушку
      return Right(10.0);
    } catch (e) {
      return Left(ServerFailure('Помилка розрахунку набору висоти: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateWindEffect({
    required LatLng startPoint,
    required LatLng endPoint,
  }) async {
    try {
      // TODO: Реалізувати реальний розрахунок впливу вітру через Weather API
      // Поки що повертаємо заглушку
      return Right(-2.0);
    } catch (e) {
      return Left(ServerFailure('Помилка розрахунку впливу вітру: $e'));
    }
  }
}

