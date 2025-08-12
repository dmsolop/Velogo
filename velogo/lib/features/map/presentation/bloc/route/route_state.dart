import 'package:equatable/equatable.dart';

class RouteState extends Equatable {
  final List<Map<String, double>> routePoints;

  const RouteState({this.routePoints = const []});

  RouteState copyWith({List<Map<String, double>>? routePoints}) {
    return RouteState(
      routePoints: routePoints ?? this.routePoints,
    );
  }

  @override
  List<Object> get props => [routePoints];
}
