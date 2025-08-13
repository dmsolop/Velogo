import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetWeatherDataUseCase implements UseCase<WeatherEntity, GetWeatherDataParams> {
  final WeatherRepository repository;

  GetWeatherDataUseCase(this.repository);

  @override
  Future<Either<Failure, WeatherEntity>> call(GetWeatherDataParams params) async {
    return await repository.getWeatherData(params.lat, params.lon);
  }
}

class GetWeatherDataParams extends Equatable {
  final double lat;
  final double lon;

  const GetWeatherDataParams({
    required this.lat,
    required this.lon,
  });

  @override
  List<Object> get props => [lat, lon];
}
