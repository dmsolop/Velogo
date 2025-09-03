import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/route_entity.dart';
import '../repositories/route_repository.dart';

part 'create_automatic_route_usecase.freezed.dart';

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

@freezed
class CreateAutomaticRouteParams with _$CreateAutomaticRouteParams {
  const factory CreateAutomaticRouteParams({
    required LatLng startPoint,
    required LatLng endPoint,
    required RouteDifficulty difficulty,
    required double distance,
    String? userId,
  }) = _CreateAutomaticRouteParams;
}
