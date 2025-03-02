import 'package:hive/hive.dart';
import '../../hive/models/route_data.dart';

class RouteRepository {
  final String _boxName = "routes";

  Future<Box<RouteData>> _openBox() async {
    return await Hive.openBox<RouteData>(_boxName);
  }

  Future<void> saveRoute(RouteData route) async {
    final box = await _openBox();
    await box.put(route.id, route);
  }

  Future<List<RouteData>> getAllRoutes() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<RouteData?> getRouteById(String id) async {
    final box = await _openBox();
    return box.get(id);
  }
}
