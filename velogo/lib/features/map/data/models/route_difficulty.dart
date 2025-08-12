import 'package:hive/hive.dart';

part 'route_difficulty.g.dart';

@HiveType(typeId: 4)
class RouteDifficulty extends HiveObject {
  @HiveField(0)
  final String routeId;

  @HiveField(1)
  final double difficulty;

  @HiveField(2)
  final DateTime calculatedAt;

  RouteDifficulty({
    required this.routeId,
    required this.difficulty,
    required this.calculatedAt,
  });
}
