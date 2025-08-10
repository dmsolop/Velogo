import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/navigation/presentation/bloc/navigation/navigation_cubit.dart';
import '../features/navigation/presentation/bloc/navigation/navigation_state.dart';
import '../features/navigation/presentation/bloc/theme/theme_cubit.dart';
import '../shared/base_colors.dart';
import '../features/navigation/presentation/pages/main_screen.dart';
import '../features/map/presentation/pages/route_screen.dart';
import '../features/profile/presentation/pages/profile_screen.dart';
import '../features/settings/presentation/pages/settings_screen.dart';

class CustomBottomNavigationController extends StatelessWidget {
  const CustomBottomNavigationController({super.key});

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
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) async {
                if (!didPop) return;
                final isFirstRouteInCurrentTab =
                    !await _navigatorKeys[state.selectedTab]!
                        .currentState!
                        .maybePop();
                if (isFirstRouteInCurrentTab &&
                    state.selectedTab != NavigationTab.home) {
                  context.read<NavigationCubit>().selectTab(NavigationTab.home);
                }
              },
              child: Scaffold(
                body: IndexedStack(
                  index: NavigationTab.values.indexOf(state.selectedTab),
                  children: NavigationTab.values.map((tab) {
                    return Navigator(
                      key: _navigatorKeys[tab],
                      onGenerateRoute: (routeSettings) {
                        return MaterialPageRoute(
                          builder: (context) => _getScreenForTab(tab),
                        );
                      },
                    );
                  }).toList(),
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
                              icon: Icon(CupertinoIcons.map),
                              label: "My Routes"),
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
              ),
            );
          },
        );
      },
    );
  }

  static final Map<NavigationTab, GlobalKey<NavigatorState>> _navigatorKeys = {
    NavigationTab.home: GlobalKey<NavigatorState>(),
    NavigationTab.myRoutes: GlobalKey<NavigatorState>(),
    NavigationTab.profile: GlobalKey<NavigatorState>(),
    NavigationTab.settings: GlobalKey<NavigatorState>(),
  };

  Widget _getScreenForTab(NavigationTab tab) {
    switch (tab) {
      case NavigationTab.home:
        return const MainScreen();
      case NavigationTab.myRoutes:
        return const RouteScreen();
      case NavigationTab.profile:
        return const ProfileScreen();
      case NavigationTab.settings:
        return const SettingsScreen();
    }
  }
}
