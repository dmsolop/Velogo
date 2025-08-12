import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:velogo/features/auth/presentation/bloc/registration/registration_cubit.dart';
import 'package:velogo/features/auth/presentation/bloc/registration/registration_state.dart';
import 'package:velogo/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:velogo/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:velogo/features/auth/domain/entities/user_entity.dart';
import 'package:velogo/core/error/failures.dart';

import 'registration_cubit_test.mocks.dart';

@GenerateMocks([SignInUseCase, SignUpUseCase])
void main() {
  late RegistrationCubit registrationCubit;
  late MockSignInUseCase mockSignInUseCase;
  late MockSignUpUseCase mockSignUpUseCase;

  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
    mockSignUpUseCase = MockSignUpUseCase();

    registrationCubit = RegistrationCubit(
      signInUseCase: mockSignInUseCase,
      signUpUseCase: mockSignUpUseCase,
    );
  });

  tearDown(() {
    registrationCubit.close();
  });

  group('RegistrationCubit Tests', () {
    test('Initial state is RegistrationState', () {
      expect(registrationCubit.state, const RegistrationState());
    });

    test('updateEmail updates email and validates format', () {
      registrationCubit.updateEmail('test@example.com');
      expect(registrationCubit.state.email, 'test@example.com');
      expect(registrationCubit.state.isEmailValid, true);
    });

    test('updateEmail sets isEmailValid to false for invalid email', () {
      registrationCubit.updateEmail('invalid-email');
      expect(registrationCubit.state.email, 'invalid-email');
      expect(registrationCubit.state.isEmailValid, false);
    });

    test('submitRegistration emits success state on valid registration', () async {
      final userEntity = UserEntity(
        id: 'test-id',
        email: 'test@example.com',
        displayName: 'John Doe',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      when(mockSignUpUseCase(any)).thenAnswer((_) async => Right(userEntity));

      registrationCubit.updateEmail('test@example.com');
      registrationCubit.updatePassword('password123');
      registrationCubit.updateUsername('John');
      registrationCubit.updateLastName('Doe');

      await registrationCubit.submitRegistration();

      expect(registrationCubit.state.isSubmitting, false);
      expect(registrationCubit.state.isSuccess, true);
      expect(registrationCubit.state.successMessage, 'Registration successful!');
    });

    test('submitRegistration emits error state on failure', () async {
      when(mockSignUpUseCase(any)).thenAnswer((_) async => Left(AuthFailure('Email already in use')));

      registrationCubit.updateEmail('used@example.com');
      registrationCubit.updatePassword('password123');

      await registrationCubit.submitRegistration();

      expect(registrationCubit.state.isSubmitting, false);
      expect(registrationCubit.state.isError, true);
      expect(registrationCubit.state.errorMessage, 'Email already in use');
    });

    test('login emits success state on valid login', () async {
      final userEntity = UserEntity(
        id: 'test-id',
        email: 'test@example.com',
        displayName: 'John Doe',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      when(mockSignInUseCase(any)).thenAnswer((_) async => Right(userEntity));

      registrationCubit.updateEmail('test@example.com');
      registrationCubit.updatePassword('password123');

      await registrationCubit.login();

      expect(registrationCubit.state.isSubmitting, false);
      expect(registrationCubit.state.isSuccess, true);
      expect(registrationCubit.state.successMessage, 'Login successful!');
    });

    test('login emits error state on failure', () async {
      when(mockSignInUseCase(any)).thenAnswer((_) async => Left(AuthFailure('Invalid credentials')));

      registrationCubit.updateEmail('test@example.com');
      registrationCubit.updatePassword('wrongpassword');

      await registrationCubit.login();

      expect(registrationCubit.state.isSubmitting, false);
      expect(registrationCubit.state.isError, true);
      expect(registrationCubit.state.errorMessage, 'Invalid credentials');
    });

    test('sendRecoveryLink emits success state on valid email', () async {
      registrationCubit.updateEmail('test@example.com');
      await registrationCubit.sendRecoveryLink();

      expect(registrationCubit.state.isSubmitting, false);
      expect(registrationCubit.state.isSuccess, true);
      expect(registrationCubit.state.successMessage, 'Recovery link sent successfully!');
    });

    test('checkEmailAvailability calls function and handles response', () async {
      await registrationCubit.checkEmailAvailability('test@example.com');

      expect(registrationCubit.state.isLoading, false);
      expect(registrationCubit.state.successMessage, 'Email is available');
    });
  });
}
