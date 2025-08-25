import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/core/usecases/usecase.dart';
import 'package:velogo/features/profile/domain/repositories/profile_repository.dart';

class UpdateNameUseCase implements UseCase<Unit, Map<String, dynamic>> {
  final ProfileRepository repository;

  UpdateNameUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Map<String, dynamic> params) async {
    final userId = params['userId'] as String;
    final name = params['name'] as String;
    return await repository.updateName(userId, name);
  }
}

