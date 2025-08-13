import 'package:dartz/dartz.dart';
import '../entities/theme_entity.dart';
import '../../../../core/error/failures.dart';

abstract class ThemeRepository {
  /// Отримання поточної теми
  Future<Either<Failure, ThemeEntity>> getCurrentTheme();
  
  /// Збереження теми
  Future<Either<Failure, void>> saveTheme(ThemeEntity theme);
  
  /// Скидання теми до системної
  Future<Either<Failure, void>> resetToSystemTheme();
}
