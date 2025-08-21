import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/core/usecases/usecase.dart';
import 'package:velogo/features/profile/domain/entities/profile_entity.dart';
import 'package:velogo/features/profile/domain/repositories/profile_repository.dart';

class SaveProfileUseCase implements UseCase<Unit, ProfileEntity> {
  final ProfileRepository repository;

  SaveProfileUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ProfileEntity profile) async {
    return await repository.saveProfile(profile);
  }
}
