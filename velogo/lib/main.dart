import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

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
        BlocProvider(create: (_) => SettingsCubit()), // Збережено
        BlocProvider(create: (_) => NavigationCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == AppThemeMode.dark ||
            (themeMode == AppThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);

        return MaterialApp(
          title: 'Velogo App',
          navigatorKey: ScreenNavigationService.navigatorKey,
          initialRoute: AppNavigation.start,
          onGenerateRoute: AppNavigation.generateRoute,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: BlocBuilder<NavigationCubit, NavigationState>(
            builder: (context, state) {
              Widget currentScreen;
              switch (state.selectedTab) {
                case NavigationTab.home:
                  currentScreen = const MainScreen();
                  break;
                case NavigationTab.myRoutes:
                  currentScreen = const RouteScreen();
                  break;
                case NavigationTab.profile:
                  currentScreen = const ProfileScreen();
                  break;
                case NavigationTab.settings:
                  currentScreen = const SettingsScreen();
                  break;
                default:
                  currentScreen = const MainScreen();
              }

              return Scaffold(
                body: currentScreen,
                bottomNavigationBar: const CustomBottomNavigationBar(),
              );
            },
          ),
        );
      },
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:path_provider/path_provider.dart';
// import 'bloc/settings/settings_cubit.dart';
// import 'bloc/theme/theme_cubit.dart';
// import 'shared/custom_bottom_navigation_bar.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Ініціалізація сховища для HydratedBloc
//   HydratedBloc.storage = await HydratedStorage.build(
//     storageDirectory: await getApplicationDocumentsDirectory(),
//   );

//   runApp(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => ThemeCubit()),
//         BlocProvider(create: (_) => SettingsCubit()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeCubit, AppThemeMode>(
//       builder: (context, themeMode) {
//         final isDark = themeMode == AppThemeMode.dark ||
//             (themeMode == AppThemeMode.system &&
//                 MediaQuery.of(context).platformBrightness == Brightness.dark);

//         return MaterialApp(
//           title: 'Custom Navigation App',
//           theme: ThemeData.light(),
//           darkTheme: ThemeData.dark(),
//           themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
//           home: const CustomBottomNavigationBar(),
//         );
//       },
//     );
//   }
// }
