import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  /// Вхід користувача
  Future<Either<Failure, UserEntity>> signIn(String email, String password);

  /// Реєстрація користувача
  Future<Either<Failure, UserEntity>> signUp(String email, String password, String displayName);

  /// Вихід користувача
  Future<Either<Failure, void>> signOut();

  /// Відновлення пароля
  Future<Either<Failure, void>> resetPassword(String email);

  /// Отримання поточного користувача
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Оновлення профілю
  Future<Either<Failure, UserEntity>> updateProfile({
    String? displayName,
    String? photoURL,
  });
}
