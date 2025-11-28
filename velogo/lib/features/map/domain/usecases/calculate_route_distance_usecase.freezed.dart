// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calculate_route_distance_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CalculateRouteDistanceParams {
  List<LatLng> get coordinates => throw _privateConstructorUsedError;

  /// Create a copy of CalculateRouteDistanceParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalculateRouteDistanceParamsCopyWith<CalculateRouteDistanceParams>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalculateRouteDistanceParamsCopyWith<$Res> {
  factory $CalculateRouteDistanceParamsCopyWith(
          CalculateRouteDistanceParams value,
          $Res Function(CalculateRouteDistanceParams) then) =
      _$CalculateRouteDistanceParamsCopyWithImpl<$Res,
          CalculateRouteDistanceParams>;
  @useResult
  $Res call({List<LatLng> coordinates});
}

/// @nodoc
class _$CalculateRouteDistanceParamsCopyWithImpl<$Res,
        $Val extends CalculateRouteDistanceParams>
    implements $CalculateRouteDistanceParamsCopyWith<$Res> {
  _$CalculateRouteDistanceParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalculateRouteDistanceParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinates = null,
  }) {
    return _then(_value.copyWith(
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalculateRouteDistanceParamsImplCopyWith<$Res>
    implements $CalculateRouteDistanceParamsCopyWith<$Res> {
  factory _$$CalculateRouteDistanceParamsImplCopyWith(
          _$CalculateRouteDistanceParamsImpl value,
          $Res Function(_$CalculateRouteDistanceParamsImpl) then) =
      __$$CalculateRouteDistanceParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<LatLng> coordinates});
}

/// @nodoc
class __$$CalculateRouteDistanceParamsImplCopyWithImpl<$Res>
    extends _$CalculateRouteDistanceParamsCopyWithImpl<$Res,
        _$CalculateRouteDistanceParamsImpl>
    implements _$$CalculateRouteDistanceParamsImplCopyWith<$Res> {
  __$$CalculateRouteDistanceParamsImplCopyWithImpl(
      _$CalculateRouteDistanceParamsImpl _value,
      $Res Function(_$CalculateRouteDistanceParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalculateRouteDistanceParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinates = null,
  }) {
    return _then(_$CalculateRouteDistanceParamsImpl(
      coordinates: null == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
    ));
  }
}

/// @nodoc

class _$CalculateRouteDistanceParamsImpl
    implements _CalculateRouteDistanceParams {
  const _$CalculateRouteDistanceParamsImpl(
      {required final List<LatLng> coordinates})
      : _coordinates = coordinates;

  final List<LatLng> _coordinates;
  @override
  List<LatLng> get coordinates {
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coordinates);
  }

  @override
  String toString() {
    return 'CalculateRouteDistanceParams(coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalculateRouteDistanceParamsImpl &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_coordinates));

  /// Create a copy of CalculateRouteDistanceParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalculateRouteDistanceParamsImplCopyWith<
          _$CalculateRouteDistanceParamsImpl>
      get copyWith => __$$CalculateRouteDistanceParamsImplCopyWithImpl<
          _$CalculateRouteDistanceParamsImpl>(this, _$identity);
}

abstract class _CalculateRouteDistanceParams
    implements CalculateRouteDistanceParams {
  const factory _CalculateRouteDistanceParams(
          {required final List<LatLng> coordinates}) =
      _$CalculateRouteDistanceParamsImpl;

  @override
  List<LatLng> get coordinates;

  /// Create a copy of CalculateRouteDistanceParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalculateRouteDistanceParamsImplCopyWith<
          _$CalculateRouteDistanceParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
