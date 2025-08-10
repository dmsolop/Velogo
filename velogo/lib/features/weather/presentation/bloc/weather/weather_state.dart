part of 'weather_cubit.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherData weatherData;
  WeatherLoaded(this.weatherData);
}

class WeatherLoadedForRoute extends WeatherState {
  final List<WeatherData> weatherDataList;
  WeatherLoadedForRoute(this.weatherDataList);
}

class WeatherCacheCleared extends WeatherState {}

class WeatherCacheStats extends WeatherState {
  final Map<String, dynamic> stats;
  WeatherCacheStats(this.stats);
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}
