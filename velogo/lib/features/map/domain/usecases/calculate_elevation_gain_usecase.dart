import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/routing_repository.dart';

part 'calculate_elevation_gain_usecase.freezed.dart';

/// Use Case для розрахунку набору висоти між двома точками
///
/// Функціональність:
/// - Розраховує різницю висот між двома точками
/// - Використовується для розрахунку складності маршруту
///
/// Використовується в: CreateRouteCubit
class CalculateElevationGainUseCase implements UseCase<double, CalculateElevationGainParams> {
  final RoutingRepository repository;

  CalculateElevationGainUseCase(this.repository);

  @override
  Future<Either<Failure, double>> call(CalculateElevationGainParams params) async {
    return await repository.calculateElevationGain(
      startPoint: params.startPoint,
      endPoint: params.endPoint,
    );
  }
}

@freezed
class CalculateElevationGainParams with _$CalculateElevationGainParams {
  const factory CalculateElevationGainParams({
    required LatLng startPoint,
    required LatLng endPoint,
  }) = _CalculateElevationGainParams;
}

