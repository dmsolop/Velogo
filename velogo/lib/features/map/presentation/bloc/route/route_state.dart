import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_state.freezed.dart';

@freezed
class RouteState with _$RouteState {
  const factory RouteState.initial() = _Initial;
  const factory RouteState.loading() = _Loading;
  const factory RouteState.loaded() = _Loaded;
  const factory RouteState.error({
    required String message,
  }) = _Error;
  const factory RouteState.routeCreated() = _RouteCreated;
  const factory RouteState.routeUpdated() = _RouteUpdated;
  const factory RouteState.routeDeleted() = _RouteDeleted;
}
