import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/health_metrics.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/route_entity.dart';
import '../repositories/route_complexity_repository.dart';
import '../../../profile/domain/entities/profile_entity.dart';

part 'calculate_route_complexity_usecase.freezed.dart';

/// Use Case для розрахунку складності маршруту з персоналізацією
///
/// Функціональність:
/// - Розраховує складність маршруту з урахуванням профілю користувача
/// - Використовує дані про здоров'я (якщо дозволено)
/// - Кешує результати для оптимізації
///
/// Використовується в: CreateRouteCubit
class CalculateRouteComplexityUseCase implements UseCase<PersonalizedDifficultyResult, CalculateRouteComplexityParams> {
  final RouteComplexityRepository repository;

  CalculateRouteComplexityUseCase(this.repository);

  @override
  Future<Either<Failure, PersonalizedDifficultyResult>> call(CalculateRouteComplexityParams params) async {
    return await repository.calculateRouteComplexity(
      route: params.route,
      userProfile: params.userProfile,
      startTime: params.startTime,
      useHealthData: params.useHealthData,
      useCache: params.useCache,
    );
  }
}

@freezed
class CalculateRouteComplexityParams with _$CalculateRouteComplexityParams {
  const factory CalculateRouteComplexityParams({
    required RouteEntity route,
    required ProfileEntity userProfile,
    DateTime? startTime,
    @Default(true) bool useHealthData,
    @Default(true) bool useCache,
  }) = _CalculateRouteComplexityParams;
}

