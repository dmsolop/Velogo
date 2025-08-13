import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/core/usecases/usecase.dart';
import 'package:velogo/features/settings/domain/repositories/settings_repository.dart';

class UpdateNotificationsUseCase implements UseCase<Unit, bool> {
  final SettingsRepository repository;

  UpdateNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(bool value) async {
    return await repository.updateNotifications(value);
  }
}
