import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/core/usecases/usecase.dart';
import 'package:velogo/features/profile/domain/entities/profile_entity.dart';
import 'package:velogo/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase implements UseCase<ProfileEntity, String> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(String userId) async {
    return await repository.getProfile(userId);
  }
}

