import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/routing_repository.dart';

part 'calculate_route_usecase.freezed.dart';

/// Use Case для розрахунку маршруту між двома точками
///
/// Функціональність:
/// - Розраховує маршрут по дорогах між двома точками
/// - Підтримує різні профілі маршрутизації
/// - Повертає координати маршруту або помилку
///
/// Використовується в: CreateRouteCubit, RouteCubit
class CalculateRouteUseCase implements UseCase<List<LatLng>, CalculateRouteParams> {
  final RoutingRepository repository;

  CalculateRouteUseCase(this.repository);

  @override
  Future<Either<Failure, List<LatLng>>> call(CalculateRouteParams params) async {
    return await repository.calculateRoute(
      startPoint: params.startPoint,
      endPoint: params.endPoint,
      profile: params.profile,
    );
  }
}

@freezed
class CalculateRouteParams with _$CalculateRouteParams {
  const factory CalculateRouteParams({
    required LatLng startPoint,
    required LatLng endPoint,
    @Default('cycling-regular') String profile,
  }) = _CalculateRouteParams;
}

