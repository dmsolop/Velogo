import 'package:equatable/equatable.dart';

class RegistrationState extends Equatable {
  final String username;
  final String email;
  final String password;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isError;

  const RegistrationState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isError = false,
  });

  RegistrationState copyWith({
    String? username,
    String? email,
    String? password,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isError,
  }) {
    return RegistrationState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object> get props => [
        username,
        email,
        password,
        isSubmitting,
        isSuccess,
        isError,
      ];
}
