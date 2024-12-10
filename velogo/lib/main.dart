import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:provider/provider.dart';
import 'screens/start_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/password_recovery_screen.dart';
import 'screens/route_screen.dart';
import 'screens/main_screen.dart';
import 'screens/route_screen.dart';
import 'screens/create_route_screen.dart';
import 'providers/theme_provider.dart';
import 'shared/custom_bottom_navigation_bar.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Builder(
      builder: (context) {
        // Безпечне оновлення теми після побудови
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final systemBrightness = MediaQuery.of(context).platformBrightness;
          themeProvider.updateSystemBrightness(systemBrightness);
        });

        return MaterialApp(
          title: 'Custom Navigation App',
          theme: themeProvider.themeData,
          home: const Scaffold(
            body: CustomBottomNavigationBar(),
          ),
        );
      },
    );
  }
}
