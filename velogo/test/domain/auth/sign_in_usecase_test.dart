import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:velogo/features/auth/domain/repositories/auth_repository.dart';
import 'package:velogo/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/features/auth/data/models/user_model.dart';

import 'sign_in_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignInUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignInUseCase(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tParams = SignInParams(email: tEmail, password: tPassword);

  final tUser = UserModel(
    id: 'user123',
    email: tEmail,
    displayName: 'Test User',
    photoURL: null,
    createdAt: DateTime.now(),
    lastLoginAt: DateTime.now(),
  );

  final tUserEntity = tUser.toEntity();

  group('SignInUseCase', () {
    test('should return User when repository call is successful', () async {
      // arrange
      when(mockAuthRepository.signIn(tEmail, tPassword))
          .thenAnswer((_) async => Right(tUserEntity));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Right(tUserEntity));
      verify(mockAuthRepository.signIn(tEmail, tPassword));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ServerFailure when repository call is unsuccessful', () async {
      // arrange
      when(mockAuthRepository.signIn(tEmail, tPassword))
          .thenAnswer((_) async => Left(ServerFailure('Invalid credentials')));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Left(ServerFailure('Invalid credentials')));
      verify(mockAuthRepository.signIn(tEmail, tPassword));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when email is empty', () async {
      // arrange
      const invalidParams = SignInParams(email: '', password: tPassword);

      // act
      final result = await useCase(invalidParams);

      // assert
      expect(result, Left(ValidationFailure('Email cannot be empty')));
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when password is empty', () async {
      // arrange
      const invalidParams = SignInParams(email: tEmail, password: '');

      // act
      final result = await useCase(invalidParams);

      // assert
      expect(result, Left(ValidationFailure('Password cannot be empty')));
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when email format is invalid', () async {
      // arrange
      const invalidParams = SignInParams(email: 'invalid-email', password: tPassword);

      // act
      final result = await useCase(invalidParams);

      // assert
      expect(result, Left(ValidationFailure('Invalid email format')));
      verifyZeroInteractions(mockAuthRepository);
    });
  });
}
