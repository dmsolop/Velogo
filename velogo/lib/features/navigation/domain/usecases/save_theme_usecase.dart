import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/theme_entity.dart';
import '../repositories/theme_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class SaveThemeUseCase implements UseCase<void, SaveThemeParams> {
  final ThemeRepository repository;

  SaveThemeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveThemeParams params) async {
    return await repository.saveTheme(params.theme);
  }
}

class SaveThemeParams extends Equatable {
  final ThemeEntity theme;

  const SaveThemeParams({
    required this.theme,
  });

  @override
  List<Object> get props => [theme];
}
