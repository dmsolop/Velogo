import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/core/usecases/usecase.dart';
import 'package:velogo/features/settings/domain/repositories/settings_repository.dart';

/// Use Case для оновлення налаштування перетягування маршрутів
/// 
/// Функціональність:
/// - Оновлює налаштування перетягування маршрутів в локальному сховищі
/// - Повертає Either<Failure, Unit> для обробки помилок
/// - Слідує Clean Architecture принципам
/// 
/// Використовується в: SettingsCubit.toggleRouteDragging()
class UpdateRouteDraggingUseCase implements UseCase<Unit, bool> {
  final SettingsRepository repository;

  UpdateRouteDraggingUseCase({required this.repository});

  /// Виконання Use Case для оновлення налаштування перетягування
  /// 
  /// Параметри:
  /// - value: нове значення налаштування (true/false)
  /// 
  /// Повертає: Either<Failure, Unit> - результат операції
  @override
  Future<Either<Failure, Unit>> call(bool value) async {
    return await repository.updateRouteDragging(value);
  }
}
