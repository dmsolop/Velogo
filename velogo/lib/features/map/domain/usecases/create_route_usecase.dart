import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/route_entity.dart';
import '../repositories/route_repository.dart';

part 'create_route_usecase.freezed.dart';

class CreateRouteUseCase implements UseCase<RouteEntity, CreateRouteParams> {
  final RouteRepository repository;

  CreateRouteUseCase(this.repository);

  @override
  Future<Either<Failure, RouteEntity>> call(CreateRouteParams params) async {
    return await repository.createRoute(params.route);
  }
}

@freezed
class CreateRouteParams with _$CreateRouteParams {
  const factory CreateRouteParams({
    required RouteEntity route,
  }) = _CreateRouteParams;
}
