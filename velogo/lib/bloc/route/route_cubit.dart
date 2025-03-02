import 'package:flutter_bloc/flutter_bloc.dart';
import '../../hive/models/route_data.dart';
import '../../hive/repositories/route_repository.dart';
import 'route_state.dart';

class RouteCubit extends Cubit<RouteState> {
  final RouteRepository _routeRepository;

  RouteCubit(this._routeRepository) : super(RouteState());

  Future<void> fetchRoutes() async {
    emit(RouteState(isLoading: true));

    try {
      final routes = await _routeRepository.getAllRoutes();
      emit(RouteState(routes: routes));
    } catch (e) {
      emit(RouteState(errorMessage: "Failed to fetch routes"));
    }
  }

  Future<void> saveRoute(RouteData route) async {
    await _routeRepository.saveRoute(route);
    fetchRoutes();
  }
}
