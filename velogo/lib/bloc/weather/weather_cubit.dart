import 'package:flutter_bloc/flutter_bloc.dart';
import '../../hive/repositories/weather_repository.dart';
import '../../hive/models/weather_data.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _repository;

  WeatherCubit(this._repository) : super(WeatherInitial());

  /// Завантажуємо погоду для однієї точки
  Future<void> loadWeather(double lat, double lon) async {
    emit(WeatherLoading());

    try {
      final weatherData = await _repository.getWeather(lat, lon);
      emit(WeatherLoaded(weatherData));
    } catch (e) {
      emit(WeatherError("Failed to fetch weather data: ${e.toString()}"));
    }
  }

  /// Завантажуємо погоду для кількох точок маршруту
  Future<void> loadWeatherForRoute(List<Map<String, double>> routePoints) async {
    emit(WeatherLoading());

    try {
      final weatherDataList = await _repository.getWeatherForRoute(routePoints);
      emit(WeatherLoadedForRoute(weatherDataList));
    } catch (e) {
      emit(WeatherError("Failed to fetch weather data for route: ${e.toString()}"));
    }
  }

  /// Очищуємо кеш
  Future<void> clearCache() async {
    try {
      await _repository.clearOldData();
      emit(WeatherCacheCleared());
    } catch (e) {
      emit(WeatherError("Failed to clear cache: ${e.toString()}"));
    }
  }

  /// Отримуємо статистику кешу
  Future<void> getCacheStats() async {
    try {
      final stats = await _repository.getCacheStats();
      emit(WeatherCacheStats(stats));
    } catch (e) {
      emit(WeatherError("Failed to get cache stats: ${e.toString()}"));
    }
  }

  /// Скидаємо стан до початкового
  void reset() {
    emit(WeatherInitial());
  }
}
