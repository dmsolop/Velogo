part of 'weather_cubit.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherEntity weatherEntity;
  WeatherLoaded(this.weatherEntity);
}

class WeatherLoadedForRoute extends WeatherState {
  final List<WeatherEntity> weatherEntities;
  WeatherLoadedForRoute(this.weatherEntities);
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}
