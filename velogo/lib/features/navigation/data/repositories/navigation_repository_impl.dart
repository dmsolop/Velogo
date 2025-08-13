import 'package:dartz/dartz.dart';
import '../../domain/entities/navigation_entity.dart';
import '../../domain/repositories/navigation_repository.dart';
import '../../../../core/error/failures.dart';

class NavigationRepositoryImpl implements NavigationRepository {
  NavigationEntity? _currentNavigation;

  @override
  Future<Either<Failure, NavigationEntity>> getCurrentNavigation() async {
    if (_currentNavigation != null) {
      return Right(_currentNavigation!);
    }
    
    // Повертаємо дефолтний стан
    return Right(NavigationEntity(
      selectedTab: NavigationTab.home,
      lastNavigationTime: DateTime.now(),
      currentRoute: '/home',
    ));
  }

  @override
  Future<Either<Failure, void>> saveNavigationState(NavigationEntity navigationState) async {
    _currentNavigation = navigationState;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> clearNavigationHistory() async {
    _currentNavigation = null;
    return const Right(null);
  }
}
