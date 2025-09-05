import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_weather_data_usecase.dart';
import '../../../domain/usecases/get_weather_forecast_usecase.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/services/log_service.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetWeatherDataUseCase _getWeatherDataUseCase;
  final GetWeatherForecastUseCase _getWeatherForecastUseCase;

  WeatherCubit({
    required GetWeatherDataUseCase getWeatherDataUseCase,
    required GetWeatherForecastUseCase getWeatherForecastUseCase,
  })  : _getWeatherDataUseCase = getWeatherDataUseCase,
        _getWeatherForecastUseCase = getWeatherForecastUseCase,
        super(const WeatherState.initial());

  /// Завантажуємо погоду для однієї точки
  Future<void> loadWeather(double lat, double lon) async {
    await LogService.log('🌤️ [WeatherCubit] Завантаження погоди: lat=$lat, lon=$lon');
    emit(const WeatherState.loading());

    final result = await _getWeatherDataUseCase(GetWeatherDataParams(lat: lat, lon: lon));

    result.fold(
      (failure) {
        LogService.log('❌ [WeatherCubit] Помилка завантаження погоди: ${failure.message}');
        emit(WeatherState.error(_mapFailureToMessage(failure)));
      },
      (weatherEntity) {
        LogService.log('✅ [WeatherCubit] Погоду завантажено успішно: windSpeed=${weatherEntity.windSpeed}, windDirection=${weatherEntity.windDirection}');
        emit(WeatherState.loaded(weatherEntity));
      },
    );
  }

  /// Завантажуємо погоду для кількох точок маршруту
  Future<void> loadWeatherForRoute(List<Map<String, double>> routePoints) async {
    await LogService.log('🗺️ [WeatherCubit] Завантаження погоди для маршруту: ${routePoints.length} точок');
    emit(const WeatherState.loading());

    final result = await _getWeatherForecastUseCase(GetWeatherForecastParams(routePoints: routePoints));

    result.fold(
      (failure) {
        LogService.log('❌ [WeatherCubit] Помилка завантаження погоди для маршруту: ${failure.message}');
        emit(WeatherState.error(_mapFailureToMessage(failure)));
      },
      (weatherEntities) {
        LogService.log('✅ [WeatherCubit] Погоду для маршруту завантажено успішно: ${weatherEntities.length} точок');
        emit(WeatherState.loadedForRoute(weatherEntities));
      },
    );
  }

  /// Скидаємо стан до початкового
  void reset() {
    LogService.log('🔄 [WeatherCubit] Скидання стану до початкового');
    emit(const WeatherState.initial());
  }

  /// Мапінг failure до повідомлення
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error. Please try again later.';
    } else if (failure is NetworkFailure) {
      return 'Network error. Please check your connection.';
    } else if (failure is CacheFailure) {
      return 'Cache error. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
