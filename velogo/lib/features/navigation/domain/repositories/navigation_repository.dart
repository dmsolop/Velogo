import 'package:dartz/dartz.dart';
import '../entities/navigation_entity.dart';
import '../../../../core/error/failures.dart';

abstract class NavigationRepository {
  /// Отримання поточного стану навігації
  Future<Either<Failure, NavigationEntity>> getCurrentNavigation();
  
  /// Збереження стану навігації
  Future<Either<Failure, void>> saveNavigationState(NavigationEntity navigationState);
  
  /// Очищення історії навігації
  Future<Either<Failure, void>> clearNavigationHistory();
}
