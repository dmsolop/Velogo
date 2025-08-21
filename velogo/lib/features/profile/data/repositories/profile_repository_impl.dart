import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/exceptions.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:velogo/features/profile/data/models/profile_model.dart';
import 'package:velogo/features/profile/domain/entities/profile_entity.dart';
import 'package:velogo/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    try {
      final profileModel = await remoteDataSource.getProfile(userId);
      return Right(profileModel.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get profile: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveProfile(ProfileEntity profile) async {
    try {
      await remoteDataSource.saveProfile(profile.toModel());
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to save profile: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateName(String userId, String name) async {
    try {
      await remoteDataSource.updateName(userId, name);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update name: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateGender(String userId, String gender) async {
    try {
      await remoteDataSource.updateGender(userId, gender);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update gender: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAge(String userId, int age) async {
    try {
      await remoteDataSource.updateAge(userId, age);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update age: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAvatar(String userId, String avatarUrl) async {
    try {
      await remoteDataSource.updateAvatar(userId, avatarUrl);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update avatar: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateFitnessLevel(String userId, String fitnessLevel) async {
    try {
      await remoteDataSource.updateFitnessLevel(userId, fitnessLevel);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update fitness level: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateHealthDataIntegration(String userId, bool enabled) async {
    try {
      await remoteDataSource.updateHealthDataIntegration(userId, enabled);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update health data integration: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateSyncStatus(String userId, String status) async {
    try {
      await remoteDataSource.updateSyncStatus(userId, status);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update sync status: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addRecentActivity(String userId, String activity) async {
    try {
      await remoteDataSource.addRecentActivity(userId, activity);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to add recent activity: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearProfileCache() async {
    try {
      // Для Firebase це може бути просто логування або очищення локального кешу
      // В даному випадку просто повертаємо успіх
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to clear profile cache: $e'));
    }
  }
}
