import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(String userId);
  Future<Either<Failure, Unit>> saveProfile(ProfileEntity profile);
  Future<Either<Failure, Unit>> updateName(String userId, String name);
  Future<Either<Failure, Unit>> updateGender(String userId, String gender);
  Future<Either<Failure, Unit>> updateAge(String userId, int age);
  Future<Either<Failure, Unit>> updateAvatar(String userId, String avatarUrl);
  Future<Either<Failure, Unit>> updateFitnessLevel(String userId, String fitnessLevel);
  Future<Either<Failure, Unit>> updateHealthDataIntegration(String userId, bool enabled);
  Future<Either<Failure, Unit>> updateSyncStatus(String userId, String status);
  Future<Either<Failure, Unit>> addRecentActivity(String userId, String activity);
  Future<Either<Failure, Unit>> clearProfileCache();
}

