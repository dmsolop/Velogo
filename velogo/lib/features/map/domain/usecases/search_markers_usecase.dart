import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/marker_entity.dart';
import '../repositories/map_repository.dart';

class SearchMarkersUseCase implements UseCase<MarkerSearchResultEntity, SearchMarkersParams> {
  final MapRepository repository;

  SearchMarkersUseCase(this.repository);

  @override
  Future<Either<Failure, MarkerSearchResultEntity>> call(SearchMarkersParams params) async {
    return await repository.searchMarkers(
      query: params.query,
      type: params.type,
      categoryId: params.categoryId,
      center: params.center,
      radius: params.radius,
      searchType: params.searchType,
    );
  }
}

class SearchMarkersParams extends Equatable {
  final String query;
  final MarkerType? type;
  final String? categoryId;
  final LatLng? center;
  final double? radius;
  final MarkerSearchType searchType;

  const SearchMarkersParams({
    required this.query,
    this.type,
    this.categoryId,
    this.center,
    this.radius,
    this.searchType = MarkerSearchType.byName,
  });

  @override
  List<Object?> get props => [query, type, categoryId, center, radius, searchType];
}
