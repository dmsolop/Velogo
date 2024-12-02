import 'package:flutter/material.dart';
import 'screens/start_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/password_recovery_screen.dart';
import 'screens/route_screen.dart';
import 'screens/main_screen.dart';
import 'screens/route_screen.dart';
import 'screens/create_route_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const StartScreen(),
      // home: const RegistrationScreen(),
      // home: const LoginScreen(),
      // home: const PasswordRecoveryScreen(),
      // home: const RouteScreen(),
      // home: const MainScreen(),
      home: const RouteScreen(),
      // home: const CreateRouteScreen(),
      // home: const StartScreen(),
    );
  }
}
