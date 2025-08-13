import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_entity.freezed.dart';

@freezed
class ThemeEntity with _$ThemeEntity {
  const factory ThemeEntity({
    required AppThemeMode themeMode,
    required DateTime lastThemeChange,
    required bool isSystemTheme,
  }) = _ThemeEntity;
}

enum AppThemeMode { system, light, dark }
