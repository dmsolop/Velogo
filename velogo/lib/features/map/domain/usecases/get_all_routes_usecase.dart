import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/route_entity.dart';
import '../repositories/route_repository.dart';

class GetAllRoutesUseCase implements UseCase<List<RouteEntity>, NoParams> {
  final RouteRepository repository;

  GetAllRoutesUseCase(this.repository);

  @override
  Future<Either<Failure, List<RouteEntity>>> call(NoParams params) async {
    return await repository.getAllRoutes();
  }
}
