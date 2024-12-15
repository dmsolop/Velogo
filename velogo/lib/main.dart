import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'bloc/settings/settings_cubit.dart';
import 'bloc/theme/theme_cubit.dart';
import 'shared/custom_bottom_navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ініціалізація сховища для HydratedBloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
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
          title: 'Custom Navigation App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const CustomBottomNavigationBar(),
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

// void main() {
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

