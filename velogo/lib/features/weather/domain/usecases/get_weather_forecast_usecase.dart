import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

part 'get_weather_forecast_usecase.freezed.dart';

class GetWeatherForecastUseCase implements UseCase<List<WeatherEntity>, GetWeatherForecastParams> {
  final WeatherRepository repository;

  GetWeatherForecastUseCase(this.repository);

  @override
  Future<Either<Failure, List<WeatherEntity>>> call(GetWeatherForecastParams params) async {
    return await repository.getWeatherForecast(params.routePoints);
  }
}

@freezed
class GetWeatherForecastParams with _$GetWeatherForecastParams {
  const factory GetWeatherForecastParams({
    required List<Map<String, double>> routePoints,
  }) = _GetWeatherForecastParams;
}
