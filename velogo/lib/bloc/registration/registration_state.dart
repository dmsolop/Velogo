import 'package:equatable/equatable.dart';

class RegistrationState extends Equatable {
  final String username;
  final String lastName;
  final DateTime? birthday;
  final String email;
  final String password;
  final String gender;
  final String country;
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
  final bool isLastnameValid;

  const RegistrationState({
    this.username = '',
    this.lastName = '',
    this.birthday,
    this.email = '',
    this.password = '',
    this.gender = '',
    this.country = '',
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
    this.isLastnameValid = true,
  });

  RegistrationState copyWith({
    String? username,
    String? lastName,
    DateTime? birthday,
    String? email,
    String? password,
    String? gender,
    String? country,
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
    bool? isLastnameValid,
  }) {
    return RegistrationState(
      username: username ?? this.username,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      email: email ?? this.email,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      country: country ?? this.country,
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
      isLastnameValid: isLastnameValid ?? this.isLastnameValid,
    );
  }

  @override
  List<Object?> get props => [
        username,
        lastName,
        birthday,
        email,
        password,
        gender,
        country,
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
        isLastnameValid,
      ];
}
