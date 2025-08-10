import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velogo/features/auth/presentation/bloc/registration/registration_cubit.dart';
import 'bloc/theme/theme_cubit.dart';
import 'bloc/settings/settings_cubit.dart';
import 'bloc/navigation/navigation_cubit.dart';
import 'features/weather/presentation/bloc/weather/weather_cubit.dart';
import 'features/weather/data/repositories/weather_repository.dart';
import 'features/weather/data/datasources/weather_service.dart';
import 'config/routes/app_navigation.dart';
import 'config/routes/screen_navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/weather/data/models/weather_data.dart';
import 'core/constants/api_constants.dart';
import 'services/log_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(directory.path),
  );

  // Ініціалізація Hive
  await Hive.initFlutter();

  // Реєстрація Hive адаптерів
  Hive.registerAdapter(WeatherDataAdapter());

  // Ініціалізуйте Firebase
  await Firebase.initializeApp();

  // Ініціалізація Remote Config
  await ApiConstants.initialize();

  // Ініціалізація LogService
  await LogService.init();
  await LogService.clearLog();

  // Налаштування для емуляторів
  if (kDebugMode) {
    // Використовуємо реальний Firebase для Auth (без reCAPTCHA проблем)
    // FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);

    // Емулятори тільки для Firestore та Functions
    FirebaseFirestore.instance.settings = const Settings(
      host: '127.0.0.1:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );

    FirebaseFunctions.instance.useFunctionsEmulator('127.0.0.1', 5001);
  }

  // Визначення початкового маршруту
  String initialRoute = AppNavigation.start;
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    initialRoute = AppNavigation.main;
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => RegistrationCubit()),
        BlocProvider(create: (_) => WeatherCubit(WeatherRepository(WeatherService()))),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == AppThemeMode.dark || (themeMode == AppThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);

        return MaterialApp(
          title: 'Velogo App',
          navigatorKey: ScreenNavigationService.navigatorKey,
          initialRoute: initialRoute,
          onGenerateRoute: AppNavigation.generateRoute,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}
