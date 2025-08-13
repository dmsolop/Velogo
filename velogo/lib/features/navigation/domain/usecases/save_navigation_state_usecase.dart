import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/navigation_entity.dart';
import '../repositories/navigation_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class SaveNavigationStateUseCase implements UseCase<void, SaveNavigationStateParams> {
  final NavigationRepository repository;

  SaveNavigationStateUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveNavigationStateParams params) async {
    return await repository.saveNavigationState(params.navigationState);
  }
}

class SaveNavigationStateParams extends Equatable {
  final NavigationEntity navigationState;

  const SaveNavigationStateParams({
    required this.navigationState,
  });

  @override
  List<Object> get props => [navigationState];
}
