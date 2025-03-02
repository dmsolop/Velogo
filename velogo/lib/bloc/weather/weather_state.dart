part of 'weather_cubit.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherData weatherData;
  WeatherLoaded(this.weatherData);
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}
