import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/route_entity.dart';
import '../repositories/route_repository.dart';

class CreateRouteUseCase implements UseCase<RouteEntity, CreateRouteParams> {
  final RouteRepository repository;

  CreateRouteUseCase(this.repository);

  @override
  Future<Either<Failure, RouteEntity>> call(CreateRouteParams params) async {
    return await repository.createRoute(params.route);
  }
}

class CreateRouteParams extends Equatable {
  final RouteEntity route;

  const CreateRouteParams({required this.route});

  @override
  List<Object> get props => [route];
}
