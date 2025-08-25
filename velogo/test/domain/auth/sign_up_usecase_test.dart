import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:velogo/features/auth/domain/repositories/auth_repository.dart';
import 'package:velogo/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/features/auth/data/models/user_model.dart';

import 'sign_up_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignUpUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignUpUseCase(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tDisplayName = 'Test User';
  const tParams = SignUpParams(
    email: tEmail,
    password: tPassword,
    displayName: tDisplayName,
  );

  final tUser = UserModel(
    id: 'user123',
    email: tEmail,
    displayName: tDisplayName,
    photoURL: null,
    createdAt: DateTime.now(),
    lastLoginAt: DateTime.now(),
  );

  final tUserEntity = tUser.toEntity();

  group('SignUpUseCase', () {
    test('should return User when repository call is successful', () async {
      // arrange
      when(mockAuthRepository.signUp(tEmail, tPassword, tDisplayName)).thenAnswer((_) async => Right(tUserEntity));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Right(tUserEntity));
      verify(mockAuthRepository.signUp(tEmail, tPassword, tDisplayName));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ServerFailure when repository call is unsuccessful', () async {
      // arrange
      when(mockAuthRepository.signUp(tEmail, tPassword, tDisplayName)).thenAnswer((_) async => Left(ServerFailure('Email already in use')));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Left(ServerFailure('Email already in use')));
      verify(mockAuthRepository.signUp(tEmail, tPassword, tDisplayName));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when email is empty', () async {
      // arrange
      const invalidParams = SignUpParams(
        email: '',
        password: tPassword,
        displayName: tDisplayName,
      );

      // act
      final result = await useCase(invalidParams);

      // assert
      expect(result, Left(ValidationFailure('Email cannot be empty')));
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when password is empty', () async {
      // arrange
      const invalidParams = SignUpParams(
        email: tEmail,
        password: '',
        displayName: tDisplayName,
      );

      // act
      final result = await useCase(invalidParams);

      // assert
      expect(result, Left(ValidationFailure('Password cannot be empty')));
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when display name is empty', () async {
      // arrange
      const invalidParams = SignUpParams(
        email: tEmail,
        password: tPassword,
        displayName: '',
      );

      // act
      final result = await useCase(invalidParams);

      // assert
      expect(result, Left(ValidationFailure('Display name cannot be empty')));
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when password is too short', () async {
      // arrange
      const invalidParams = SignUpParams(
        email: tEmail,
        password: '123',
        displayName: tDisplayName,
      );

      // act
      final result = await useCase(invalidParams);

      // assert
      expect(result, Left(ValidationFailure('Password must be at least 6 characters')));
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when email format is invalid', () async {
      // arrange
      const invalidParams = SignUpParams(
        email: 'invalid-email',
        password: tPassword,
        displayName: tDisplayName,
      );

      // act
      final result = await useCase(invalidParams);

      // assert
      expect(result, Left(ValidationFailure('Invalid email format')));
      verifyZeroInteractions(mockAuthRepository);
    });
  });
}
