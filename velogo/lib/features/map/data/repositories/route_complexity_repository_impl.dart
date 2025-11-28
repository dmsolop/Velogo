import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/health_metrics.dart';
import '../../../../core/services/route_complexity_service.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/route_complexity_repository.dart';
import '../../../profile/domain/entities/profile_entity.dart';

/// Реалізація репозиторію для розрахунку складності маршруту
///
/// Використовує RouteComplexityService для розрахунку складності
///
/// Використовується в: Dependency Injection контейнері
class RouteComplexityRepositoryImpl implements RouteComplexityRepository {
  final RouteComplexityService _complexityService;

  RouteComplexityRepositoryImpl() : _complexityService = RouteComplexityService();

  @override
  Future<Either<Failure, PersonalizedDifficultyResult>> calculateRouteComplexity({
    required RouteEntity route,
    required ProfileEntity userProfile,
    DateTime? startTime,
    bool useHealthData = true,
    bool useCache = true,
  }) async {
    try {
      return await _complexityService.calculateRouteComplexity(
        route: route,
        userProfile: userProfile,
        startTime: startTime,
        useHealthData: useHealthData,
        useCache: useCache,
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to calculate route complexity: $e'));
    }
  }
}

