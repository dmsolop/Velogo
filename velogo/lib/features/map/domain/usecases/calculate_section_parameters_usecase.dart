import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/health_metrics.dart';
import '../../../../core/services/route_complexity_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../../../weather/data/models/weather_data.dart';

part 'calculate_section_parameters_usecase.freezed.dart';

/// Use Case для розрахунку всіх параметрів секції маршруту
///
/// Функціональність:
/// - Розраховує elevationGain, windEffect, surfaceType, difficulty, averageSpeed
/// - Враховує індивідуальні можливості користувача
/// - Використовує погодні дані (якщо доступні)
///
/// Використовується в: CreateRouteScreen при створенні секцій маршруту
class CalculateSectionParametersUseCase implements UseCase<SectionParameters, CalculateSectionParametersParams> {
  final RouteComplexityService _complexityService;

  CalculateSectionParametersUseCase(this._complexityService);

  @override
  Future<Either<Failure, SectionParameters>> call(CalculateSectionParametersParams params) async {
    return await _complexityService.calculateSectionParameters(
      coordinates: params.coordinates,
      startPoint: params.startPoint,
      endPoint: params.endPoint,
      userProfile: params.userProfile,
      weatherData: params.weatherData,
      healthMetrics: params.healthMetrics,
    );
  }
}

@freezed
class CalculateSectionParametersParams with _$CalculateSectionParametersParams {
  const factory CalculateSectionParametersParams({
    required List<LatLng> coordinates,
    required LatLng startPoint,
    required LatLng endPoint,
    required ProfileEntity userProfile,
    WeatherData? weatherData,
    HealthMetrics? healthMetrics,
  }) = _CalculateSectionParametersParams;
}

