import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Базовий абстрактний клас для всіх Use Cases
/// 
/// Функціональність:
/// - Визначає контракт для всіх Use Cases в додатку
/// - Використовує Either<Failure, Type> для обробки помилок
/// - Слідує Clean Architecture принципам
/// 
/// Типи:
/// - Type: тип повертаємого значення
/// - Params: тип параметрів для виконання Use Case
/// 
/// Використовується в: всіх Use Cases додатку
abstract class UseCase<Type, Params> {
  /// Виконання Use Case з заданими параметрами
  /// 
  /// Повертає: Either<Failure, Type> - результат операції або помилку
  Future<Either<Failure, Type>> call(Params params);
}

/// Клас для Use Cases, які не потребують параметрів
/// 
/// Використовується в: GetSettingsUseCase та інших Use Cases без параметрів
class NoParams {
  const NoParams();
}
