import 'package:dartz/dartz.dart';
import '../entities/theme_entity.dart';
import '../repositories/theme_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetThemeUseCase implements UseCase<ThemeEntity, NoParams> {
  final ThemeRepository repository;

  GetThemeUseCase(this.repository);

  @override
  Future<Either<Failure, ThemeEntity>> call(NoParams params) async {
    return await repository.getCurrentTheme();
  }
}
