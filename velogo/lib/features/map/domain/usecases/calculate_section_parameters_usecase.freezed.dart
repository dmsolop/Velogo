// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calculate_section_parameters_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CalculateSectionParametersParams {
  List<LatLng> get coordinates => throw _privateConstructorUsedError;
  LatLng get startPoint => throw _privateConstructorUsedError;
  LatLng get endPoint => throw _privateConstructorUsedError;
  ProfileEntity get userProfile => throw _privateConstructorUsedError;
  WeatherData? get weatherData => throw _privateConstructorUsedError;
  HealthMetrics? get healthMetrics => throw _privateConstructorUsedError;

  /// Create a copy of CalculateSectionParametersParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalculateSectionParametersParamsCopyWith<CalculateSectionParametersParams>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalculateSectionParametersParamsCopyWith<$Res> {
  factory $CalculateSectionParametersParamsCopyWith(
          CalculateSectionParametersParams value,
          $Res Function(CalculateSectionParametersParams) then) =
      _$CalculateSectionParametersParamsCopyWithImpl<$Res,
          CalculateSectionParametersParams>;
  @useResult
  $Res call(
      {List<LatLng> coordinates,
      LatLng startPoint,
      LatLng endPoint,
      ProfileEntity userProfile,
      WeatherData? weatherData,
      HealthMetrics? healthMetrics});

  $ProfileEntityCopyWith<$Res> get userProfile;
  $HealthMetricsCopyWith<$Res>? get healthMetrics;
}

