import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../entities/navigation_entity.dart';
import '../repositories/navigation_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

part 'save_navigation_state_usecase.freezed.dart';

class SaveNavigationStateUseCase implements UseCase<void, SaveNavigationStateParams> {
  final NavigationRepository repository;

  SaveNavigationStateUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveNavigationStateParams params) async {
    return await repository.saveNavigationState(params.navigationState);
  }
}

@freezed
class SaveNavigationStateParams with _$SaveNavigationStateParams {
  const factory SaveNavigationStateParams({
    required NavigationEntity navigationState,
  }) = _SaveNavigationStateParams;
}
