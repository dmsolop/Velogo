import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/sign_in_usecase.dart';
import '../../../domain/usecases/sign_up_usecase.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../config/routes/screen_navigation_service.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;

  RegistrationCubit({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
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

    if (!isFormValid()) {
      emit(state.copyWith(
        isSubmitting: false,
        isError: true,
        errorMessage: 'Please fill all required fields correctly.',
      ));
      return;
    }

    final result = await _signUpUseCase(SignUpParams(
      email: state.email,
      password: state.password,
      displayName: '${state.username} ${state.lastName}',
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(
          isSubmitting: false,
          isError: true,
          errorMessage: _mapFailureToMessage(failure),
        ));
      },
      (user) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          successMessage: 'Registration successful!',
        ));

        Future.delayed(const Duration(milliseconds: 500), () {
          emit(state.copyWith(successMessage: '', isSuccess: false));
        });

        ScreenNavigationService.navigateTo('/home');
      },
    );
  }

  // Логін користувача
  Future<void> login() async {
    emit(state.copyWith(isSubmitting: true, isError: false, isSuccess: false));

    if (!state.isEmailValid || !state.isPasswordValid) {
      emit(state.copyWith(
        isSubmitting: false,
        isError: true,
        errorMessage: 'Please enter valid email and password.',
      ));
      return;
    }

    final result = await _signInUseCase(SignInParams(
      email: state.email,
      password: state.password,
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(
          isSubmitting: false,
          isError: true,
          errorMessage: _mapFailureToMessage(failure),
        ));
      },
      (user) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          successMessage: 'Login successful!',
        ));
        ScreenNavigationService.navigateTo('/home');
      },
    );
  }

  // Відновлення паролю
  Future<void> sendRecoveryLink() async {
    emit(state.copyWith(isSubmitting: true, isError: false, isSuccess: false));

    if (!state.isEmailValid) {
      emit(state.copyWith(
        isSubmitting: false,
        isError: true,
        errorMessage: 'Please enter a valid email address.',
      ));
      return;
    }

    // TODO: Implement password recovery use case
    emit(state.copyWith(
      isSubmitting: false,
      isSuccess: true,
      successMessage: 'Recovery link sent successfully!',
    ));
    navigateToLoginScreen();
  }

  // Перевірка доступності email
  Future<void> checkEmailAvailability(String email) async {
    emit(state.copyWith(isLoading: true, isError: false, warningMessage: ''));

    // TODO: Implement email availability check use case
    emit(state.copyWith(
      isLoading: false,
      successMessage: 'Email is available',
    ));
  }

  void showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Need More Help?'),
          content: const Text(
            'Please contact our support team at support@example.com.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
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

  // Оновлення підтвердження паролю
  void updateConfirmPassword(String confirmPassword) {
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      isPasswordsMatch: _validateConfirmPassword(confirmPassword),
    ));
  }

  // Оновлення статі
  void updateGender(String gender) {
    emit(state.copyWith(gender: gender));
  }

  // Оновлення Last Name
  void updateLastName(String lastName) {
    emit(state.copyWith(
      lastName: lastName,
      isLastnameValid: _validateLastname(lastName),
    ));
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
    return state.isEmailValid && state.isPasswordValid && state.isPasswordsMatch && state.isUsernameValid && state.isLastnameValid && state.country.isNotEmpty && state.gender.isNotEmpty;
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

  // Валідація підтвердження паролю
  bool _validateConfirmPassword(String confirmPassword) {
    final password = state.password;
    return password == confirmPassword;
  }

  // Валідація username
  bool _validateUsername(String username) {
    return username.isNotEmpty;
  }

  // Валідація lastname
  bool _validateLastname(String lastname) {
    return lastname.isNotEmpty;
  }

  // Мапінг failure до повідомлення
  String _mapFailureToMessage(Failure failure) {
    return failure.when(
      server: (message) => message ?? 'Server error. Please try again later.',
      cache: (message) => message ?? 'Cache error. Please try again later.',
      network: (message) => message ?? 'Network error. Please check your connection.',
      auth: (message) => message ?? 'Authentication failed. Please try again.',
      validation: (message) => message ?? 'Validation failed. Please check your input.',
      permission: (message) => message ?? 'Permission denied. Please try again.',
    );
  }

  // Логування станів
  @override
  void onChange(Change<RegistrationState> change) {
    super.onChange(change);
    print('State changed: ${change.currentState} -> ${change.nextState}');
  }
}
