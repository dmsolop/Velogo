import 'package:hydrated_bloc/hydrated_bloc.dart';

enum AppThemeMode { system, light, dark }

class ThemeCubit extends HydratedCubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.system);

  void setTheme(AppThemeMode mode) {
    emit(mode);
  }

  @override
  AppThemeMode? fromJson(Map<String, dynamic> json) {
    try {
      final mode = json['theme'] as String;
      return AppThemeMode.values.firstWhere(
        (e) => e.toString() == mode,
        orElse: () => AppThemeMode.system,
      );
    } catch (_) {
      return AppThemeMode.system;
    }
  }

  @override
  Map<String, dynamic>? toJson(AppThemeMode state) {
    return {'theme': state.toString()};
  }
}
