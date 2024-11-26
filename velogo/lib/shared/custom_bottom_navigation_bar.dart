import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../shared/base_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // CupertinoTabBar for iOS
      return CupertinoTabBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.map),
            label: "Plan Route",
          ),
          BottomNavigationBarItem(
            icon:
                Icon(CupertinoIcons.location), // Замінено на відповідну іконку
            label: "My Routes",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.graph_square),
            label: "Statistics",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: "Settings",
          ),
        ],
      );
    } else {
      // BottomNavigationBar for Android and others
      return BottomNavigationBar(
        backgroundColor: BaseColors.bottomBarDark,
        selectedItemColor: BaseColors.iconSelected,
        unselectedItemColor: BaseColors.iconUnselected,
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Plan Route",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike), // Використовується Material Icon
            label: "My Routes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Statistics",
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
      );
    }
  }
}
