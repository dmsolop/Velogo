// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_weather_forecast_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GetWeatherForecastParams {
  List<Map<String, double>> get routePoints =>
      throw _privateConstructorUsedError;

  /// Create a copy of GetWeatherForecastParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetWeatherForecastParamsCopyWith<GetWeatherForecastParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetWeatherForecastParamsCopyWith<$Res> {
  factory $GetWeatherForecastParamsCopyWith(GetWeatherForecastParams value,
          $Res Function(GetWeatherForecastParams) then) =
      _$GetWeatherForecastParamsCopyWithImpl<$Res, GetWeatherForecastParams>;
  @useResult
  $Res call({List<Map<String, double>> routePoints});
}

/// @nodoc
class _$GetWeatherForecastParamsCopyWithImpl<$Res,
        $Val extends GetWeatherForecastParams>
    implements $GetWeatherForecastParamsCopyWith<$Res> {
  _$GetWeatherForecastParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetWeatherForecastParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routePoints = null,
  }) {
    return _then(_value.copyWith(
      routePoints: null == routePoints
          ? _value.routePoints
          : routePoints // ignore: cast_nullable_to_non_nullable
              as List<Map<String, double>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetWeatherForecastParamsImplCopyWith<$Res>
    implements $GetWeatherForecastParamsCopyWith<$Res> {
  factory _$$GetWeatherForecastParamsImplCopyWith(
          _$GetWeatherForecastParamsImpl value,
          $Res Function(_$GetWeatherForecastParamsImpl) then) =
      __$$GetWeatherForecastParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Map<String, double>> routePoints});
}

/// @nodoc
class __$$GetWeatherForecastParamsImplCopyWithImpl<$Res>
    extends _$GetWeatherForecastParamsCopyWithImpl<$Res,
        _$GetWeatherForecastParamsImpl>
    implements _$$GetWeatherForecastParamsImplCopyWith<$Res> {
  __$$GetWeatherForecastParamsImplCopyWithImpl(
      _$GetWeatherForecastParamsImpl _value,
      $Res Function(_$GetWeatherForecastParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetWeatherForecastParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routePoints = null,
  }) {
    return _then(_$GetWeatherForecastParamsImpl(
      routePoints: null == routePoints
          ? _value._routePoints
          : routePoints // ignore: cast_nullable_to_non_nullable
              as List<Map<String, double>>,
    ));
  }
}

/// @nodoc

class _$GetWeatherForecastParamsImpl implements _GetWeatherForecastParams {
  const _$GetWeatherForecastParamsImpl(
      {required final List<Map<String, double>> routePoints})
      : _routePoints = routePoints;

  final List<Map<String, double>> _routePoints;
  @override
  List<Map<String, double>> get routePoints {
    if (_routePoints is EqualUnmodifiableListView) return _routePoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routePoints);
  }

  @override
  String toString() {
    return 'GetWeatherForecastParams(routePoints: $routePoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetWeatherForecastParamsImpl &&
            const DeepCollectionEquality()
                .equals(other._routePoints, _routePoints));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_routePoints));

  /// Create a copy of GetWeatherForecastParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetWeatherForecastParamsImplCopyWith<_$GetWeatherForecastParamsImpl>
      get copyWith => __$$GetWeatherForecastParamsImplCopyWithImpl<
          _$GetWeatherForecastParamsImpl>(this, _$identity);
}

abstract class _GetWeatherForecastParams implements GetWeatherForecastParams {
  const factory _GetWeatherForecastParams(
          {required final List<Map<String, double>> routePoints}) =
      _$GetWeatherForecastParamsImpl;

  @override
  List<Map<String, double>> get routePoints;

  /// Create a copy of GetWeatherForecastParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetWeatherForecastParamsImplCopyWith<_$GetWeatherForecastParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
