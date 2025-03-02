import 'package:flutter_bloc/flutter_bloc.dart';
import '../../hive/models/route_difficulty.dart';
import '../../hive/repositories/route_difficulty_repository.dart';
import 'route_difficulty_state.dart';

class RouteDifficultyCubit extends Cubit<RouteDifficultyState> {
  final RouteDifficultyRepository _repository;

  RouteDifficultyCubit(this._repository) : super(RouteDifficultyState());

  Future<void> calculateDifficulty(
      String routeId, double windResistance, double elevationImpact) async {
    emit(RouteDifficultyState(isLoading: true));

    try {
      final difficulty = RouteDifficulty(
        routeId: routeId,
        averageWindResistance: windResistance,
        elevationImpact: elevationImpact,
        finalScore: windResistance * 0.6 + elevationImpact * 0.4,
      );

      await _repository.saveRouteDifficulty(difficulty);
      emit(RouteDifficultyState(difficulty: difficulty));
    } catch (e) {
      emit(
          RouteDifficultyState(errorMessage: "Failed to calculate difficulty"));
    }
  }
}
