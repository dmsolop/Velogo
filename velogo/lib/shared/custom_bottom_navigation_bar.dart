import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme/theme_cubit.dart';
import '../shared/base_colors.dart';
import '../screens/main_screen.dart';
import '../screens/my_routes_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/profile_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  // Список екранів для навігації
  final List<Widget> _screens = [
    const MainScreen(),
    const MyRoutesScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, themeMode) {
        final backgroundColor = themeMode == AppThemeMode.dark
            ? BaseColors.bottomBarDark
            : BaseColors.bottomBarLight;

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: Platform.isIOS
              ? CupertinoTabBar(
                  currentIndex: _currentIndex,
                  backgroundColor: backgroundColor,
                  activeColor: BaseColors.iconSelected,
                  inactiveColor: BaseColors.iconUnselected,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.home),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.map),
                      label: "My Routes",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.profile_circled),
                      label: "Profile",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.settings),
                      label: "Settings",
                    ),
                  ],
                )
              : BottomNavigationBar(
                  currentIndex: _currentIndex,
                  backgroundColor: backgroundColor,
                  selectedItemColor: BaseColors.iconSelected,
                  unselectedItemColor: BaseColors.iconUnselected,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.map),
                      label: "Plan Route",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.directions_bike),
                      label: "My Routes",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: "Profile",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: "Settings",
                    ),
                  ],
                ),
        );
      },
    );
  }
}



// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/theme_provider.dart';
// import '../shared/base_colors.dart';
// import '../screens/main_screen.dart';
// import '../screens/my_routes_screen.dart';
// import '../screens/settings_screen.dart';
// import '../screens/profile_screen.dart';

// class CustomBottomNavigationBar extends StatefulWidget {
//   const CustomBottomNavigationBar({Key? key}) : super(key: key);

//   @override
//   _CustomBottomNavigationBarState createState() =>
//       _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   int _currentIndex = 0;

//   // Список екранів для навігації
//   final List<Widget> _screens = [
//     const MainScreen(),
//     // const RouteScreen(),
//     const MyRoutesScreen(),
//     const ProfileScreen(),
//     const SettingsScreen(),
//     // Можна додати інші екрани тут
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _screens, // Екрани залишаються в пам'яті після завантаження
//       ),
//       bottomNavigationBar: Platform.isIOS
//           ? CupertinoTabBar(
//               currentIndex: _currentIndex,
//               backgroundColor: themeProvider.isDarkTheme
//                   ? BaseColors.bottomBarDark
//                   : BaseColors.bottomBarLight,
//               activeColor: BaseColors.iconSelected,
//               inactiveColor: BaseColors.iconUnselected,
//               onTap: (index) {
//                 setState(() {
//                   _currentIndex = index;
//                 });
//               },
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Icon(CupertinoIcons.home),
//                   label: "Home",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(CupertinoIcons.map),
//                   label: "My Routes",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(CupertinoIcons.profile_circled),
//                   label: "Profile",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(CupertinoIcons.settings),
//                   label: "Settings",
//                 ),
//               ],
//             )
//           : BottomNavigationBar(
//               currentIndex: _currentIndex,
//               backgroundColor: themeProvider.isDarkTheme
//                   ? BaseColors.bottomBarDark
//                   : BaseColors.bottomBarLight,
//               selectedItemColor: BaseColors.iconSelected,
//               unselectedItemColor: BaseColors.iconUnselected,
//               onTap: (index) {
//                 setState(() {
//                   _currentIndex = index;
//                 });
//               },
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.map),
//                   label: "Plan Route",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.directions_bike),
//                   label: "My Routes",
//                 ),
//               ],
//             ),
//     );
//   }
// }

