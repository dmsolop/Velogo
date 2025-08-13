// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ThemeEntity {
  AppThemeMode get themeMode => throw _privateConstructorUsedError;
  DateTime get lastThemeChange => throw _privateConstructorUsedError;
  bool get isSystemTheme => throw _privateConstructorUsedError;

  /// Create a copy of ThemeEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ThemeEntityCopyWith<ThemeEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeEntityCopyWith<$Res> {
  factory $ThemeEntityCopyWith(
          ThemeEntity value, $Res Function(ThemeEntity) then) =
      _$ThemeEntityCopyWithImpl<$Res, ThemeEntity>;
  @useResult
  $Res call(
      {AppThemeMode themeMode, DateTime lastThemeChange, bool isSystemTheme});
}

/// @nodoc
class _$ThemeEntityCopyWithImpl<$Res, $Val extends ThemeEntity>
    implements $ThemeEntityCopyWith<$Res> {
  _$ThemeEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ThemeEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? lastThemeChange = null,
    Object? isSystemTheme = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as AppThemeMode,
      lastThemeChange: null == lastThemeChange
          ? _value.lastThemeChange
          : lastThemeChange // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSystemTheme: null == isSystemTheme
          ? _value.isSystemTheme
          : isSystemTheme // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThemeEntityImplCopyWith<$Res>
    implements $ThemeEntityCopyWith<$Res> {
  factory _$$ThemeEntityImplCopyWith(
          _$ThemeEntityImpl value, $Res Function(_$ThemeEntityImpl) then) =
      __$$ThemeEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AppThemeMode themeMode, DateTime lastThemeChange, bool isSystemTheme});
}

/// @nodoc
class __$$ThemeEntityImplCopyWithImpl<$Res>
    extends _$ThemeEntityCopyWithImpl<$Res, _$ThemeEntityImpl>
    implements _$$ThemeEntityImplCopyWith<$Res> {
  __$$ThemeEntityImplCopyWithImpl(
      _$ThemeEntityImpl _value, $Res Function(_$ThemeEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ThemeEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? lastThemeChange = null,
    Object? isSystemTheme = null,
  }) {
    return _then(_$ThemeEntityImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as AppThemeMode,
      lastThemeChange: null == lastThemeChange
          ? _value.lastThemeChange
          : lastThemeChange // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSystemTheme: null == isSystemTheme
          ? _value.isSystemTheme
          : isSystemTheme // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ThemeEntityImpl implements _ThemeEntity {
  const _$ThemeEntityImpl(
      {required this.themeMode,
      required this.lastThemeChange,
      required this.isSystemTheme});

  @override
  final AppThemeMode themeMode;
  @override
  final DateTime lastThemeChange;
  @override
  final bool isSystemTheme;

  @override
  String toString() {
    return 'ThemeEntity(themeMode: $themeMode, lastThemeChange: $lastThemeChange, isSystemTheme: $isSystemTheme)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeEntityImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.lastThemeChange, lastThemeChange) ||
                other.lastThemeChange == lastThemeChange) &&
            (identical(other.isSystemTheme, isSystemTheme) ||
                other.isSystemTheme == isSystemTheme));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, themeMode, lastThemeChange, isSystemTheme);

  /// Create a copy of ThemeEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeEntityImplCopyWith<_$ThemeEntityImpl> get copyWith =>
      __$$ThemeEntityImplCopyWithImpl<_$ThemeEntityImpl>(this, _$identity);
}

abstract class _ThemeEntity implements ThemeEntity {
  const factory _ThemeEntity(
      {required final AppThemeMode themeMode,
      required final DateTime lastThemeChange,
      required final bool isSystemTheme}) = _$ThemeEntityImpl;

  @override
  AppThemeMode get themeMode;
  @override
  DateTime get lastThemeChange;
  @override
  bool get isSystemTheme;

  /// Create a copy of ThemeEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ThemeEntityImplCopyWith<_$ThemeEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
