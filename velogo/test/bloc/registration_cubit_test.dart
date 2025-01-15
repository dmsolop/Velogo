import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:velogo/bloc/registration/registration_cubit.dart';
import 'package:velogo/bloc/registration/registration_state.dart';

import '../mocks/mock_registration_cubit.mocks.dart';
import '../mocks/firebase_auth_mocks.mocks.dart';
import '../mocks/mock_cloud_functions.mocks.dart';

void main() {
  late RegistrationCubit registrationCubit;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockHttpsCallable mockHttpsCallable;
  late MockHttpsCallableResult mockHttpsCallableResult;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockHttpsCallable = MockHttpsCallable();
    mockHttpsCallableResult = MockHttpsCallableResult();

    registrationCubit = RegistrationCubit(firebaseAuth: mockFirebaseAuth);
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

    test('submitRegistration emits success state on valid registration',
        () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.updateDisplayName(any)).thenAnswer((_) async {});

      registrationCubit.updateEmail('test@example.com');
      registrationCubit.updatePassword('password123');
      registrationCubit.updateUsername('John');
      registrationCubit.updateLastName('Doe');

      await registrationCubit.submitRegistration();

      expect(registrationCubit.state.isSubmitting, false);
      expect(registrationCubit.state.isSuccess, true);
      expect(
          registrationCubit.state.successMessage, 'Registration successful!');
    });

    test('submitRegistration emits error state on FirebaseAuthException',
        () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      registrationCubit.updateEmail('used@example.com');
      registrationCubit.updatePassword('password123');

      await registrationCubit.submitRegistration();

      expect(registrationCubit.state.isSubmitting, false);
      expect(registrationCubit.state.isError, true);
      expect(registrationCubit.state.errorMessage,
          'The email is already in use by another account.');
    });

    test('sendRecoveryLink emits success state on valid email', () async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')))
          .thenAnswer((_) async {});

      registrationCubit.updateEmail('test@example.com');
      await registrationCubit.sendRecoveryLink();

      expect(registrationCubit.state.isSubmitting, false);
      expect(registrationCubit.state.isSuccess, true);
      expect(registrationCubit.state.successMessage,
          'Recovery link sent successfully!');
    });

    test('sendRecoveryLink emits error state on FirebaseAuthException',
        () async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));

      registrationCubit.updateEmail('nonexistent@example.com');
      await registrationCubit.sendRecoveryLink();

      expect(registrationCubit.state.isSubmitting, false);
      expect(registrationCubit.state.isError, true);
      expect(registrationCubit.state.errorMessage,
          'No user found with this email.');
    });

    test('checkEmailAvailability calls Firebase Function and handles response',
        () async {
      when(mockHttpsCallable.call(any))
          .thenAnswer((_) async => mockHttpsCallableResult);
      when(mockHttpsCallableResult.data)
          .thenReturn({'available': true, 'message': 'Email is available!'});

      await registrationCubit.checkEmailAvailability('test@example.com');

      expect(registrationCubit.state.isLoading, false);
      expect(registrationCubit.state.successMessage, 'Email is available!');
    });

    test(
        'checkEmailAvailability sets warningMessage when email is already taken',
        () async {
      when(mockHttpsCallable.call(any))
          .thenAnswer((_) async => mockHttpsCallableResult);
      when(mockHttpsCallableResult.data).thenReturn(
          {'available': false, 'message': 'This email is already taken.'});

      await registrationCubit.checkEmailAvailability('test@example.com');

      expect(registrationCubit.state.isLoading, false);
      expect(registrationCubit.state.warningMessage,
          'This email is already taken.');
    });
  });
}

// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:velogo/bloc/registration/registration_cubit.dart';
// import 'package:velogo/bloc/registration/registration_state.dart';

// import '../mocks/firebase_auth_mocks.mocks.dart';

