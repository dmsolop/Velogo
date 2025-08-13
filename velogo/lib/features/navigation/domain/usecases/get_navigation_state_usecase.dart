import 'package:dartz/dartz.dart';
import '../entities/navigation_entity.dart';
import '../repositories/navigation_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetNavigationStateUseCase implements UseCase<NavigationEntity, NoParams> {
  final NavigationRepository repository;

  GetNavigationStateUseCase(this.repository);

  @override
  Future<Either<Failure, NavigationEntity>> call(NoParams params) async {
    return await repository.getCurrentNavigation();
  }
}
