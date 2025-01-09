import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../navigation/screen_navigation_service.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final FirebaseAuth _auth;

  RegistrationCubit({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance,
        super(const RegistrationState());

  // Навігація до RegistrationScreen
  void navigateToRegistrationScreen() {
    ScreenNavigationService.navigateTo('/registration');
  }

  // Навігація до LoginScreen
  void navigateToLoginScreen() {
    ScreenNavigationService.navigateTo('/login');
  }

  // Навігація до PasswordRecoveryScreen
  void navigateToPasswordRecoveryScreen() {
    ScreenNavigationService.navigateTo('/password-recovery');
  }

  // Реєстрація нового користувача
  Future<void> submitRegistration() async {
    emit(state.copyWith(isSubmitting: true, isError: false, isSuccess: false));
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      await userCredential.user
          ?.updateDisplayName('${state.username} ${state.lastName}');

      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        successMessage: 'Registration successful!',
      ));
      navigateToLoginScreen();
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isError: true,
        errorMessage: _mapFirebaseAuthError(e),
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isError: true,
        errorMessage: 'An unexpected error occurred. Please try again.',
      ));
    }
  }

  // Логін користувача
  Future<void> login() async {
    emit(state.copyWith(isSubmitting: true, isError: false, isSuccess: false));
    try {
      await _auth.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        successMessage: 'Login successful!',
      ));
      ScreenNavigationService.navigateTo('/main');
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isError: true,
        errorMessage: _mapFirebaseAuthError(e),
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isError: true,
        errorMessage: 'An unexpected error occurred. Please try again.',
      ));
    }
  }

  // Відновлення паролю
  Future<void> sendRecoveryLink() async {
    emit(state.copyWith(isSubmitting: true, isError: false, isSuccess: false));
    try {
      await _auth.sendPasswordResetEmail(email: state.email);
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        successMessage: 'Recovery link sent successfully!',
      ));
      navigateToLoginScreen();
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isError: true,
        errorMessage: _mapFirebaseAuthError(e),
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isError: true,
        errorMessage: 'An unexpected error occurred. Please try again.',
      ));
    }
  }

  // Перевірка доступності email
  Future<void> checkEmailAvailability(String email) async {
    emit(state.copyWith(isLoading: true, isError: false, warningMessage: ''));
    try {
      final isAvailable = await _mockCheckEmail(email);
      if (isAvailable) {
        emit(state.copyWith(
          isLoading: false,
          successMessage: 'Email is available!',
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          warningMessage: 'This email is already taken.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: 'Failed to check email. Please try again.',
      ));
    }
  }

  Future<bool> _mockCheckEmail(String email) async {
    await Future.delayed(const Duration(seconds: 2));
    return email != 'already@used.com';
  }

  // Оновлення username
  void updateUsername(String username) {
    emit(state.copyWith(
      username: username,
      isUsernameValid: _validateUsername(username),
    ));
  }

  // Оновлення email
  void updateEmail(String email) {
    emit(state.copyWith(
      email: email,
      isEmailValid: _validateEmail(email),
    ));
  }

  // Оновлення паролю
  void updatePassword(String password) {
    emit(state.copyWith(
      password: password,
      isPasswordValid: _validatePassword(password),
    ));
  }

  // Оновлення статі
  void updateGender(String gender) {
    emit(state.copyWith(gender: gender));
  }

  // Оновлення Last Name
  void updateLastName(String lastName) {
    emit(state.copyWith(lastName: lastName));
  }

  // Оновлення Birthday
  void updateBirthday(DateTime birthday) {
    emit(state.copyWith(birthday: birthday));
  }

  // Оновлення Country
  void updateCountry(String country) {
    emit(state.copyWith(country: country));
  }

  // Перевірка форми
  bool isFormValid() {
    return state.isEmailValid &&
        state.isPasswordValid &&
        state.isUsernameValid &&
        state.isLastnameValid &&
        state.country.isNotEmpty &&
        state.gender.isNotEmpty;
  }

  // Валідація email
  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Валідація паролю
  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  // Валідація username
  bool _validateUsername(String username) {
    return username.isNotEmpty;
  }

  // Валідація lastname
  bool _validateLastname(String lastname) {
    return lastname.isNotEmpty;
  }

  // Мапінг помилок Firebase
  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'The email is already in use by another account.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // Логування станів
  @override
  void onChange(Change<RegistrationState> change) {
    super.onChange(change);
    print('State changed: ${change.currentState} -> ${change.nextState}');
  }
}






