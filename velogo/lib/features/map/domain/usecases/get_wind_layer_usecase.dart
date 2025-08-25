import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/map_layer_entity.dart';
import '../repositories/map_repository.dart';

class GetWindLayerUseCase implements UseCase<WindLayerEntity, NoParams> {
  final MapRepository repository;

  GetWindLayerUseCase(this.repository);

  @override
  Future<Either<Failure, WindLayerEntity>> call(NoParams params) async {
    return await repository.getWindLayer();
  }
}
