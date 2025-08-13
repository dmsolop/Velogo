import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/core/usecases/usecase.dart';
import 'package:velogo/features/settings/domain/entities/settings_entity.dart';
import 'package:velogo/features/settings/domain/repositories/settings_repository.dart';

class SaveSettingsUseCase implements UseCase<Unit, SettingsEntity> {
  final SettingsRepository repository;

  SaveSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SettingsEntity settings) async {
    return await repository.saveSettings(settings);
  }
}