// void main() {
//   late RegistrationCubit registrationCubit;
//   late MockFirebaseAuth mockFirebaseAuth;
//   late MockUserCredential mockUserCredential;
//   late MockUser mockUser;

//   setUp(() {
//     mockFirebaseAuth = MockFirebaseAuth();
//     mockUserCredential = MockUserCredential();
//     mockUser = MockUser();

//     registrationCubit = RegistrationCubit(firebaseAuth: mockFirebaseAuth);
//   });

//   tearDown(() {
//     registrationCubit.close();
//   });

//   group('RegistrationCubit Tests', () {
//     test('Initial state is RegistrationState', () {
//       expect(registrationCubit.state, const RegistrationState());
//     });

//     test('updateEmail updates email and validates format', () {
//       // Act
//       registrationCubit.updateEmail('test@example.com');

//       // Assert
//       expect(registrationCubit.state.email, 'test@example.com');
//       expect(registrationCubit.state.isEmailValid, true);
//     });

//     test('updateEmail sets isEmailValid to false for invalid email', () {
//       // Act
//       registrationCubit.updateEmail('invalid-email');

//       // Assert
//       expect(registrationCubit.state.email, 'invalid-email');
//       expect(registrationCubit.state.isEmailValid, false);
//     });

//     test('submitRegistration emits success state on valid registration',
//         () async {
//       // Arrange
//       when(mockFirebaseAuth.createUserWithEmailAndPassword(
//         email: anyNamed('email'),
//         password: anyNamed('password'),
//       )).thenAnswer((_) async => mockUserCredential);

//       when(mockUserCredential.user).thenReturn(mockUser);
//       when(mockUser.updateDisplayName(any)).thenAnswer((_) async {});

//       // Act
//       registrationCubit.updateEmail('test@example.com');
//       registrationCubit.updatePassword('password123');
//       registrationCubit.updateUsername('John');
//       registrationCubit.updateLastName('Doe');

//       await registrationCubit.submitRegistration();

//       // Assert
//       expect(registrationCubit.state.isSubmitting, false);
//       expect(registrationCubit.state.isSuccess, true);
//       expect(
//           registrationCubit.state.successMessage, 'Registration successful!');
//     });

//     test('submitRegistration emits error state on FirebaseAuthException',
//         () async {
//       // Arrange
//       when(mockFirebaseAuth.createUserWithEmailAndPassword(
//         email: anyNamed('email'),
//         password: anyNamed('password'),
//       )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

//       // Act
//       registrationCubit.updateEmail('used@example.com');
//       registrationCubit.updatePassword('password123');

//       await registrationCubit.submitRegistration();

//       // Assert
//       expect(registrationCubit.state.isSubmitting, false);
//       expect(registrationCubit.state.isError, true);
//       expect(registrationCubit.state.errorMessage,
//           'The email is already in use by another account.');
//     });

//     test('sendRecoveryLink emits success state on valid email', () async {
//       // Arrange
//       when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')))
//           .thenAnswer((_) async {});

//       // Act
//       registrationCubit.updateEmail('test@example.com');
//       await registrationCubit.sendRecoveryLink();

//       // Assert
//       expect(registrationCubit.state.isSubmitting, false);
//       expect(registrationCubit.state.isSuccess, true);
//       expect(registrationCubit.state.successMessage,
//           'Recovery link sent successfully!');
//     });

//     test('sendRecoveryLink emits error state on FirebaseAuthException',
//         () async {
//       // Arrange
//       when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')))
//           .thenThrow(FirebaseAuthException(code: 'user-not-found'));

//       // Act
//       registrationCubit.updateEmail('nonexistent@example.com');
//       await registrationCubit.sendRecoveryLink();

//       // Assert
//       expect(registrationCubit.state.isSubmitting, false);
//       expect(registrationCubit.state.isError, true);
//       expect(registrationCubit.state.errorMessage,
//           'No user found with this email.');
//     });
//   });
// }
