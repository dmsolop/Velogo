import 'package:flutter_bloc/flutter_bloc.dart';
import 'route_difficulty_state.dart';

class RouteDifficultyCubit extends Cubit<RouteDifficultyState> {
  RouteDifficultyCubit() : super(const RouteDifficultyState());

  void updateDifficulty(double difficulty) {
    emit(state.copyWith(difficulty: difficulty));
  }

  void clearDifficulty() {
    emit(const RouteDifficultyState());
  }
}
