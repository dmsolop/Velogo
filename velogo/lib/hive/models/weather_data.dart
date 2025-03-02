import 'package:hive/hive.dart';

part 'weather_data.g.dart';

@HiveType(typeId: 0)
class WeatherData extends HiveObject {
  @HiveField(0)
  final double lat;

  @HiveField(1)
  final double lon;

  @HiveField(2)
  final double windSpeed;

  @HiveField(3)
  final double windDirection;

  @HiveField(4)
  final double windGust;

  @HiveField(5)
  final DateTime timestamp;

  @HiveField(6)
  final String source; // API, AI або локальний прогноз

  WeatherData({
    required this.lat,
    required this.lon,
    required this.windSpeed,
    required this.windDirection,
    required this.windGust,
    required this.timestamp,
    required this.source,
  });
}
