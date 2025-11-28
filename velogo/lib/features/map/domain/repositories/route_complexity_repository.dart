import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/health_metrics.dart';
import '../entities/route_entity.dart';
import '../../../profile/domain/entities/profile_entity.dart';

/// Репозиторій для розрахунку складності маршруту
///
/// Відповідає за:
/// - Розрахунок складності маршруту з персоналізацією
/// - Розрахунок складності секції маршруту
/// - Розрахунок складності в реальному часі
///
/// Використовується в: Use Cases для складності маршруту
abstract class RouteComplexityRepository {
  /// Розрахунок загальної складності маршруту з персоналізацією
  ///
  /// Параметри:
  /// - route: маршрут для розрахунку
  /// - userProfile: профіль користувача
  /// - startTime: час початку маршруту (опціонально)
  /// - useHealthData: використовувати дані про здоров'я
  /// - useCache: використовувати кеш
  ///
  /// Використовується в: CalculateRouteComplexityUseCase
  Future<Either<Failure, PersonalizedDifficultyResult>> calculateRouteComplexity({
    required RouteEntity route,
    required ProfileEntity userProfile,
    DateTime? startTime,
    bool useHealthData = true,
    bool useCache = true,
  });
}

