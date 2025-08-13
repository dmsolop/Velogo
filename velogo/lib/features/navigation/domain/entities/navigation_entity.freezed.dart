// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'navigation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NavigationEntity {
  NavigationTab get selectedTab => throw _privateConstructorUsedError;
  DateTime get lastNavigationTime => throw _privateConstructorUsedError;
  String get currentRoute => throw _privateConstructorUsedError;

  /// Create a copy of NavigationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavigationEntityCopyWith<NavigationEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavigationEntityCopyWith<$Res> {
  factory $NavigationEntityCopyWith(
          NavigationEntity value, $Res Function(NavigationEntity) then) =
      _$NavigationEntityCopyWithImpl<$Res, NavigationEntity>;
  @useResult
  $Res call(
      {NavigationTab selectedTab,
      DateTime lastNavigationTime,
      String currentRoute});
}

/// @nodoc
class _$NavigationEntityCopyWithImpl<$Res, $Val extends NavigationEntity>
    implements $NavigationEntityCopyWith<$Res> {
  _$NavigationEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavigationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedTab = null,
    Object? lastNavigationTime = null,
    Object? currentRoute = null,
  }) {
    return _then(_value.copyWith(
      selectedTab: null == selectedTab
          ? _value.selectedTab
          : selectedTab // ignore: cast_nullable_to_non_nullable
              as NavigationTab,
      lastNavigationTime: null == lastNavigationTime
          ? _value.lastNavigationTime
          : lastNavigationTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentRoute: null == currentRoute
          ? _value.currentRoute
          : currentRoute // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavigationEntityImplCopyWith<$Res>
    implements $NavigationEntityCopyWith<$Res> {
  factory _$$NavigationEntityImplCopyWith(_$NavigationEntityImpl value,
          $Res Function(_$NavigationEntityImpl) then) =
      __$$NavigationEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {NavigationTab selectedTab,
      DateTime lastNavigationTime,
      String currentRoute});
}

/// @nodoc
class __$$NavigationEntityImplCopyWithImpl<$Res>
    extends _$NavigationEntityCopyWithImpl<$Res, _$NavigationEntityImpl>
    implements _$$NavigationEntityImplCopyWith<$Res> {
  __$$NavigationEntityImplCopyWithImpl(_$NavigationEntityImpl _value,
      $Res Function(_$NavigationEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavigationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedTab = null,
    Object? lastNavigationTime = null,
    Object? currentRoute = null,
  }) {
    return _then(_$NavigationEntityImpl(
      selectedTab: null == selectedTab
          ? _value.selectedTab
          : selectedTab // ignore: cast_nullable_to_non_nullable
              as NavigationTab,
      lastNavigationTime: null == lastNavigationTime
          ? _value.lastNavigationTime
          : lastNavigationTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentRoute: null == currentRoute
          ? _value.currentRoute
          : currentRoute // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NavigationEntityImpl implements _NavigationEntity {
  const _$NavigationEntityImpl(
      {required this.selectedTab,
      required this.lastNavigationTime,
      required this.currentRoute});

  @override
  final NavigationTab selectedTab;
  @override
  final DateTime lastNavigationTime;
  @override
  final String currentRoute;

  @override
  String toString() {
    return 'NavigationEntity(selectedTab: $selectedTab, lastNavigationTime: $lastNavigationTime, currentRoute: $currentRoute)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavigationEntityImpl &&
            (identical(other.selectedTab, selectedTab) ||
                other.selectedTab == selectedTab) &&
            (identical(other.lastNavigationTime, lastNavigationTime) ||
                other.lastNavigationTime == lastNavigationTime) &&
            (identical(other.currentRoute, currentRoute) ||
                other.currentRoute == currentRoute));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, selectedTab, lastNavigationTime, currentRoute);

  /// Create a copy of NavigationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavigationEntityImplCopyWith<_$NavigationEntityImpl> get copyWith =>
      __$$NavigationEntityImplCopyWithImpl<_$NavigationEntityImpl>(
          this, _$identity);
}

abstract class _NavigationEntity implements NavigationEntity {
  const factory _NavigationEntity(
      {required final NavigationTab selectedTab,
      required final DateTime lastNavigationTime,
      required final String currentRoute}) = _$NavigationEntityImpl;

  @override
  NavigationTab get selectedTab;
  @override
  DateTime get lastNavigationTime;
  @override
  String get currentRoute;

  /// Create a copy of NavigationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavigationEntityImplCopyWith<_$NavigationEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
