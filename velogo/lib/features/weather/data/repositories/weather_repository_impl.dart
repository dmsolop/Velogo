import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../models/weather_data.dart';
import '../datasources/weather_service.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final String _boxName = "weather_data";
  final WeatherService _weatherService;

  WeatherRepositoryImpl(this._weatherService);

  Future<Box<WeatherData>> _openBox() async {
    return await Hive.openBox<WeatherData>(_boxName);
  }

  @override
  Future<Either<Failure, WeatherEntity>> getWeatherData(double lat, double lon) async {
    try {
      final box = await _openBox();

      // Перевіряємо кеш
      final cachedData = box.values.where((weather) => weather.lat == lat && weather.lon == lon).toList();

      if (cachedData.isNotEmpty && !_isDataStale(cachedData.first)) {
        return Right(cachedData.first.toEntity());
      }

      // Отримуємо нові дані
      final weatherData = await _weatherService.getWeather(lat, lon);

      final newData = WeatherData(
        lat: lat,
        lon: lon,
        windSpeed: weatherData['hourly']['wind_speed'][0].toDouble(),
        windDirection: weatherData['hourly']['wind_direction'][0].toDouble(),
        windGust: weatherData['hourly']['wind_gust'][0].toDouble(),
        precipitation: weatherData['hourly']['precipitation']?[0]?.toDouble() ?? 0.0,
        precipitationType: weatherData['hourly']['precipitation_type']?[0]?.toDouble() ?? 0.0,
        humidity: weatherData['hourly']['humidity']?[0]?.toDouble() ?? 50.0,
        temperature: weatherData['hourly']['temperature']?[0]?.toDouble() ?? 20.0,
        visibility: weatherData['hourly']['visibility']?[0]?.toDouble() ?? 10.0,
        roadCondition: 0.0,
        timestamp: DateTime.now(),
        source: "API",
      );

      await _updateWeatherData(newData);
      return Right(newData.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get weather data: $e'));
    }
  }

  @override
  Future<Either<Failure, List<WeatherEntity>>> getWeatherForecast(List<Map<String, double>> routePoints) async {
    try {
      final List<WeatherEntity> weatherData = [];

      for (final point in routePoints) {
        final result = await getWeatherData(point['lat']!, point['lon']!);
        result.fold(
          (failure) => throw ServerException(failure.message),
          (weather) => weatherData.add(weather),
        );
      }

      return Right(weatherData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get weather forecast: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveWeatherData(WeatherEntity weatherData) async {
    try {
      final box = await _openBox();

      // Конвертуємо entity в model (потрібно створити fromEntity метод)
      final data = WeatherData(
        lat: weatherData.lat,
        lon: weatherData.lon,
        windSpeed: weatherData.windSpeed,
        windDirection: weatherData.windDirection,
        windGust: weatherData.windGust,
        precipitation: weatherData.precipitation,
        precipitationType: weatherData.precipitationType,
        humidity: weatherData.humidity,
        temperature: weatherData.temperature,
        visibility: weatherData.visibility,
        roadCondition: weatherData.roadCondition,
        timestamp: weatherData.timestamp,
        source: weatherData.source,
      );

      await _updateWeatherData(data);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to save weather data: $e'));
    }
  }

  @override
  Future<Either<Failure, WeatherEntity?>> getCachedWeatherData(double lat, double lon) async {
    try {
      final box = await _openBox();

      final cachedData = box.values.where((weather) => weather.lat == lat && weather.lon == lon).toList();

      if (cachedData.isNotEmpty && !_isDataStale(cachedData.first)) {
        return Right(cachedData.first.toEntity());
      }

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get cached weather data: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearWeatherCache() async {
    try {
      final box = await _openBox();
      await box.clear();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to clear weather cache: $e'));
    }
  }

  /// Зберігаємо погоду в БД, видаляючи старі записи для цієї локації
  Future<void> _updateWeatherData(WeatherData data) async {
    final box = await _openBox();

    // Видаляємо старі записи для цієї локації
    final oldEntries = box.values.where((entry) => entry.lat == data.lat && entry.lon == data.lon).toList();

    for (var entry in oldEntries) {
      entry.delete();
    }

    // Додаємо новий запис
    await box.add(data);
  }

  /// Перевіряємо чи дані не застаріли (старіше 1 години)
  bool _isDataStale(WeatherData data) {
    final now = DateTime.now();
    final difference = now.difference(data.timestamp);
    return difference.inHours >= 1;
  }
}
