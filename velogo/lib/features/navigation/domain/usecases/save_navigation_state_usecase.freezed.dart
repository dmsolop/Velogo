// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_navigation_state_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SaveNavigationStateParams {
  NavigationEntity get navigationState => throw _privateConstructorUsedError;

  /// Create a copy of SaveNavigationStateParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaveNavigationStateParamsCopyWith<SaveNavigationStateParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaveNavigationStateParamsCopyWith<$Res> {
  factory $SaveNavigationStateParamsCopyWith(SaveNavigationStateParams value,
          $Res Function(SaveNavigationStateParams) then) =
      _$SaveNavigationStateParamsCopyWithImpl<$Res, SaveNavigationStateParams>;
  @useResult
  $Res call({NavigationEntity navigationState});

  $NavigationEntityCopyWith<$Res> get navigationState;
}

/// @nodoc
class _$SaveNavigationStateParamsCopyWithImpl<$Res,
        $Val extends SaveNavigationStateParams>
    implements $SaveNavigationStateParamsCopyWith<$Res> {
  _$SaveNavigationStateParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaveNavigationStateParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navigationState = null,
  }) {
    return _then(_value.copyWith(
      navigationState: null == navigationState
          ? _value.navigationState
          : navigationState // ignore: cast_nullable_to_non_nullable
              as NavigationEntity,
    ) as $Val);
  }

  /// Create a copy of SaveNavigationStateParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavigationEntityCopyWith<$Res> get navigationState {
    return $NavigationEntityCopyWith<$Res>(_value.navigationState, (value) {
      return _then(_value.copyWith(navigationState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SaveNavigationStateParamsImplCopyWith<$Res>
    implements $SaveNavigationStateParamsCopyWith<$Res> {
  factory _$$SaveNavigationStateParamsImplCopyWith(
          _$SaveNavigationStateParamsImpl value,
          $Res Function(_$SaveNavigationStateParamsImpl) then) =
      __$$SaveNavigationStateParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({NavigationEntity navigationState});

  @override
  $NavigationEntityCopyWith<$Res> get navigationState;
}

/// @nodoc
class __$$SaveNavigationStateParamsImplCopyWithImpl<$Res>
    extends _$SaveNavigationStateParamsCopyWithImpl<$Res,
        _$SaveNavigationStateParamsImpl>
    implements _$$SaveNavigationStateParamsImplCopyWith<$Res> {
  __$$SaveNavigationStateParamsImplCopyWithImpl(
      _$SaveNavigationStateParamsImpl _value,
      $Res Function(_$SaveNavigationStateParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of SaveNavigationStateParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navigationState = null,
  }) {
    return _then(_$SaveNavigationStateParamsImpl(
      navigationState: null == navigationState
          ? _value.navigationState
          : navigationState // ignore: cast_nullable_to_non_nullable
              as NavigationEntity,
    ));
  }
}

/// @nodoc

class _$SaveNavigationStateParamsImpl implements _SaveNavigationStateParams {
  const _$SaveNavigationStateParamsImpl({required this.navigationState});

  @override
  final NavigationEntity navigationState;

  @override
  String toString() {
    return 'SaveNavigationStateParams(navigationState: $navigationState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveNavigationStateParamsImpl &&
            (identical(other.navigationState, navigationState) ||
                other.navigationState == navigationState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, navigationState);

  /// Create a copy of SaveNavigationStateParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveNavigationStateParamsImplCopyWith<_$SaveNavigationStateParamsImpl>
      get copyWith => __$$SaveNavigationStateParamsImplCopyWithImpl<
          _$SaveNavigationStateParamsImpl>(this, _$identity);
}

abstract class _SaveNavigationStateParams implements SaveNavigationStateParams {
  const factory _SaveNavigationStateParams(
          {required final NavigationEntity navigationState}) =
      _$SaveNavigationStateParamsImpl;

  @override
  NavigationEntity get navigationState;

  /// Create a copy of SaveNavigationStateParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaveNavigationStateParamsImplCopyWith<_$SaveNavigationStateParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
