// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_route_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CreateRouteParams {
  RouteEntity get route => throw _privateConstructorUsedError;

  /// Create a copy of CreateRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateRouteParamsCopyWith<CreateRouteParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateRouteParamsCopyWith<$Res> {
  factory $CreateRouteParamsCopyWith(
          CreateRouteParams value, $Res Function(CreateRouteParams) then) =
      _$CreateRouteParamsCopyWithImpl<$Res, CreateRouteParams>;
  @useResult
  $Res call({RouteEntity route});

  $RouteEntityCopyWith<$Res> get route;
}

/// @nodoc
class _$CreateRouteParamsCopyWithImpl<$Res, $Val extends CreateRouteParams>
    implements $CreateRouteParamsCopyWith<$Res> {
  _$CreateRouteParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? route = null,
  }) {
    return _then(_value.copyWith(
      route: null == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as RouteEntity,
    ) as $Val);
  }

  /// Create a copy of CreateRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RouteEntityCopyWith<$Res> get route {
    return $RouteEntityCopyWith<$Res>(_value.route, (value) {
      return _then(_value.copyWith(route: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateRouteParamsImplCopyWith<$Res>
    implements $CreateRouteParamsCopyWith<$Res> {
  factory _$$CreateRouteParamsImplCopyWith(_$CreateRouteParamsImpl value,
          $Res Function(_$CreateRouteParamsImpl) then) =
      __$$CreateRouteParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RouteEntity route});

  @override
  $RouteEntityCopyWith<$Res> get route;
}

/// @nodoc
class __$$CreateRouteParamsImplCopyWithImpl<$Res>
    extends _$CreateRouteParamsCopyWithImpl<$Res, _$CreateRouteParamsImpl>
    implements _$$CreateRouteParamsImplCopyWith<$Res> {
  __$$CreateRouteParamsImplCopyWithImpl(_$CreateRouteParamsImpl _value,
      $Res Function(_$CreateRouteParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? route = null,
  }) {
    return _then(_$CreateRouteParamsImpl(
      route: null == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as RouteEntity,
    ));
  }
}

/// @nodoc

class _$CreateRouteParamsImpl implements _CreateRouteParams {
  const _$CreateRouteParamsImpl({required this.route});

  @override
  final RouteEntity route;

  @override
  String toString() {
    return 'CreateRouteParams(route: $route)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateRouteParamsImpl &&
            (identical(other.route, route) || other.route == route));
  }

  @override
  int get hashCode => Object.hash(runtimeType, route);

  /// Create a copy of CreateRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateRouteParamsImplCopyWith<_$CreateRouteParamsImpl> get copyWith =>
      __$$CreateRouteParamsImplCopyWithImpl<_$CreateRouteParamsImpl>(
          this, _$identity);
}

abstract class _CreateRouteParams implements CreateRouteParams {
  const factory _CreateRouteParams({required final RouteEntity route}) =
      _$CreateRouteParamsImpl;

  @override
  RouteEntity get route;

  /// Create a copy of CreateRouteParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateRouteParamsImplCopyWith<_$CreateRouteParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
