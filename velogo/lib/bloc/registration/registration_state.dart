import 'package:equatable/equatable.dart';

class RegistrationState extends Equatable {
  final String username;
  final String email;
  final String password;
  final String gender;
  final bool isSubmitting;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final String errorMessage;
  final String successMessage;
  final String warningMessage;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isUsernameValid;

  const RegistrationState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.gender = '',
    this.isSubmitting = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.errorMessage = '',
    this.successMessage = '',
    this.warningMessage = '',
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.isUsernameValid = true,
  });

  RegistrationState copyWith({
    String? username,
    String? email,
    String? password,
    String? gender,
    bool? isSubmitting,
    bool? isLoading,
    bool? isSuccess,
    bool? isError,
    String? errorMessage,
    String? successMessage,
    String? warningMessage,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isUsernameValid,
  }) {
    return RegistrationState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      warningMessage: warningMessage ?? this.warningMessage,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
    );
  }

  @override
  List<Object> get props => [
        username,
        email,
        password,
        gender,
        isSubmitting,
        isLoading,
        isSuccess,
        isError,
        errorMessage,
        successMessage,
        warningMessage,
        isEmailValid,
        isPasswordValid,
        isUsernameValid,
      ];
}
