import 'package:hive/hive.dart';

part 'route_data.g.dart';

@HiveType(typeId: 1)
class RouteData extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<Map<String, double>>
      points; // [{lat: 48.85, lon: 2.35}, {lat: 49.85, lon: 3.35}]

  @HiveField(3)
  final double totalDistance;

  @HiveField(4)
  final double totalElevationGain;

  RouteData({
    required this.id,
    required this.name,
    required this.points,
    required this.totalDistance,
    required this.totalElevationGain,
  });
}
