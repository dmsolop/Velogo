import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/core/usecases/usecase.dart';
import 'package:velogo/features/settings/domain/repositories/settings_repository.dart';

class UpdateUnitsOfMeasurementUseCase implements UseCase<Unit, String> {
  final SettingsRepository repository;

  UpdateUnitsOfMeasurementUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String value) async {
    return await repository.updateUnitsOfMeasurement(value);
  }
}