// import 'package:flutter_bloc/flutter_bloc.dart';
// import '/navigation/screen_navigation_service.dart';
// import 'registration_state.dart';

// class RegistrationCubit extends Cubit<RegistrationState> {
//   RegistrationCubit() : super(const RegistrationState());

//   void navigateToRegistrationScreen() {
//     ScreenNavigationService.navigateTo('/registration');
//   }

//   void navigateToLoginScreen() {
//     ScreenNavigationService.navigateTo('/login');
//   }

//   void navigateToPasswordRecoveryScreen() {
//     ScreenNavigationService.navigateTo('/password-recovery');
//   }

//   void updateUsername(String username) {
//     emit(state.copyWith(
//       username: username,
//       isUsernameValid: _validateUsername(username),
//     ));
//   }

//   void updateEmail(String email) {
//     emit(state.copyWith(
//       email: email,
//       isEmailValid: _validateEmail(email),
//     ));
//   }

//   void updatePassword(String password) {
//     emit(state.copyWith(
//       password: password,
//       isPasswordValid: _validatePassword(password),
//     ));
//   }

//   void updateGender(String gender) {
//     emit(state.copyWith(gender: gender));
//   }

//   bool _validateEmail(String email) {
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     return emailRegex.hasMatch(email);
//   }

//   bool _validatePassword(String password) {
//     return password.length >= 6;
//   }

//   bool _validateUsername(String username) {
//     return username.isNotEmpty;
//   }

//   bool isFormValid() {
//     return state.isEmailValid && state.isPasswordValid && state.isUsernameValid;
//   }

//   Future<void> submitRegistration() async {
//     emit(state.copyWith(isSubmitting: true, isSuccess: false, isError: false));
//     try {
//       // Імітація запиту на сервер
//       await Future.delayed(const Duration(seconds: 2));
//       // Перевірка успішності
//       emit(state.copyWith(isSubmitting: false, isSuccess: true));
//     } catch (e) {
//       emit(state.copyWith(isSubmitting: false, isError: true));
//     }
//   }

//   // Логіка для логіну
//   Future<void> login() async {
//     emit(state.copyWith(isSubmitting: true, isError: false));
//     try {
//       // Імітація серверного запиту
//       await Future.delayed(const Duration(seconds: 2));
//       // Перевірка успішності (мок):
//       if (state.email.isNotEmpty && state.password.isNotEmpty) {
//         emit(state.copyWith(isSubmitting: false, isError: false));
//         // Навігація до головного екрану
//         ScreenNavigationService.navigateTo('/main');
//       } else {
//         throw Exception('Invalid credentials');
//       }
//     } catch (e) {
//       emit(state.copyWith(isSubmitting: false, isError: true));
//     }
//   }

//   Future<void> sendRecoveryLink() async {
//     emit(state.copyWith(isSubmitting: true, isError: false, isSuccess: false));
//     try {
//       // Імітація запиту на сервер
//       await Future.delayed(const Duration(seconds: 2));
//       if (state.email.isNotEmpty) {
//         emit(state.copyWith(
//           isSubmitting: false,
//           isSuccess: true,
//           successMessage: 'Recovery link sent successfully!',
//         ));
//       } else {
//         throw Exception('Invalid email');
//       }
//     } catch (e) {
//       emit(state.copyWith(
//         isSubmitting: false,
//         isError: true,
//         errorMessage: e.toString() == 'Exception: Invalid email'
//             ? 'Invalid email address.'
//             : 'Failed to send recovery link. Please try again.',
//       ));
//     }
//   }
// }
