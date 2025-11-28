import 'package:freezed_annotation/freezed_annotation.dart';
import '../services/road_routing_service.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.server([String? message]) = ServerFailure;
  const factory Failure.cache([String? message]) = CacheFailure;
  const factory Failure.network([String? message]) = NetworkFailure;
  const factory Failure.auth([String? message]) = AuthFailure;
  const factory Failure.validation([String? message]) = ValidationFailure;
  const factory Failure.permission([String? message]) = PermissionFailure;
  const factory Failure.routeCalculation([
    String? message,
    RouteCalculationError? errorType,
  ]) = RouteCalculationFailure;
}
