import '../../hive/models/route_data.dart';

class RouteState {
  final List<RouteData> routes;
  final bool isLoading;
  final String? errorMessage;

  RouteState(
      {this.routes = const [], this.isLoading = false, this.errorMessage});
}
