// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_weather_data_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GetWeatherDataParams {
  double get lat => throw _privateConstructorUsedError;
  double get lon => throw _privateConstructorUsedError;

  /// Create a copy of GetWeatherDataParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetWeatherDataParamsCopyWith<GetWeatherDataParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetWeatherDataParamsCopyWith<$Res> {
  factory $GetWeatherDataParamsCopyWith(GetWeatherDataParams value,
          $Res Function(GetWeatherDataParams) then) =
      _$GetWeatherDataParamsCopyWithImpl<$Res, GetWeatherDataParams>;
  @useResult
  $Res call({double lat, double lon});
}

/// @nodoc
class _$GetWeatherDataParamsCopyWithImpl<$Res,
        $Val extends GetWeatherDataParams>
    implements $GetWeatherDataParamsCopyWith<$Res> {
  _$GetWeatherDataParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetWeatherDataParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lon = null,
  }) {
    return _then(_value.copyWith(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: null == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetWeatherDataParamsImplCopyWith<$Res>
    implements $GetWeatherDataParamsCopyWith<$Res> {
  factory _$$GetWeatherDataParamsImplCopyWith(_$GetWeatherDataParamsImpl value,
          $Res Function(_$GetWeatherDataParamsImpl) then) =
      __$$GetWeatherDataParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double lat, double lon});
}

/// @nodoc
class __$$GetWeatherDataParamsImplCopyWithImpl<$Res>
    extends _$GetWeatherDataParamsCopyWithImpl<$Res, _$GetWeatherDataParamsImpl>
    implements _$$GetWeatherDataParamsImplCopyWith<$Res> {
  __$$GetWeatherDataParamsImplCopyWithImpl(_$GetWeatherDataParamsImpl _value,
      $Res Function(_$GetWeatherDataParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetWeatherDataParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lon = null,
  }) {
    return _then(_$GetWeatherDataParamsImpl(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: null == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$GetWeatherDataParamsImpl implements _GetWeatherDataParams {
  const _$GetWeatherDataParamsImpl({required this.lat, required this.lon});

  @override
  final double lat;
  @override
  final double lon;

  @override
  String toString() {
    return 'GetWeatherDataParams(lat: $lat, lon: $lon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetWeatherDataParamsImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lat, lon);

  /// Create a copy of GetWeatherDataParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetWeatherDataParamsImplCopyWith<_$GetWeatherDataParamsImpl>
      get copyWith =>
          __$$GetWeatherDataParamsImplCopyWithImpl<_$GetWeatherDataParamsImpl>(
              this, _$identity);
}

abstract class _GetWeatherDataParams implements GetWeatherDataParams {
  const factory _GetWeatherDataParams(
      {required final double lat,
      required final double lon}) = _$GetWeatherDataParamsImpl;

  @override
  double get lat;
  @override
  double get lon;

  /// Create a copy of GetWeatherDataParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetWeatherDataParamsImplCopyWith<_$GetWeatherDataParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
