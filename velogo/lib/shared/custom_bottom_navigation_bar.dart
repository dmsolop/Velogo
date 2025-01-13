import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/navigation/navigation_cubit.dart';
import '../bloc/navigation/navigation_state.dart';
import '../bloc/theme/theme_cubit.dart';
import '../shared/base_colors.dart';
import '../screens/main_screen.dart';
import '../screens/route_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  final List<Widget> _screens = const [
    MainScreen(),
    RouteScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == AppThemeMode.dark;
        final backgroundColor =
            isDark ? BaseColors.bottomBarDark : BaseColors.bottomBarLight;
        const activeColor = BaseColors.iconSelected;
        const inactiveColor = BaseColors.iconUnselected;

        return BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            return Scaffold(
              body: IndexedStack(
                index: NavigationTab.values.indexOf(state.selectedTab),
                children: _screens,
              ),
              bottomNavigationBar: Platform.isIOS
                  ? CupertinoTabBar(
                      currentIndex:
                          NavigationTab.values.indexOf(state.selectedTab),
                      backgroundColor: backgroundColor,
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      onTap: (index) {
                        context
                            .read<NavigationCubit>()
                            .selectTab(NavigationTab.values[index]);
                      },
                      items: const [
                        BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.home), label: "Home"),
                        BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.map), label: "My Routes"),
                        BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.profile_circled),
                            label: "Profile"),
                        BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.settings),
                            label: "Settings"),
                      ],
                    )
                  : BottomNavigationBar(
                      currentIndex:
                          NavigationTab.values.indexOf(state.selectedTab),
                      backgroundColor: backgroundColor,
                      selectedItemColor: activeColor,
                      unselectedItemColor: inactiveColor,
                      onTap: (index) {
                        context
                            .read<NavigationCubit>()
                            .selectTab(NavigationTab.values[index]);
                      },
                      items: const [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.map), label: "Plan Route"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.directions_bike),
                            label: "My Routes"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.person), label: "Profile"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.settings), label: "Settings"),
                      ],
                    ),
            );
          },
        );
      },
    );
  }
}

// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/theme/theme_cubit.dart';
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
//     const MyRoutesScreen(),
//     const ProfileScreen(),
//     const SettingsScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeCubit, AppThemeMode>(
//       builder: (context, themeMode) {
//         final backgroundColor = themeMode == AppThemeMode.dark
//             ? BaseColors.bottomBarDark
//             : BaseColors.bottomBarLight;

//         return Scaffold(
//           body: IndexedStack(
//             index: _currentIndex,
//             children: _screens,
//           ),
//           bottomNavigationBar: Platform.isIOS
//               ? CupertinoTabBar(
//                   currentIndex: _currentIndex,
//                   backgroundColor: backgroundColor,
//                   activeColor: BaseColors.iconSelected,
//                   inactiveColor: BaseColors.iconUnselected,
//                   onTap: (index) {
//                     setState(() {
//                       _currentIndex = index;
//                     });
//                   },
//                   items: const [
//                     BottomNavigationBarItem(
//                       icon: Icon(CupertinoIcons.home),
//                       label: "Home",
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(CupertinoIcons.map),
//                       label: "My Routes",
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(CupertinoIcons.profile_circled),
//                       label: "Profile",
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(CupertinoIcons.settings),
//                       label: "Settings",
//                     ),
//                   ],
//                 )
//               : BottomNavigationBar(
//                   currentIndex: _currentIndex,
//                   backgroundColor: backgroundColor,
//                   selectedItemColor: BaseColors.iconSelected,
//                   unselectedItemColor: BaseColors.iconUnselected,
//                   onTap: (index) {
//                     setState(() {
//                       _currentIndex = index;
//                     });
//                   },
//                   items: const [
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.map),
//                       label: "Plan Route",
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.directions_bike),
//                       label: "My Routes",
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.person),
//                       label: "Profile",
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.settings),
//                       label: "Settings",
//                     ),
//                   ],
//                 ),
//         );
//       },
//     );
//   }
// }
