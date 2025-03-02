import 'package:hive/hive.dart';
import '../../hive/models/route_difficulty.dart';

class RouteDifficultyRepository {
  final String _boxName = "route_difficulty";

  Future<Box<RouteDifficulty>> _openBox() async {
    return await Hive.openBox<RouteDifficulty>(_boxName);
  }

  Future<void> saveRouteDifficulty(RouteDifficulty difficulty) async {
    final box = await _openBox();
    await box.put(difficulty.routeId, difficulty);
  }

  Future<RouteDifficulty?> getDifficultyByRouteId(String routeId) async {
    final box = await _openBox();
    return box.get(routeId);
  }
}
