import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/routing_repository.dart';

part 'calculate_wind_effect_usecase.freezed.dart';

/// Use Case для розрахунку впливу вітру між двома точками
///
/// Функціональність:
/// - Розраховує вплив вітру на маршрут між двома точками
/// - Використовується для розрахунку складності маршруту
///
/// Використовується в: CreateRouteCubit
class CalculateWindEffectUseCase implements UseCase<double, CalculateWindEffectParams> {
  final RoutingRepository repository;

  CalculateWindEffectUseCase(this.repository);

  @override
  Future<Either<Failure, double>> call(CalculateWindEffectParams params) async {
    return await repository.calculateWindEffect(
      startPoint: params.startPoint,
      endPoint: params.endPoint,
    );
  }
}

@freezed
class CalculateWindEffectParams with _$CalculateWindEffectParams {
  const factory CalculateWindEffectParams({
    required LatLng startPoint,
    required LatLng endPoint,
  }) = _CalculateWindEffectParams;
}

