import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/core/usecases/usecase.dart';
import 'package:velogo/features/profile/domain/repositories/profile_repository.dart';

class UpdateAgeUseCase implements UseCase<Unit, Map<String, dynamic>> {
  final ProfileRepository repository;

  UpdateAgeUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Map<String, dynamic> params) async {
    final userId = params['userId'] as String;
    final age = params['age'] as int;
    return await repository.updateAge(userId, age);
  }
}

