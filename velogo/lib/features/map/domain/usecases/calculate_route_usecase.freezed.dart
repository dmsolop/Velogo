// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calculate_route_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CalculateRouteParams {
  LatLng get startPoint => throw _privateConstructorUsedError;
  LatLng get endPoint => throw _privateConstructorUsedError;
  String get profile => throw _privateConstructorUsedError;

  /// Create a copy of CalculateRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalculateRouteParamsCopyWith<CalculateRouteParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalculateRouteParamsCopyWith<$Res> {
  factory $CalculateRouteParamsCopyWith(CalculateRouteParams value,
          $Res Function(CalculateRouteParams) then) =
      _$CalculateRouteParamsCopyWithImpl<$Res, CalculateRouteParams>;
  @useResult
  $Res call({LatLng startPoint, LatLng endPoint, String profile});
}

/// @nodoc
class _$CalculateRouteParamsCopyWithImpl<$Res,
        $Val extends CalculateRouteParams>
    implements $CalculateRouteParamsCopyWith<$Res> {
  _$CalculateRouteParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalculateRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startPoint = null,
    Object? endPoint = null,
    Object? profile = null,
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
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalculateRouteParamsImplCopyWith<$Res>
    implements $CalculateRouteParamsCopyWith<$Res> {
  factory _$$CalculateRouteParamsImplCopyWith(_$CalculateRouteParamsImpl value,
          $Res Function(_$CalculateRouteParamsImpl) then) =
      __$$CalculateRouteParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LatLng startPoint, LatLng endPoint, String profile});
}

/// @nodoc
class __$$CalculateRouteParamsImplCopyWithImpl<$Res>
    extends _$CalculateRouteParamsCopyWithImpl<$Res, _$CalculateRouteParamsImpl>
    implements _$$CalculateRouteParamsImplCopyWith<$Res> {
  __$$CalculateRouteParamsImplCopyWithImpl(_$CalculateRouteParamsImpl _value,
      $Res Function(_$CalculateRouteParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalculateRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startPoint = null,
    Object? endPoint = null,
    Object? profile = null,
  }) {
    return _then(_$CalculateRouteParamsImpl(
      startPoint: null == startPoint
          ? _value.startPoint
          : startPoint // ignore: cast_nullable_to_non_nullable
              as LatLng,
      endPoint: null == endPoint
          ? _value.endPoint
          : endPoint // ignore: cast_nullable_to_non_nullable
              as LatLng,
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CalculateRouteParamsImpl implements _CalculateRouteParams {
  const _$CalculateRouteParamsImpl(
      {required this.startPoint,
      required this.endPoint,
      this.profile = 'cycling-regular'});

  @override
  final LatLng startPoint;
  @override
  final LatLng endPoint;
  @override
  @JsonKey()
  final String profile;

  @override
  String toString() {
    return 'CalculateRouteParams(startPoint: $startPoint, endPoint: $endPoint, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalculateRouteParamsImpl &&
            (identical(other.startPoint, startPoint) ||
                other.startPoint == startPoint) &&
            (identical(other.endPoint, endPoint) ||
                other.endPoint == endPoint) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startPoint, endPoint, profile);

  /// Create a copy of CalculateRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalculateRouteParamsImplCopyWith<_$CalculateRouteParamsImpl>
      get copyWith =>
          __$$CalculateRouteParamsImplCopyWithImpl<_$CalculateRouteParamsImpl>(
              this, _$identity);
}

abstract class _CalculateRouteParams implements CalculateRouteParams {
  const factory _CalculateRouteParams(
      {required final LatLng startPoint,
      required final LatLng endPoint,
      final String profile}) = _$CalculateRouteParamsImpl;

  @override
  LatLng get startPoint;
  @override
  LatLng get endPoint;
  @override
  String get profile;

  /// Create a copy of CalculateRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalculateRouteParamsImplCopyWith<_$CalculateRouteParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
