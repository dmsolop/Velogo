import 'package:hive/hive.dart';

part 'route_difficulty.g.dart';

@HiveType(typeId: 2)
class RouteDifficulty extends HiveObject {
  @HiveField(0)
  final String routeId;

  @HiveField(1)
  final double averageWindResistance;

  @HiveField(2)
  final double elevationImpact;

  @HiveField(3)
  final double finalScore; // Загальний рівень складності

  RouteDifficulty({
    required this.routeId,
    required this.averageWindResistance,
    required this.elevationImpact,
    required this.finalScore,
  });
}
