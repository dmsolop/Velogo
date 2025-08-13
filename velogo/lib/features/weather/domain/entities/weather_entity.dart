import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_entity.freezed.dart';

@freezed
class WeatherEntity with _$WeatherEntity {
  const factory WeatherEntity({
    required double lat,
    required double lon,
    required double windSpeed,
    required double windDirection,
    required double windGust,
    required double precipitation,
    required double precipitationType,
    required double humidity,
    required double temperature,
    required double visibility,
    required double roadCondition,
    required DateTime timestamp,
    required String source,
  }) = _WeatherEntity;
}
