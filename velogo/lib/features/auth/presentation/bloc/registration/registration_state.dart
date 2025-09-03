import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_state.freezed.dart';

@freezed
class RegistrationState with _$RegistrationState {
  const factory RegistrationState({
    @Default('') String username,
    @Default('') String lastName,
    DateTime? birthday,
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default('') String gender,
    @Default('') String country,
    @Default(false) bool isSubmitting,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default(false) bool isError,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default('') String warningMessage,
    @Default(true) bool isEmailValid,
    @Default(true) bool isPasswordValid,
    @Default(true) bool isPasswordsMatch,
    @Default(true) bool isUsernameValid,
    @Default(true) bool isLastnameValid,
  }) = _RegistrationState;
}
