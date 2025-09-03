import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

part 'get_weather_data_usecase.freezed.dart';

class GetWeatherDataUseCase implements UseCase<WeatherEntity, GetWeatherDataParams> {
  final WeatherRepository repository;

  GetWeatherDataUseCase(this.repository);

  @override
  Future<Either<Failure, WeatherEntity>> call(GetWeatherDataParams params) async {
    return await repository.getWeatherData(params.lat, params.lon);
  }
}

@freezed
class GetWeatherDataParams with _$GetWeatherDataParams {
  const factory GetWeatherDataParams({
    required double lat,
    required double lon,
  }) = _GetWeatherDataParams;
}
