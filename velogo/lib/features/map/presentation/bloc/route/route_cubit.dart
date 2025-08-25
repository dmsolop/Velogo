import 'package:flutter_bloc/flutter_bloc.dart';
import 'route_state.dart';

class RouteCubit extends Cubit<RouteState> {
  RouteCubit() : super(const RouteState.initial());

  void loadAllRoutes() {
    emit(const RouteState.loading());
    // TODO: Implement with use cases
    emit(const RouteState.error(message: 'Not implemented yet'));
  }

  void createRoute() {
    emit(const RouteState.loading());
    // TODO: Implement with use cases
    emit(const RouteState.error(message: 'Not implemented yet'));
  }

  void createAutomaticRoute() {
    emit(const RouteState.loading());
    // TODO: Implement with use cases
    emit(const RouteState.error(message: 'Not implemented yet'));
  }

  void selectRoute() {
    // TODO: Implement
  }

  void clearSelectedRoute() {
    // TODO: Implement
  }

  void clearError() {
    emit(const RouteState.initial());
  }
}
