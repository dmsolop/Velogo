import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/features/settings/domain/entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<Either<Failure, SettingsEntity>> getSettings();
  Future<Either<Failure, Unit>> saveSettings(SettingsEntity settings);
  Future<Either<Failure, Unit>> updateVoiceInstructions(bool value);
  Future<Either<Failure, Unit>> updateUnitsOfMeasurement(String value);
  Future<Either<Failure, Unit>> updateMapStyle(String value);
  Future<Either<Failure, Unit>> updateNotifications(bool value);
  Future<Either<Failure, Unit>> updateRouteAlerts(bool value);
  Future<Either<Failure, Unit>> updateWeatherAlerts(bool value);
  Future<Either<Failure, Unit>> updateGeneralNotifications(bool value);
  Future<Either<Failure, Unit>> updateHealthDataIntegration(bool value);
  Future<Either<Failure, Unit>> updateRouteDragging(bool value);
  Future<Either<Failure, Unit>> updateRouteProfile(String value);
}
