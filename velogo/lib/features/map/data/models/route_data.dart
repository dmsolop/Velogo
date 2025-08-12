import 'package:hive/hive.dart';

part 'route_data.g.dart';

@HiveType(typeId: 3)
class RouteData extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<Map<String, double>> routePoints;

  @HiveField(2)
  final DateTime createdAt;

  RouteData({
    required this.id,
    required this.routePoints,
    required this.createdAt,
  });
}
