import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/route_entity.dart';
import '../repositories/route_repository.dart';

class CreateAutomaticRouteUseCase implements UseCase<RouteEntity, CreateAutomaticRouteParams> {
  final RouteRepository repository;

  CreateAutomaticRouteUseCase(this.repository);

  @override
  Future<Either<Failure, RouteEntity>> call(CreateAutomaticRouteParams params) async {
    return await repository.createAutomaticRoute(
      startPoint: params.startPoint,
      endPoint: params.endPoint,
      difficulty: params.difficulty,
      distance: params.distance,
      userId: params.userId,
    );
  }
}

class CreateAutomaticRouteParams extends Equatable {
  final LatLng startPoint;
  final LatLng endPoint;
  final RouteDifficulty difficulty;
  final double distance;
  final String? userId;

  const CreateAutomaticRouteParams({
    required this.startPoint,
    required this.endPoint,
    required this.difficulty,
    required this.distance,
    this.userId,
  });

  @override
  List<Object?> get props => [startPoint, endPoint, difficulty, distance, userId];
}
