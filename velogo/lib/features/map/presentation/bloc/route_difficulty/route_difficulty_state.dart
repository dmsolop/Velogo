import 'package:equatable/equatable.dart';

class RouteDifficultyState extends Equatable {
  final double difficulty;

  const RouteDifficultyState({this.difficulty = 0.0});

  RouteDifficultyState copyWith({double? difficulty}) {
    return RouteDifficultyState(
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  List<Object> get props => [difficulty];
}
