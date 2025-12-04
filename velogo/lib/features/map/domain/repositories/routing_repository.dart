import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failures.dart';

/// Репозиторій для маршрутизації та розрахунку маршрутів
///
/// Відповідає за:
/// - Розрахунок маршрутів між точками
/// - Розрахунок відстаней
/// - Розрахунок набору висоти
/// - Розрахунок впливу вітру
///
/// Використовується в: Use Cases для маршрутизації
abstract class RoutingRepository {
  /// Розрахунок маршруту між двома точками з обробкою помилок
  ///
  /// Повертає координати маршруту або детальну інформацію про помилку
  ///
  /// Параметри:
  /// - startPoint: початкова точка маршруту
  /// - endPoint: кінцева точка маршруту
  /// - profile: профіль маршрутизації (cycling-regular, driving-car, foot-walking)
  ///
  /// Використовується в: CalculateRouteUseCase
  Future<Either<Failure, List<LatLng>>> calculateRoute({
    required LatLng startPoint,
    required LatLng endPoint,
    required String profile,
  });

  /// Розрахунок відстані маршруту по координатах
  ///
  /// Параметри:
  /// - coordinates: список координат маршруту
  ///
  /// Використовується в: RouteComplexityService, CalculateSectionParametersUseCase
  Future<Either<Failure, double>> calculateRouteDistance(List<LatLng> coordinates);

  /// Розрахунок набору висоти між двома точками
  ///
  /// Параметри:
  /// - startPoint: початкова точка
  /// - endPoint: кінцева точка
  ///
  /// Використовується в: RouteComplexityService, CalculateSectionParametersUseCase
  Future<Either<Failure, double>> calculateElevationGain({
    required LatLng startPoint,
    required LatLng endPoint,
  });

  /// Розрахунок впливу вітру між двома точками
  ///
  /// Параметри:
  /// - startPoint: початкова точка
  /// - endPoint: кінцева точка
  ///
  /// Використовується в: RouteComplexityService, CalculateSectionParametersUseCase
  Future<Either<Failure, double>> calculateWindEffect({
    required LatLng startPoint,
    required LatLng endPoint,
  });
}

