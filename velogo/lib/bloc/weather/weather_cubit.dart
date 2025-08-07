import 'package:flutter_bloc/flutter_bloc.dart';
import '../../hive/repositories/weather_repository.dart';
import '../../hive/models/weather_data.dart';
import '../../services/log_service.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _repository;

  WeatherCubit(this._repository) : super(WeatherInitial());

  /// Завантажуємо погоду для однієї точки
  Future<void> loadWeather(double lat, double lon) async {
    await LogService.log('🌤️ [WeatherCubit] Завантаження погоди: lat=$lat, lon=$lon');
    emit(WeatherLoading());

    try {
      final weatherData = await _repository.getWeather(lat, lon);
      await LogService.log('✅ [WeatherCubit] Погоду завантажено успішно: windSpeed=${weatherData.windSpeed}, windDirection=${weatherData.windDirection}');
      emit(WeatherLoaded(weatherData));
    } catch (e) {
      await LogService.log('❌ [WeatherCubit] Помилка завантаження погоди: $e');
      emit(WeatherError("Failed to fetch weather data: ${e.toString()}"));
    }
  }

  /// Завантажуємо погоду для кількох точок маршруту
  Future<void> loadWeatherForRoute(List<Map<String, double>> routePoints) async {
    await LogService.log('🗺️ [WeatherCubit] Завантаження погоди для маршруту: ${routePoints.length} точок');
    emit(WeatherLoading());

    try {
      final weatherDataList = await _repository.getWeatherForRoute(routePoints);
      await LogService.log('✅ [WeatherCubit] Погоду для маршруту завантажено успішно: ${weatherDataList.length} точок');
      emit(WeatherLoadedForRoute(weatherDataList));
    } catch (e) {
      await LogService.log('❌ [WeatherCubit] Помилка завантаження погоди для маршруту: $e');
      emit(WeatherError("Failed to fetch weather data for route: ${e.toString()}"));
    }
  }

  /// Очищуємо кеш
  Future<void> clearCache() async {
    await LogService.log('🧹 [WeatherCubit] Очищення кешу погоди');
    try {
      await _repository.clearOldData();
      await LogService.log('✅ [WeatherCubit] Кеш очищено успішно');
      emit(WeatherCacheCleared());
    } catch (e) {
      await LogService.log('❌ [WeatherCubit] Помилка очищення кешу: $e');
      emit(WeatherError("Failed to clear cache: ${e.toString()}"));
    }
  }

  /// Отримуємо статистику кешу
  Future<void> getCacheStats() async {
    await LogService.log('📊 [WeatherCubit] Отримання статистики кешу');
    try {
      final stats = await _repository.getCacheStats();
      await LogService.log('✅ [WeatherCubit] Статистику кешу отримано: $stats');
      emit(WeatherCacheStats(stats));
    } catch (e) {
      await LogService.log('❌ [WeatherCubit] Помилка отримання статистики кешу: $e');
      emit(WeatherError("Failed to get cache stats: ${e.toString()}"));
    }
  }

  /// Скидаємо стан до початкового
  void reset() {
    LogService.log('🔄 [WeatherCubit] Скидання стану до початкового');
    emit(WeatherInitial());
  }
}
