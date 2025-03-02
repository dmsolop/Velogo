import 'package:flutter_bloc/flutter_bloc.dart';
import '../../hive/repositories/weather_repository.dart';
import '../../hive/models/weather_data.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _repository;

  WeatherCubit(this._repository) : super(WeatherInitial());

  Future<void> loadWeather(double lat, double lon) async {
    emit(WeatherLoading());

    try {
      final weatherData = await _repository.getWeather(lat, lon);
      emit(WeatherLoaded(weatherData));
    } catch (e) {
      emit(WeatherError("Failed to fetch weather data: ${e.toString()}"));
    }
  }
}
