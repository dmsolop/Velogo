import 'package:dartz/dartz.dart';
import '../entities/weather_entity.dart';
import '../../../../core/error/failures.dart';

abstract class WeatherRepository {
  /// Отримання погоди для конкретних координат
  Future<Either<Failure, WeatherEntity>> getWeatherData(double lat, double lon);

  /// Отримання прогнозу погоди для маршруту
  Future<Either<Failure, List<WeatherEntity>>> getWeatherForecast(List<Map<String, double>> routePoints);

  /// Збереження погоди в локальне сховище
  Future<Either<Failure, void>> saveWeatherData(WeatherEntity weatherData);

  /// Отримання збереженої погоди
  Future<Either<Failure, WeatherEntity?>> getCachedWeatherData(double lat, double lon);

  /// Очищення кешу погоди
  Future<Either<Failure, void>> clearWeatherCache();
}
