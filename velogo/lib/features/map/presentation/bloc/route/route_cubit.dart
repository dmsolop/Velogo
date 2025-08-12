import 'package:flutter_bloc/flutter_bloc.dart';
import 'route_state.dart';

class RouteCubit extends Cubit<RouteState> {
  RouteCubit() : super(const RouteState());

  void updateRoute(List<Map<String, double>> routePoints) {
    emit(state.copyWith(routePoints: routePoints));
  }

  void clearRoute() {
    emit(const RouteState());
  }
}
