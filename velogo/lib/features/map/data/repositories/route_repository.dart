import 'package:hive/hive.dart';
import '../models/route_data.dart';

class RouteRepository {
  final String _boxName = "routes";

  Future<List<RouteData>> getAllRoutes() async {
    final box = await Hive.openBox<RouteData>(_boxName);
    return box.values.toList();
  }

  Future<void> saveRoute(RouteData route) async {
    final box = await Hive.openBox<RouteData>(_boxName);
    await box.put(route.id, route);
  }

  Future<void> deleteRoute(String id) async {
    final box = await Hive.openBox<RouteData>(_boxName);
    await box.delete(id);
  }
}
