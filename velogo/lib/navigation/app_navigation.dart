import 'package:flutter/material.dart';
import '../screens/start_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/login_screen.dart';
import '../screens/password_recovery_screen.dart';

class AppNavigation {
  static const String start = '/';
  static const String registration = '/registration';
  static const String login = '/login';
  static const String passwordRecovery = '/password-recovery';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case start:
        return MaterialPageRoute(builder: (_) => const StartScreen());
      case registration:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case passwordRecovery:
        return MaterialPageRoute(
            builder: (_) => const PasswordRecoveryScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
