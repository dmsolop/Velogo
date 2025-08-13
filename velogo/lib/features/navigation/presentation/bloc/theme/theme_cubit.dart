import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/usecases/get_theme_usecase.dart';
import '../../../domain/usecases/save_theme_usecase.dart';
import '../../../domain/entities/theme_entity.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/services/log_service.dart';
import '../../../../../core/usecases/usecase.dart';

class ThemeCubit extends HydratedCubit<AppThemeMode> {
  final GetThemeUseCase _getThemeUseCase;
  final SaveThemeUseCase _saveThemeUseCase;

  ThemeCubit({
    required GetThemeUseCase getThemeUseCase,
    required SaveThemeUseCase saveThemeUseCase,
  })  : _getThemeUseCase = getThemeUseCase,
        _saveThemeUseCase = saveThemeUseCase,
        super(AppThemeMode.system);

  /// Завантаження теми
  Future<void> loadTheme() async {
    LogService.log('🎨 [ThemeCubit] Завантаження теми');
    
    final result = await _getThemeUseCase(NoParams());
    
    result.fold(
      (failure) {
        LogService.log('❌ [ThemeCubit] Помилка завантаження: ${failure.message}');
        // Використовуємо дефолтну тему при помилці
      },
      (themeEntity) {
        LogService.log('✅ [ThemeCubit] Тема завантажена: ${themeEntity.themeMode}');
        emit(themeEntity.themeMode);
      },
    );
  }

  /// Встановлення теми
  Future<void> setTheme(AppThemeMode mode) async {
    LogService.log('🎨 [ThemeCubit] Встановлення теми: $mode');
    
    emit(mode);
    
    // Зберігаємо тему
    final themeEntity = ThemeEntity(
      themeMode: mode,
      lastThemeChange: DateTime.now(),
      isSystemTheme: mode == AppThemeMode.system,
    );
    
    final result = await _saveThemeUseCase(SaveThemeParams(theme: themeEntity));
    
    result.fold(
      (failure) {
        LogService.log('❌ [ThemeCubit] Помилка збереження: ${failure.message}');
      },
      (_) {
        LogService.log('✅ [ThemeCubit] Тема збережена');
      },
    );
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
