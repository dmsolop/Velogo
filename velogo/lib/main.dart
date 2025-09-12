import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velogo/core/di/injection_container.dart' as di;
import 'config/routes/app_navigation.dart';
import 'config/routes/screen_navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/weather/data/models/weather_data.dart';
import 'features/navigation/presentation/bloc/theme/theme_cubit.dart';
import 'features/settings/presentation/bloc/settings/settings_cubit.dart';
import 'features/navigation/presentation/bloc/navigation/navigation_cubit.dart';
import 'features/auth/presentation/bloc/registration/registration_cubit.dart';
import 'features/weather/presentation/bloc/weather/weather_cubit.dart';
import 'features/navigation/domain/entities/theme_entity.dart';
import 'features/map/presentation/bloc/route/route_cubit.dart'; // New import
import 'features/map/presentation/bloc/route_difficulty/route_difficulty_cubit.dart'; // New import
import 'core/services/log_service.dart';

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

  // Ініціалізація Dependency Injection
  await di.init();

  // Ініціалізація LogService
  await LogService.init();
  await LogService.log('🚀 [MAIN] Velogo app starting...');

  // Визначення початкового маршруту
  String initialRoute = AppNavigation.start;
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    initialRoute = AppNavigation.main;
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider(create: (_) => di.sl<SettingsCubit>()),
        BlocProvider(create: (_) => di.sl<NavigationCubit>()),
        BlocProvider(create: (_) => di.sl<RegistrationCubit>()),
        BlocProvider(create: (_) => di.sl<WeatherCubit>()),
        BlocProvider(create: (_) => di.sl<RouteCubit>()), // New BlocProvider
        BlocProvider(create: (_) => di.sl<RouteDifficultyCubit>()), // New BlocProvider
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
