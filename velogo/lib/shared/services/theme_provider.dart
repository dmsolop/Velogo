import 'package:flutter/material.dart';
import '../base_colors.dart';

enum AppThemeMode { system, light, dark }

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _appThemeMode = AppThemeMode.system;
  Brightness? _systemBrightness;

  ThemeData get themeData {
    if (_appThemeMode == AppThemeMode.system) {
      return _systemBrightness == Brightness.dark ? _darkTheme : _lightTheme;
    } else if (_appThemeMode == AppThemeMode.dark) {
      return _darkTheme;
    } else {
      return _lightTheme;
    }
  }

  ThemeData get _darkTheme => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: BaseColors.backgroundDark,
        primaryColor: BaseColors.primary,
      );

  ThemeData get _lightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: BaseColors.backgroundLight,
        primaryColor: BaseColors.primary,
      );

  AppThemeMode get appThemeMode => _appThemeMode;

  void setThemeMode(AppThemeMode mode) {
    _appThemeMode = mode;
    notifyListeners();
  }

  void updateSystemBrightness(Brightness brightness) {
    _systemBrightness = brightness;
    if (_appThemeMode == AppThemeMode.system) {
      notifyListeners();
    }
  }

  bool get isDarkTheme {
    if (_appThemeMode == AppThemeMode.dark) {
      return true;
    } else if (_appThemeMode == AppThemeMode.light) {
      return false;
    } else {
      return _systemBrightness == Brightness.dark;
    }
  }

  bool get isSystemTheme => _appThemeMode == AppThemeMode.system;
}
