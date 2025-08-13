import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetWeatherForecastUseCase implements UseCase<List<WeatherEntity>, GetWeatherForecastParams> {
  final WeatherRepository repository;

  GetWeatherForecastUseCase(this.repository);

  @override
  Future<Either<Failure, List<WeatherEntity>>> call(GetWeatherForecastParams params) async {
    return await repository.getWeatherForecast(params.routePoints);
  }
}

class GetWeatherForecastParams extends Equatable {
  final List<Map<String, double>> routePoints;

  const GetWeatherForecastParams({
    required this.routePoints,
  });

  @override
  List<Object> get props => [routePoints];
}
