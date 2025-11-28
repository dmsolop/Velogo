import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/route_entity.dart';
import '../../../../../core/error/failures.dart';

part 'create_route_state.freezed.dart';

@freezed
class CreateRouteState with _$CreateRouteState {
  const factory CreateRouteState.initial() = _Initial;
  const factory CreateRouteState.loading() = _Loading;
  const factory CreateRouteState.routeCalculated({
    required List<RouteSectionEntity> sections,
  }) = _RouteCalculated;
  const factory CreateRouteState.routeError({
    required Failure failure,
    required String message,
  }) = _RouteError;
  const factory CreateRouteState.complexityCalculated({
    required double difficulty,
    required String difficultyLevel,
    required int difficultyColor,
  }) = _ComplexityCalculated;
  const factory CreateRouteState.complexityError({
    required Failure failure,
  }) = _ComplexityError;
}
