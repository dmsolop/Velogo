import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/routing_repository.dart';

part 'calculate_route_distance_usecase.freezed.dart';

/// Use Case для розрахунку відстані маршруту
///
/// Функціональність:
/// - Розраховує загальну відстань маршруту по координатах
/// - Використовує формулу Haversine для розрахунку відстані між точками
///
/// Використовується в: CreateRouteCubit
class CalculateRouteDistanceUseCase implements UseCase<double, CalculateRouteDistanceParams> {
  final RoutingRepository repository;

  CalculateRouteDistanceUseCase(this.repository);

  @override
  Future<Either<Failure, double>> call(CalculateRouteDistanceParams params) async {
    return await repository.calculateRouteDistance(params.coordinates);
  }
}

@freezed
class CalculateRouteDistanceParams with _$CalculateRouteDistanceParams {
  const factory CalculateRouteDistanceParams({
    required List<LatLng> coordinates,
  }) = _CalculateRouteDistanceParams;
}

