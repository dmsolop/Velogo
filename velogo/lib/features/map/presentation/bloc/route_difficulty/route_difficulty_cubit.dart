import 'package:flutter_bloc/flutter_bloc.dart';
import 'route_difficulty_state.dart';

class RouteDifficultyCubit extends Cubit<RouteDifficultyState> {
  RouteDifficultyCubit() : super(const RouteDifficultyState());

  void updateDifficulty(RouteDifficulty difficulty) {
    emit(state.copyWith(difficulty: difficulty));
  }

  void setEasy() {
    updateDifficulty(RouteDifficulty.easy);
  }

  void setModerate() {
    updateDifficulty(RouteDifficulty.moderate);
  }

  void setHard() {
    updateDifficulty(RouteDifficulty.hard);
  }

  void setExpert() {
    updateDifficulty(RouteDifficulty.expert);
  }

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void setError(String errorMessage) {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void reset() {
    emit(const RouteDifficultyState());
  }
}
