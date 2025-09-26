import 'package:dartz/dartz.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/core/usecases/usecase.dart';
import 'package:velogo/features/settings/domain/repositories/settings_repository.dart';

/// Use Case для оновлення профілю маршрутизації
/// 
/// Функціональність:
/// - Оновлює профіль маршрутизації (cycling-regular, driving-car, foot-walking)
/// - Зберігає зміни в локальному сховищі
/// - Повертає Either<Failure, Unit> для обробки помилок
/// - Слідує Clean Architecture принципам
/// 
/// Використовується в: SettingsCubit.changeRouteProfile()
class UpdateRouteProfileUseCase implements UseCase<Unit, String> {
  final SettingsRepository repository;

  UpdateRouteProfileUseCase({required this.repository});

  /// Виконання Use Case для оновлення профілю маршрутизації
  /// 
  /// Параметри:
  /// - value: новий профіль маршрутизації (cycling-regular, driving-car, foot-walking)
  /// 
  /// Повертає: Either<Failure, Unit> - результат операції
  @override
  Future<Either<Failure, Unit>> call(String value) async {
    return await repository.updateRouteProfile(value);
  }
}
