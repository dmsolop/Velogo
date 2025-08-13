import 'package:dartz/dartz.dart';
import '../../domain/entities/theme_entity.dart';
import '../../domain/repositories/theme_repository.dart';
import '../../../../core/error/failures.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  ThemeEntity? _currentTheme;

  @override
  Future<Either<Failure, ThemeEntity>> getCurrentTheme() async {
    if (_currentTheme != null) {
      return Right(_currentTheme!);
    }
    
    // Повертаємо дефолтну тему
    return Right(ThemeEntity(
      themeMode: AppThemeMode.system,
      lastThemeChange: DateTime.now(),
      isSystemTheme: true,
    ));
  }

  @override
  Future<Either<Failure, void>> saveTheme(ThemeEntity theme) async {
    _currentTheme = theme;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> resetToSystemTheme() async {
    _currentTheme = ThemeEntity(
      themeMode: AppThemeMode.system,
      lastThemeChange: DateTime.now(),
      isSystemTheme: true,
    );
    return const Right(null);
  }
}
