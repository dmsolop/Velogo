import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

part 'sign_in_usecase.freezed.dart';

class SignInUseCase implements UseCase<UserEntity, SignInParams> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) async {
    // Validation
    if (params.email.isEmpty) {
      return Left(Failure.validation('Email cannot be empty'));
    }

    if (params.password.isEmpty) {
      return Left(Failure.validation('Password cannot be empty'));
    }

    if (!_isValidEmail(params.email)) {
      return Left(Failure.validation('Invalid email format'));
    }

    return await repository.signIn(params.email, params.password);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}

@freezed
class SignInParams with _$SignInParams {
  const factory SignInParams({
    required String email,
    required String password,
  }) = _SignInParams;
}
