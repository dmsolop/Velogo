// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_automatic_route_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CreateAutomaticRouteParams {
  LatLng get startPoint => throw _privateConstructorUsedError;
  LatLng get endPoint => throw _privateConstructorUsedError;
  RouteDifficulty get difficulty => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;

  /// Create a copy of CreateAutomaticRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateAutomaticRouteParamsCopyWith<CreateAutomaticRouteParams>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateAutomaticRouteParamsCopyWith<$Res> {
  factory $CreateAutomaticRouteParamsCopyWith(CreateAutomaticRouteParams value,
          $Res Function(CreateAutomaticRouteParams) then) =
      _$CreateAutomaticRouteParamsCopyWithImpl<$Res,
          CreateAutomaticRouteParams>;
  @useResult
  $Res call(
      {LatLng startPoint,
      LatLng endPoint,
      RouteDifficulty difficulty,
      double distance,
      String? userId});
}

/// @nodoc
class _$CreateAutomaticRouteParamsCopyWithImpl<$Res,
        $Val extends CreateAutomaticRouteParams>
    implements $CreateAutomaticRouteParamsCopyWith<$Res> {
  _$CreateAutomaticRouteParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateAutomaticRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startPoint = null,
    Object? endPoint = null,
    Object? difficulty = null,
    Object? distance = null,
    Object? userId = freezed,
  }) {
    return _then(_value.copyWith(
      startPoint: null == startPoint
          ? _value.startPoint
          : startPoint // ignore: cast_nullable_to_non_nullable
              as LatLng,
      endPoint: null == endPoint
          ? _value.endPoint
          : endPoint // ignore: cast_nullable_to_non_nullable
              as LatLng,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as RouteDifficulty,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateAutomaticRouteParamsImplCopyWith<$Res>
    implements $CreateAutomaticRouteParamsCopyWith<$Res> {
  factory _$$CreateAutomaticRouteParamsImplCopyWith(
          _$CreateAutomaticRouteParamsImpl value,
          $Res Function(_$CreateAutomaticRouteParamsImpl) then) =
      __$$CreateAutomaticRouteParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LatLng startPoint,
      LatLng endPoint,
      RouteDifficulty difficulty,
      double distance,
      String? userId});
}

/// @nodoc
class __$$CreateAutomaticRouteParamsImplCopyWithImpl<$Res>
    extends _$CreateAutomaticRouteParamsCopyWithImpl<$Res,
        _$CreateAutomaticRouteParamsImpl>
    implements _$$CreateAutomaticRouteParamsImplCopyWith<$Res> {
  __$$CreateAutomaticRouteParamsImplCopyWithImpl(
      _$CreateAutomaticRouteParamsImpl _value,
      $Res Function(_$CreateAutomaticRouteParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateAutomaticRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startPoint = null,
    Object? endPoint = null,
    Object? difficulty = null,
    Object? distance = null,
    Object? userId = freezed,
  }) {
    return _then(_$CreateAutomaticRouteParamsImpl(
      startPoint: null == startPoint
          ? _value.startPoint
          : startPoint // ignore: cast_nullable_to_non_nullable
              as LatLng,
      endPoint: null == endPoint
          ? _value.endPoint
          : endPoint // ignore: cast_nullable_to_non_nullable
              as LatLng,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as RouteDifficulty,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CreateAutomaticRouteParamsImpl implements _CreateAutomaticRouteParams {
  const _$CreateAutomaticRouteParamsImpl(
      {required this.startPoint,
      required this.endPoint,
      required this.difficulty,
      required this.distance,
      this.userId});

  @override
  final LatLng startPoint;
  @override
  final LatLng endPoint;
  @override
  final RouteDifficulty difficulty;
  @override
  final double distance;
  @override
  final String? userId;

  @override
  String toString() {
    return 'CreateAutomaticRouteParams(startPoint: $startPoint, endPoint: $endPoint, difficulty: $difficulty, distance: $distance, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateAutomaticRouteParamsImpl &&
            (identical(other.startPoint, startPoint) ||
                other.startPoint == startPoint) &&
            (identical(other.endPoint, endPoint) ||
                other.endPoint == endPoint) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, startPoint, endPoint, difficulty, distance, userId);

  /// Create a copy of CreateAutomaticRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateAutomaticRouteParamsImplCopyWith<_$CreateAutomaticRouteParamsImpl>
      get copyWith => __$$CreateAutomaticRouteParamsImplCopyWithImpl<
          _$CreateAutomaticRouteParamsImpl>(this, _$identity);
}

abstract class _CreateAutomaticRouteParams
    implements CreateAutomaticRouteParams {
  const factory _CreateAutomaticRouteParams(
      {required final LatLng startPoint,
      required final LatLng endPoint,
      required final RouteDifficulty difficulty,
      required final double distance,
      final String? userId}) = _$CreateAutomaticRouteParamsImpl;

  @override
  LatLng get startPoint;
  @override
  LatLng get endPoint;
  @override
  RouteDifficulty get difficulty;
  @override
  double get distance;
  @override
  String? get userId;

  /// Create a copy of CreateAutomaticRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateAutomaticRouteParamsImplCopyWith<_$CreateAutomaticRouteParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
