import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/core/usecases/usecase.dart';
import 'package:velogo/features/settings/domain/entities/settings_entity.dart';
import 'package:velogo/features/settings/domain/repositories/settings_repository.dart';

class GetSettingsUseCase implements UseCase<SettingsEntity, NoParams> {
  final SettingsRepository repository;

  GetSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, SettingsEntity>> call(NoParams params) async {
    return await repository.getSettings();
  }
}
