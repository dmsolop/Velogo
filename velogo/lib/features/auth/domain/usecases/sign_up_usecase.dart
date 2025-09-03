import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

part 'sign_up_usecase.freezed.dart';

class SignUpUseCase implements UseCase<UserEntity, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) async {
    // Validation
    if (params.email.isEmpty) {
      return Left(Failure.validation('Email cannot be empty'));
    }

    if (params.password.isEmpty) {
      return Left(Failure.validation('Password cannot be empty'));
    }

    if (params.displayName.isEmpty) {
      return Left(Failure.validation('Display name cannot be empty'));
    }

    if (params.password.length < 6) {
      return Left(Failure.validation('Password must be at least 6 characters'));
    }

    if (!_isValidEmail(params.email)) {
      return Left(Failure.validation('Invalid email format'));
    }

    return await repository.signUp(params.email, params.password, params.displayName);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}

@freezed
class SignUpParams with _$SignUpParams {
  const factory SignUpParams({
    required String email,
    required String password,
    required String displayName,
  }) = _SignUpParams;
}
