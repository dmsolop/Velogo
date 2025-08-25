import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_difficulty_state.freezed.dart';

enum RouteDifficulty {
  easy,
  moderate,
  hard,
  expert,
}

@freezed
class RouteDifficultyState with _$RouteDifficultyState {
  const factory RouteDifficultyState({
    @Default(RouteDifficulty.moderate) RouteDifficulty difficulty,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _RouteDifficultyState;
}
