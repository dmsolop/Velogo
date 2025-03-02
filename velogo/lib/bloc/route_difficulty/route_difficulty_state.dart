import '../../hive/models/route_difficulty.dart';

class RouteDifficultyState {
  final RouteDifficulty? difficulty;
  final bool isLoading;
  final String? errorMessage;

  RouteDifficultyState(
      {this.difficulty, this.isLoading = false, this.errorMessage});
}