/// @nodoc
class _$CalculateSectionParametersParamsCopyWithImpl<$Res,
        $Val extends CalculateSectionParametersParams>
    implements $CalculateSectionParametersParamsCopyWith<$Res> {
  _$CalculateSectionParametersParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalculateSectionParametersParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinates = null,
    Object? startPoint = null,
    Object? endPoint = null,
    Object? userProfile = null,
    Object? weatherData = freezed,
    Object? healthMetrics = freezed,
  }) {
    return _then(_value.copyWith(
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      startPoint: null == startPoint
          ? _value.startPoint
          : startPoint // ignore: cast_nullable_to_non_nullable
              as LatLng,
      endPoint: null == endPoint
          ? _value.endPoint
          : endPoint // ignore: cast_nullable_to_non_nullable
              as LatLng,
      userProfile: null == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as ProfileEntity,
      weatherData: freezed == weatherData
          ? _value.weatherData
          : weatherData // ignore: cast_nullable_to_non_nullable
              as WeatherData?,
      healthMetrics: freezed == healthMetrics
          ? _value.healthMetrics
          : healthMetrics // ignore: cast_nullable_to_non_nullable
              as HealthMetrics?,
    ) as $Val);
  }

  /// Create a copy of CalculateSectionParametersParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileEntityCopyWith<$Res> get userProfile {
    return $ProfileEntityCopyWith<$Res>(_value.userProfile, (value) {
      return _then(_value.copyWith(userProfile: value) as $Val);
    });
  }

  /// Create a copy of CalculateSectionParametersParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HealthMetricsCopyWith<$Res>? get healthMetrics {
    if (_value.healthMetrics == null) {
      return null;
    }

    return $HealthMetricsCopyWith<$Res>(_value.healthMetrics!, (value) {
      return _then(_value.copyWith(healthMetrics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CalculateSectionParametersParamsImplCopyWith<$Res>
    implements $CalculateSectionParametersParamsCopyWith<$Res> {
  factory _$$CalculateSectionParametersParamsImplCopyWith(
          _$CalculateSectionParametersParamsImpl value,
          $Res Function(_$CalculateSectionParametersParamsImpl) then) =
      __$$CalculateSectionParametersParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<LatLng> coordinates,
      LatLng startPoint,
      LatLng endPoint,
      ProfileEntity userProfile,
      WeatherData? weatherData,
      HealthMetrics? healthMetrics});

  @override
  $ProfileEntityCopyWith<$Res> get userProfile;
  @override
  $HealthMetricsCopyWith<$Res>? get healthMetrics;
}

/// @nodoc
class __$$CalculateSectionParametersParamsImplCopyWithImpl<$Res>
    extends _$CalculateSectionParametersParamsCopyWithImpl<$Res,
        _$CalculateSectionParametersParamsImpl>
    implements _$$CalculateSectionParametersParamsImplCopyWith<$Res> {
  __$$CalculateSectionParametersParamsImplCopyWithImpl(
      _$CalculateSectionParametersParamsImpl _value,
      $Res Function(_$CalculateSectionParametersParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalculateSectionParametersParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinates = null,
    Object? startPoint = null,
    Object? endPoint = null,
    Object? userProfile = null,
    Object? weatherData = freezed,
    Object? healthMetrics = freezed,
  }) {
    return _then(_$CalculateSectionParametersParamsImpl(
      coordinates: null == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      startPoint: null == startPoint
          ? _value.startPoint
          : startPoint // ignore: cast_nullable_to_non_nullable
              as LatLng,
      endPoint: null == endPoint
          ? _value.endPoint
          : endPoint // ignore: cast_nullable_to_non_nullable
              as LatLng,
      userProfile: null == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as ProfileEntity,
      weatherData: freezed == weatherData
          ? _value.weatherData
          : weatherData // ignore: cast_nullable_to_non_nullable
              as WeatherData?,
      healthMetrics: freezed == healthMetrics
          ? _value.healthMetrics
          : healthMetrics // ignore: cast_nullable_to_non_nullable
              as HealthMetrics?,
    ));
  }
}

/// @nodoc

class _$CalculateSectionParametersParamsImpl
    implements _CalculateSectionParametersParams {
  const _$CalculateSectionParametersParamsImpl(
      {required final List<LatLng> coordinates,
      required this.startPoint,
      required this.endPoint,
      required this.userProfile,
      this.weatherData,
      this.healthMetrics})
      : _coordinates = coordinates;

  final List<LatLng> _coordinates;
  @override
  List<LatLng> get coordinates {
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coordinates);
  }

  @override
  final LatLng startPoint;
  @override
  final LatLng endPoint;
  @override
  final ProfileEntity userProfile;
  @override
  final WeatherData? weatherData;
  @override
  final HealthMetrics? healthMetrics;

  @override
  String toString() {
    return 'CalculateSectionParametersParams(coordinates: $coordinates, startPoint: $startPoint, endPoint: $endPoint, userProfile: $userProfile, weatherData: $weatherData, healthMetrics: $healthMetrics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalculateSectionParametersParamsImpl &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates) &&
            (identical(other.startPoint, startPoint) ||
                other.startPoint == startPoint) &&
            (identical(other.endPoint, endPoint) ||
                other.endPoint == endPoint) &&
            (identical(other.userProfile, userProfile) ||
                other.userProfile == userProfile) &&
            (identical(other.weatherData, weatherData) ||
                other.weatherData == weatherData) &&
            (identical(other.healthMetrics, healthMetrics) ||
                other.healthMetrics == healthMetrics));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_coordinates),
      startPoint,
      endPoint,
      userProfile,
      weatherData,
      healthMetrics);

  /// Create a copy of CalculateSectionParametersParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalculateSectionParametersParamsImplCopyWith<
          _$CalculateSectionParametersParamsImpl>
      get copyWith => __$$CalculateSectionParametersParamsImplCopyWithImpl<
          _$CalculateSectionParametersParamsImpl>(this, _$identity);
}

abstract class _CalculateSectionParametersParams
    implements CalculateSectionParametersParams {
  const factory _CalculateSectionParametersParams(
          {required final List<LatLng> coordinates,
          required final LatLng startPoint,
          required final LatLng endPoint,
          required final ProfileEntity userProfile,
          final WeatherData? weatherData,
          final HealthMetrics? healthMetrics}) =
      _$CalculateSectionParametersParamsImpl;

  @override
  List<LatLng> get coordinates;
  @override
  LatLng get startPoint;
  @override
  LatLng get endPoint;
  @override
  ProfileEntity get userProfile;
  @override
  WeatherData? get weatherData;
  @override
  HealthMetrics? get healthMetrics;

  /// Create a copy of CalculateSectionParametersParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalculateSectionParametersParamsImplCopyWith<
          _$CalculateSectionParametersParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
