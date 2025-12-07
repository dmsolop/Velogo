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

/// Use Case для швидкого розрахунку базових параметрів секції (без API викликів)
///
/// Функціональність:
/// - Розраховує тільки distance (локально)
/// - Встановлює дефолтні значення для elevationGain, windEffect
/// - Використовується для швидкого відображення маршруту
///
/// Використовується в: CreateRouteScreen для швидкого відображення маршруту
class CalculateBasicSectionParametersUseCase implements UseCase<SectionParameters, CalculateBasicSectionParametersParams> {
  final RouteComplexityService _complexityService;

  CalculateBasicSectionParametersUseCase(this._complexityService);

  @override
  Future<Either<Failure, SectionParameters>> call(CalculateBasicSectionParametersParams params) async {
    return await _complexityService.calculateBasicSectionParameters(
      coordinates: params.coordinates,
      userProfile: params.userProfile,
      weatherData: params.weatherData,
      healthMetrics: params.healthMetrics,
    );
  }
}

/// Use Case для асинхронного оновлення параметрів секції
///
/// Функціональність:
/// - Розраховує elevationGain та windEffect паралельно через API
/// - Оновлює складність та averageSpeed на основі нових параметрів
///
/// Використовується в: CreateRouteScreen для поступового оновлення складності
class UpdateSectionParametersUseCase implements UseCase<SectionParameters, UpdateSectionParametersParams> {
  final RouteComplexityService _complexityService;

  UpdateSectionParametersUseCase(this._complexityService);

  @override
  Future<Either<Failure, SectionParameters>> call(UpdateSectionParametersParams params) async {
    return await _complexityService.updateSectionParametersAsync(
      currentParameters: params.currentParameters,
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

@freezed
class CalculateBasicSectionParametersParams with _$CalculateBasicSectionParametersParams {
  const factory CalculateBasicSectionParametersParams({
    required List<LatLng> coordinates,
    required ProfileEntity userProfile,
    WeatherData? weatherData,
    HealthMetrics? healthMetrics,
  }) = _CalculateBasicSectionParametersParams;
}

@freezed
class UpdateSectionParametersParams with _$UpdateSectionParametersParams {
  const factory UpdateSectionParametersParams({
    required SectionParameters currentParameters,
    required List<LatLng> coordinates,
    required LatLng startPoint,
    required LatLng endPoint,
    required ProfileEntity userProfile,
    WeatherData? weatherData,
    HealthMetrics? healthMetrics,
  }) = _UpdateSectionParametersParams;
}

