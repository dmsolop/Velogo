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
}