import 'package:flutter/material.dart';

class ScreenNavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    if (navigatorKey.currentState == null) {
      throw Exception("NavigatorState is not initialized.");
    }
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  static void goBack() {
    if (navigatorKey.currentState == null) {
      throw Exception("NavigatorState is not initialized.");
    }
    return navigatorKey.currentState!.pop();
  }
}
