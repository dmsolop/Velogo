import 'package:flutter_bloc/flutter_bloc.dart';
import '/navigation/screen_navigation_service.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(const RegistrationState());

  void navigateToRegistrationScreen() {
    ScreenNavigationService.navigateTo('/registration');
  }

  void navigateToLoginScreen() {
    ScreenNavigationService.navigateTo('/login');
  }

  void updateUsername(String username) {
    emit(state.copyWith(username: username));
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void updateGender(String gender) {
    emit(state.copyWith(gender: gender));
  }

  Future<void> submitRegistration() async {
    emit(state.copyWith(isSubmitting: true, isSuccess: false, isError: false));
    try {
      // Імітація запиту на сервер
      await Future.delayed(const Duration(seconds: 2));
      // Перевірка успішності
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, isError: true));
    }
  }

  // Логіка для логіну
  Future<void> login() async {
    emit(state.copyWith(isSubmitting: true, isError: false));
    try {
      // Імітація серверного запиту
      await Future.delayed(const Duration(seconds: 2));
      // Перевірка успішності (мок):
      if (state.email.isNotEmpty && state.password.isNotEmpty) {
        emit(state.copyWith(isSubmitting: false, isError: false));
        // Навігація до головного екрану
        ScreenNavigationService.navigateTo('/main');
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, isError: true));
    }
  }

  Future<void> sendRecoveryLink() async {
    emit(state.copyWith(isSubmitting: true, isError: false, isSuccess: false));
    try {
      // Імітація запиту на сервер
      await Future.delayed(const Duration(seconds: 2));
      if (state.email.isNotEmpty) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          successMessage: 'Recovery link sent successfully!',
        ));
      } else {
        throw Exception('Invalid email');
      }
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isError: true,
        errorMessage: e.toString() == 'Exception: Invalid email'
            ? 'Invalid email address.'
            : 'Failed to send recovery link. Please try again.',
      ));
    }
  }
}
