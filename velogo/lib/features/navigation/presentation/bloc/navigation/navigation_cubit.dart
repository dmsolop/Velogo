import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/usecases/get_navigation_state_usecase.dart';
import '../../../domain/usecases/save_navigation_state_usecase.dart';
import '../../../domain/entities/navigation_entity.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/services/log_service.dart';
import '../../../../../core/usecases/usecase.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  final GetNavigationStateUseCase _getNavigationStateUseCase;
  final SaveNavigationStateUseCase _saveNavigationStateUseCase;

  NavigationCubit({
    required GetNavigationStateUseCase getNavigationStateUseCase,
    required SaveNavigationStateUseCase saveNavigationStateUseCase,
  })  : _getNavigationStateUseCase = getNavigationStateUseCase,
        _saveNavigationStateUseCase = saveNavigationStateUseCase,
        super(const NavigationState(selectedTab: NavigationTab.home));

  /// Завантаження стану навігації
  Future<void> loadNavigationState() async {
    LogService.log('🧭 [NavigationCubit] Завантаження стану навігації');
    
    final result = await _getNavigationStateUseCase(NoParams());
    
    result.fold(
      (failure) {
        LogService.log('❌ [NavigationCubit] Помилка завантаження: ${failure.message}');
        // Використовуємо дефолтний стан при помилці
      },
      (navigationEntity) {
        LogService.log('✅ [NavigationCubit] Стан навігації завантажено: ${navigationEntity.selectedTab}');
        emit(state.copyWith(selectedTab: navigationEntity.selectedTab));
      },
    );
  }

  /// Вибір вкладки
  Future<void> selectTab(NavigationTab tab) async {
    LogService.log('🧭 [NavigationCubit] Вибір вкладки: $tab');
    
    emit(state.copyWith(selectedTab: tab));
    
    // Зберігаємо стан
    final navigationEntity = NavigationEntity(
      selectedTab: tab,
      lastNavigationTime: DateTime.now(),
      currentRoute: '/${tab.name}',
    );
    
    final result = await _saveNavigationStateUseCase(SaveNavigationStateParams(
      navigationState: navigationEntity,
    ));
    
    result.fold(
      (failure) {
        LogService.log('❌ [NavigationCubit] Помилка збереження: ${failure.message}');
      },
      (_) {
        LogService.log('✅ [NavigationCubit] Стан навігації збережено');
      },
    );
  }
}
