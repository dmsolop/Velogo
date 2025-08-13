import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/exceptions.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:velogo/features/settings/data/models/settings_model.dart';
import 'package:velogo/features/settings/domain/entities/settings_entity.dart';
import 'package:velogo/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      final settingsModel = await localDataSource.getSettings();
      return Right(settingsModel.toDomain());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSettings(SettingsEntity settings) async {
    try {
      await localDataSource.saveSettings(settings.toModel());
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateVoiceInstructions(bool value) async {
    try {
      await localDataSource.updateVoiceInstructions(value);
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUnitsOfMeasurement(String value) async {
    try {
      await localDataSource.updateUnitsOfMeasurement(value);
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMapStyle(String value) async {
    try {
      await localDataSource.updateMapStyle(value);
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateNotifications(bool value) async {
    try {
      await localDataSource.updateNotifications(value);
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateRouteAlerts(bool value) async {
    try {
      await localDataSource.updateRouteAlerts(value);
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateWeatherAlerts(bool value) async {
    try {
      await localDataSource.updateWeatherAlerts(value);
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateGeneralNotifications(bool value) async {
    try {
      await localDataSource.updateGeneralNotifications(value);
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateHealthDataIntegration(bool value) async {
    try {
      await localDataSource.updateHealthDataIntegration(value);
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
