import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/marker_entity.dart';
import '../repositories/map_repository.dart';

part 'search_markers_usecase.freezed.dart';

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

@freezed
class SearchMarkersParams with _$SearchMarkersParams {
  const factory SearchMarkersParams({
    required String query,
    MarkerType? type,
    String? categoryId,
    LatLng? center,
    double? radius,
    @Default(MarkerSearchType.byName) MarkerSearchType searchType,
  }) = _SearchMarkersParams;
}
