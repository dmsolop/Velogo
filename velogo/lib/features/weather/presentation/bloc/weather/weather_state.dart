import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/weather_entity.dart';

part 'weather_state.freezed.dart';

@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState.initial() = WeatherInitial;
  const factory WeatherState.loading() = WeatherLoading;
  const factory WeatherState.loaded(WeatherEntity weatherEntity) = WeatherLoaded;
  const factory WeatherState.loadedForRoute(List<WeatherEntity> weatherEntities) = WeatherLoadedForRoute;
  const factory WeatherState.error(String message) = WeatherError;
}
