import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velogo/bloc/registration/registration_cubit.dart';
import 'bloc/theme/theme_cubit.dart';
import 'bloc/settings/settings_cubit.dart';
import 'bloc/navigation/navigation_cubit.dart';
import 'bloc/navigation/navigation_state.dart';
import 'shared/custom_bottom_navigation_bar.dart';
import 'screens/main_screen.dart';
import 'screens/route_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'navigation/app_navigation.dart';
import 'navigation/screen_navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(directory.path),
  );

  // Ініціалізуйте Firebase
  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings = const Settings(
    host: 'localhost:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );

  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => RegistrationCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == AppThemeMode.dark ||
            (themeMode == AppThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);

        return FutureBuilder<User?>(
            future: FirebaseAuth.instance.authStateChanges().first,
            builder: (context, snapshot) {
              String initialRoute = AppNavigation.start;
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                initialRoute = AppNavigation.main;
              }
              return MaterialApp(
                title: 'Velogo App',
                navigatorKey: ScreenNavigationService.navigatorKey,
                initialRoute: initialRoute,
                onGenerateRoute: AppNavigation.generateRoute,
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                // home: BlocBuilder<NavigationCubit, NavigationState>(
                //   builder: (context, state) {
                //     Widget currentScreen;
                //     switch (state.selectedTab) {
                //       case NavigationTab.home:
                //         currentScreen = const MainScreen();
                //         break;
                //       case NavigationTab.myRoutes:
                //         currentScreen = const RouteScreen();
                //         break;
                //       case NavigationTab.profile:
                //         currentScreen = const ProfileScreen();
                //         break;
                //       case NavigationTab.settings:
                //         currentScreen = const SettingsScreen();
                //         break;
                //     }

                //     return Scaffold(
                //       body: currentScreen,
                //       bottomNavigationBar: const CustomBottomNavigationBar(),
                //     );
                //   },
                // ),
              );
            });
      },
    );
  }
}
