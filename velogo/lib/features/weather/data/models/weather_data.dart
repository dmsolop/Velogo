import 'package:hive/hive.dart';
import '../../domain/entities/weather_entity.dart';

part 'weather_data.g.dart';

@HiveType(typeId: 0)
class WeatherData extends HiveObject {
  // Координати
  @HiveField(0)
  final double lat;

  @HiveField(1)
  final double lon;

  // Вітер
  @HiveField(2)
  final double windSpeed;

  @HiveField(3)
  final double windDirection;

  @HiveField(4)
  final double windGust;

  // Опади
  @HiveField(5)
  final double precipitation; // Кількість опадів (мм/год)

  @HiveField(6)
  final double precipitationType; // Тип опадів (0=сухо, 1=дощ, 2=сніг)

  @HiveField(7)
  final double humidity; // Вологість повітря (%)

  // Додаткові параметри
  @HiveField(8)
  final double temperature; // Температура (°C)

  @HiveField(9)
  final double visibility; // Видимість (км)

  @HiveField(10)
  final double roadCondition; // Стан дороги (0=сухо, 1=мокро, 2=багно)

  // Метадані
  @HiveField(11)
  final DateTime timestamp;

  @HiveField(12)
  final String source; // API, AI або локальний прогноз

  WeatherData({
    required this.lat,
    required this.lon,
    required this.windSpeed,
    required this.windDirection,
    required this.windGust,
    required this.precipitation,
    required this.precipitationType,
    required this.humidity,
    required this.temperature,
    required this.visibility,
    required this.roadCondition,
    required this.timestamp,
    required this.source,
  });

  /// Створення WeatherData з базовими параметрами (для зворотної сумісності)
  WeatherData.basic({
    required this.lat,
    required this.lon,
    required this.windSpeed,
    required this.windDirection,
    required this.windGust,
    required this.timestamp,
    required this.source,
  })  : precipitation = 0.0,
        precipitationType = 0.0,
        humidity = 50.0,
        temperature = 20.0,
        visibility = 10.0,
        roadCondition = 0.0;

  /// Копіювання з новими значеннями
  WeatherData copyWith({
    double? lat,
    double? lon,
    double? windSpeed,
    double? windDirection,
    double? windGust,
    double? precipitation,
    double? precipitationType,
    double? humidity,
    double? temperature,
    double? visibility,
    double? roadCondition,
    DateTime? timestamp,
    String? source,
  }) {
    return WeatherData(
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      windGust: windGust ?? this.windGust,
      precipitation: precipitation ?? this.precipitation,
      precipitationType: precipitationType ?? this.precipitationType,
      humidity: humidity ?? this.humidity,
      temperature: temperature ?? this.temperature,
      visibility: visibility ?? this.visibility,
      roadCondition: roadCondition ?? this.roadCondition,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
    );
  }

  @override
  String toString() {
    return 'WeatherData(lat: $lat, lon: $lon, windSpeed: ${windSpeed}m/s, windDirection: ${windDirection}°, precipitation: ${precipitation}mm/h, humidity: ${humidity}%, temperature: ${temperature}°C)';
  }
}

extension WeatherDataExtension on WeatherData {
  WeatherEntity toEntity() {
    return WeatherEntity(
      lat: lat,
      lon: lon,
      windSpeed: windSpeed,
      windDirection: windDirection,
      windGust: windGust,
      precipitation: precipitation,
      precipitationType: precipitationType,
      humidity: humidity,
      temperature: temperature,
      visibility: visibility,
      roadCondition: roadCondition,
      timestamp: timestamp,
      source: source,
    );
  }
}
