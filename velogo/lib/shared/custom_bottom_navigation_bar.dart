import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../shared/base_colors.dart';
import '../screens/main_screen.dart';
import '../screens/route_screen.dart';
import '../screens/my_routes_screen.dart';

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
    // const RouteScreen(),
    const MyRoutesScreen(),
    // Можна додати інші екрани тут
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens, // Екрани залишаються в пам'яті після завантаження
      ),
      bottomNavigationBar: Platform.isIOS
          ? CupertinoTabBar(
              currentIndex: _currentIndex,
              backgroundColor: themeProvider.isDarkTheme
                  ? BaseColors.bottomBarDark
                  : BaseColors.bottomBarLight,
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
              ],
            )
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              backgroundColor: themeProvider.isDarkTheme
                  ? BaseColors.bottomBarDark
                  : BaseColors.bottomBarLight,
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
              ],
            ),
    );
  }
}




// import 'dart:io'; // Для перевірки платформи
// import 'package:flutter/cupertino.dart'; // Для iOS CupertinoTabBar
// import 'package:flutter/material.dart'; // Для Android BottomNavigationBar
// import 'package:provider/provider.dart'; // Для ThemeProvider
// import '../providers/theme_provider.dart'; // Тема
// import '../shared/base_colors.dart'; // Кольори
// import '../screens/main_screen.dart';
// import '../screens/route_screen.dart';
// // import '../screens/statistics_screen.dart';
// // import '../screens/profile_screen.dart';
// // import '../screens/settings_screen.dart';

// class CustomBottomNavigationBar extends StatefulWidget {
//   const CustomBottomNavigationBar({Key? key}) : super(key: key);

//   @override
//   _CustomBottomNavigationBarState createState() =>
//       _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState
//     extends State<CustomBottomNavigationBar> {
//   int _currentIndex = 0;

//   final _pages = [
//     const MainScreen(),
//     const RouteScreen(),
//     // const StatisticsScreen(),
//     // const ProfileScreen(),
//     // const SettingsScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _pages.map((page) {
//           return Navigator(
//             onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => page),
//           );
//         }).toList(),
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
//                   icon: Icon(CupertinoIcons.map),
//                   label: "Plan Route",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(CupertinoIcons.location),
//                   label: "My Routes",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(CupertinoIcons.graph_square),
//                   label: "Statistics",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(CupertinoIcons.person),
//                   label: "Profile",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(CupertinoIcons.settings),
//                   label: "Settings",
//                 ),
//               ],
//             )
//           : BottomNavigationBar(
//               backgroundColor: themeProvider.isDarkTheme
//                   ? BaseColors.bottomBarDark
//                   : BaseColors.bottomBarLight,
//               selectedItemColor: BaseColors.iconSelected,
//               unselectedItemColor: BaseColors.iconUnselected,
//               currentIndex: _currentIndex,
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
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.bar_chart),
//                   label: "Statistics",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.person),
//                   label: "Profile",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.settings),
//                   label: "Settings",
//                 ),
//               ],
//             ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/theme_provider.dart';
// import '../shared/base_colors.dart';
// import '../screens/main_screen.dart';
// import '../screens/route_screen.dart';
// // import '../screens/statistics_screen.dart';
// // import '../screens/profile_screen.dart';
// // import '../screens/settings_screen.dart';

// class CustomBottomNavigationBar extends StatefulWidget {
//   const CustomBottomNavigationBar({Key? key}) : super(key: key);

//   @override
//   _CustomBottomNavigationBarState createState() =>
//       _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   int _currentIndex = 0;

//   final _pages = [
//     const MainScreen(),
//     const RouteScreen(),
//     // const StatisticsScreen(),
//     // const ProfileScreen(),
//     // const SettingsScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _pages.map((page) {
//           return Navigator(
//             onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => page),
//           );
//         }).toList(),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: themeProvider.isDarkTheme
//             ? BaseColors.bottomBarDark
//             : BaseColors.bottomBarLight,
//         selectedItemColor: BaseColors.iconSelected,
//         unselectedItemColor: BaseColors.iconUnselected,
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.map),
//             label: "Plan Route",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.directions_bike),
//             label: "My Routes",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bar_chart),
//             label: "Statistics",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: "Profile",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: "Settings",
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'dart:io';
// import '../shared/base_colors.dart';

// class CustomBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const CustomBottomNavigationBar({
//     Key? key,
//     required this.currentIndex,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (Platform.isIOS) {
//       // CupertinoTabBar for iOS
//       return CupertinoTabBar(
//         currentIndex: currentIndex,
//         onTap: onTap,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.map),
//             label: "Plan Route",
//           ),
//           BottomNavigationBarItem(
//             icon:
//                 Icon(CupertinoIcons.location), // Замінено на відповідну іконку
//             label: "My Routes",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.graph_square),
//             label: "Statistics",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.person),
//             label: "Profile",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.settings),
//             label: "Settings",
//           ),
//         ],
//       );
//     } else {
//       // BottomNavigationBar for Android and others
//       return BottomNavigationBar(
//         backgroundColor: BaseColors.bottomBarDark,
//         selectedItemColor: BaseColors.iconSelected,
//         unselectedItemColor: BaseColors.iconUnselected,
//         currentIndex: currentIndex,
//         onTap: onTap,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.map),
//             label: "Plan Route",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.directions_bike), // Використовується Material Icon
//             label: "My Routes",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bar_chart),
//             label: "Statistics",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: "Profile",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: "Settings",
//           ),
//         ],
//       );
//     }
//   }
// }
