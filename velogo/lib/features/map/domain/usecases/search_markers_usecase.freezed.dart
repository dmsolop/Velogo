// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_markers_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchMarkersParams {
  String get query => throw _privateConstructorUsedError;
  MarkerType? get type => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  LatLng? get center => throw _privateConstructorUsedError;
  double? get radius => throw _privateConstructorUsedError;
  MarkerSearchType get searchType => throw _privateConstructorUsedError;

  /// Create a copy of SearchMarkersParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchMarkersParamsCopyWith<SearchMarkersParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchMarkersParamsCopyWith<$Res> {
  factory $SearchMarkersParamsCopyWith(
          SearchMarkersParams value, $Res Function(SearchMarkersParams) then) =
      _$SearchMarkersParamsCopyWithImpl<$Res, SearchMarkersParams>;
  @useResult
  $Res call(
      {String query,
      MarkerType? type,
      String? categoryId,
      LatLng? center,
      double? radius,
      MarkerSearchType searchType});
}

/// @nodoc
class _$SearchMarkersParamsCopyWithImpl<$Res, $Val extends SearchMarkersParams>
    implements $SearchMarkersParamsCopyWith<$Res> {
  _$SearchMarkersParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchMarkersParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? type = freezed,
    Object? categoryId = freezed,
    Object? center = freezed,
    Object? radius = freezed,
    Object? searchType = null,
  }) {
    return _then(_value.copyWith(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MarkerType?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      center: freezed == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      radius: freezed == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double?,
      searchType: null == searchType
          ? _value.searchType
          : searchType // ignore: cast_nullable_to_non_nullable
              as MarkerSearchType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchMarkersParamsImplCopyWith<$Res>
    implements $SearchMarkersParamsCopyWith<$Res> {
  factory _$$SearchMarkersParamsImplCopyWith(_$SearchMarkersParamsImpl value,
          $Res Function(_$SearchMarkersParamsImpl) then) =
      __$$SearchMarkersParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String query,
      MarkerType? type,
      String? categoryId,
      LatLng? center,
      double? radius,
      MarkerSearchType searchType});
}

/// @nodoc
class __$$SearchMarkersParamsImplCopyWithImpl<$Res>
    extends _$SearchMarkersParamsCopyWithImpl<$Res, _$SearchMarkersParamsImpl>
    implements _$$SearchMarkersParamsImplCopyWith<$Res> {
  __$$SearchMarkersParamsImplCopyWithImpl(_$SearchMarkersParamsImpl _value,
      $Res Function(_$SearchMarkersParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchMarkersParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? type = freezed,
    Object? categoryId = freezed,
    Object? center = freezed,
    Object? radius = freezed,
    Object? searchType = null,
  }) {
    return _then(_$SearchMarkersParamsImpl(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MarkerType?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      center: freezed == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      radius: freezed == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double?,
      searchType: null == searchType
          ? _value.searchType
          : searchType // ignore: cast_nullable_to_non_nullable
              as MarkerSearchType,
    ));
  }
}

/// @nodoc

class _$SearchMarkersParamsImpl implements _SearchMarkersParams {
  const _$SearchMarkersParamsImpl(
      {required this.query,
      this.type,
      this.categoryId,
      this.center,
      this.radius,
      this.searchType = MarkerSearchType.byName});

  @override
  final String query;
  @override
  final MarkerType? type;
  @override
  final String? categoryId;
  @override
  final LatLng? center;
  @override
  final double? radius;
  @override
  @JsonKey()
  final MarkerSearchType searchType;

  @override
  String toString() {
    return 'SearchMarkersParams(query: $query, type: $type, categoryId: $categoryId, center: $center, radius: $radius, searchType: $searchType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchMarkersParamsImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.center, center) || other.center == center) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.searchType, searchType) ||
                other.searchType == searchType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, query, type, categoryId, center, radius, searchType);

  /// Create a copy of SearchMarkersParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchMarkersParamsImplCopyWith<_$SearchMarkersParamsImpl> get copyWith =>
      __$$SearchMarkersParamsImplCopyWithImpl<_$SearchMarkersParamsImpl>(
          this, _$identity);
}

abstract class _SearchMarkersParams implements SearchMarkersParams {
  const factory _SearchMarkersParams(
      {required final String query,
      final MarkerType? type,
      final String? categoryId,
      final LatLng? center,
      final double? radius,
      final MarkerSearchType searchType}) = _$SearchMarkersParamsImpl;

  @override
  String get query;
  @override
  MarkerType? get type;
  @override
  String? get categoryId;
  @override
  LatLng? get center;
  @override
  double? get radius;
  @override
  MarkerSearchType get searchType;

  /// Create a copy of SearchMarkersParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchMarkersParamsImplCopyWith<_$SearchMarkersParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
