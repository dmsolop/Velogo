import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/core/usecases/usecase.dart';
import 'package:velogo/features/profile/domain/repositories/profile_repository.dart';

class ClearProfileCacheUseCase implements UseCase<Unit, NoParams> {
  final ProfileRepository repository;

  ClearProfileCacheUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.clearProfileCache();
  }
}
