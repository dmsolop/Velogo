import 'package:hive/hive.dart';
import '../models/route_difficulty.dart';

class RouteDifficultyRepository {
  final String _boxName = "route_difficulties";

  Future<RouteDifficulty?> getDifficulty(String routeId) async {
    final box = await Hive.openBox<RouteDifficulty>(_boxName);
    return box.get(routeId);
  }

  Future<void> saveDifficulty(RouteDifficulty difficulty) async {
    final box = await Hive.openBox<RouteDifficulty>(_boxName);
    await box.put(difficulty.routeId, difficulty);
  }

  Future<void> deleteDifficulty(String routeId) async {
    final box = await Hive.openBox<RouteDifficulty>(_boxName);
    await box.delete(routeId);
  }
}
