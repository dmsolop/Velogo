// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calculate_wind_effect_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CalculateWindEffectParams {
  LatLng get startPoint => throw _privateConstructorUsedError;
  LatLng get endPoint => throw _privateConstructorUsedError;

  /// Create a copy of CalculateWindEffectParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalculateWindEffectParamsCopyWith<CalculateWindEffectParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalculateWindEffectParamsCopyWith<$Res> {
  factory $CalculateWindEffectParamsCopyWith(CalculateWindEffectParams value,
          $Res Function(CalculateWindEffectParams) then) =
      _$CalculateWindEffectParamsCopyWithImpl<$Res, CalculateWindEffectParams>;
  @useResult
  $Res call({LatLng startPoint, LatLng endPoint});
}

/// @nodoc
class _$CalculateWindEffectParamsCopyWithImpl<$Res,
        $Val extends CalculateWindEffectParams>
    implements $CalculateWindEffectParamsCopyWith<$Res> {
  _$CalculateWindEffectParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalculateWindEffectParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startPoint = null,
    Object? endPoint = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalculateWindEffectParamsImplCopyWith<$Res>
    implements $CalculateWindEffectParamsCopyWith<$Res> {
  factory _$$CalculateWindEffectParamsImplCopyWith(
          _$CalculateWindEffectParamsImpl value,
          $Res Function(_$CalculateWindEffectParamsImpl) then) =
      __$$CalculateWindEffectParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LatLng startPoint, LatLng endPoint});
}

/// @nodoc
class __$$CalculateWindEffectParamsImplCopyWithImpl<$Res>
    extends _$CalculateWindEffectParamsCopyWithImpl<$Res,
        _$CalculateWindEffectParamsImpl>
    implements _$$CalculateWindEffectParamsImplCopyWith<$Res> {
  __$$CalculateWindEffectParamsImplCopyWithImpl(
      _$CalculateWindEffectParamsImpl _value,
      $Res Function(_$CalculateWindEffectParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalculateWindEffectParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startPoint = null,
    Object? endPoint = null,
  }) {
    return _then(_$CalculateWindEffectParamsImpl(
      startPoint: null == startPoint
          ? _value.startPoint
          : startPoint // ignore: cast_nullable_to_non_nullable
              as LatLng,
      endPoint: null == endPoint
          ? _value.endPoint
          : endPoint // ignore: cast_nullable_to_non_nullable
              as LatLng,
    ));
  }
}

/// @nodoc

class _$CalculateWindEffectParamsImpl implements _CalculateWindEffectParams {
  const _$CalculateWindEffectParamsImpl(
      {required this.startPoint, required this.endPoint});

  @override
  final LatLng startPoint;
  @override
  final LatLng endPoint;

  @override
  String toString() {
    return 'CalculateWindEffectParams(startPoint: $startPoint, endPoint: $endPoint)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalculateWindEffectParamsImpl &&
            (identical(other.startPoint, startPoint) ||
                other.startPoint == startPoint) &&
            (identical(other.endPoint, endPoint) ||
                other.endPoint == endPoint));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startPoint, endPoint);

  /// Create a copy of CalculateWindEffectParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalculateWindEffectParamsImplCopyWith<_$CalculateWindEffectParamsImpl>
      get copyWith => __$$CalculateWindEffectParamsImplCopyWithImpl<
          _$CalculateWindEffectParamsImpl>(this, _$identity);
}

abstract class _CalculateWindEffectParams implements CalculateWindEffectParams {
  const factory _CalculateWindEffectParams(
      {required final LatLng startPoint,
      required final LatLng endPoint}) = _$CalculateWindEffectParamsImpl;

  @override
  LatLng get startPoint;
  @override
  LatLng get endPoint;

  /// Create a copy of CalculateWindEffectParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalculateWindEffectParamsImplCopyWith<_$CalculateWindEffectParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
