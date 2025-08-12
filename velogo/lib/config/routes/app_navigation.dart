import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/start_screen.dart';
import '../../features/auth/presentation/pages/registration_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/password_recovery_screen.dart';
import '../../shared/CustomBottomNavigationController.dart';

class AppNavigation {
  static const String start = '/';
  static const String registration = '/registration';
  static const String login = '/login';
  static const String passwordRecovery = '/password-recovery';
  static const String main = '/home';

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
      case main:
        return MaterialPageRoute(
            builder: (_) => const CustomBottomNavigationController());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
