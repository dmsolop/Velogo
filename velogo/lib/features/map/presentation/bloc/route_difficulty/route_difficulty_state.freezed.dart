// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_difficulty_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RouteDifficultyState {
  RouteDifficulty get difficulty => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of RouteDifficultyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteDifficultyStateCopyWith<RouteDifficultyState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteDifficultyStateCopyWith<$Res> {
  factory $RouteDifficultyStateCopyWith(RouteDifficultyState value,
          $Res Function(RouteDifficultyState) then) =
      _$RouteDifficultyStateCopyWithImpl<$Res, RouteDifficultyState>;
  @useResult
  $Res call({RouteDifficulty difficulty, bool isLoading, String? errorMessage});
}

/// @nodoc
class _$RouteDifficultyStateCopyWithImpl<$Res,
        $Val extends RouteDifficultyState>
    implements $RouteDifficultyStateCopyWith<$Res> {
  _$RouteDifficultyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteDifficultyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? difficulty = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as RouteDifficulty,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RouteDifficultyStateImplCopyWith<$Res>
    implements $RouteDifficultyStateCopyWith<$Res> {
  factory _$$RouteDifficultyStateImplCopyWith(_$RouteDifficultyStateImpl value,
          $Res Function(_$RouteDifficultyStateImpl) then) =
      __$$RouteDifficultyStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RouteDifficulty difficulty, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$$RouteDifficultyStateImplCopyWithImpl<$Res>
    extends _$RouteDifficultyStateCopyWithImpl<$Res, _$RouteDifficultyStateImpl>
    implements _$$RouteDifficultyStateImplCopyWith<$Res> {
  __$$RouteDifficultyStateImplCopyWithImpl(_$RouteDifficultyStateImpl _value,
      $Res Function(_$RouteDifficultyStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RouteDifficultyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? difficulty = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$RouteDifficultyStateImpl(
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as RouteDifficulty,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$RouteDifficultyStateImpl implements _RouteDifficultyState {
  const _$RouteDifficultyStateImpl(
      {this.difficulty = RouteDifficulty.moderate,
      this.isLoading = false,
      this.errorMessage});

  @override
  @JsonKey()
  final RouteDifficulty difficulty;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'RouteDifficultyState(difficulty: $difficulty, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteDifficultyStateImpl &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, difficulty, isLoading, errorMessage);

  /// Create a copy of RouteDifficultyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteDifficultyStateImplCopyWith<_$RouteDifficultyStateImpl>
      get copyWith =>
          __$$RouteDifficultyStateImplCopyWithImpl<_$RouteDifficultyStateImpl>(
              this, _$identity);
}

abstract class _RouteDifficultyState implements RouteDifficultyState {
  const factory _RouteDifficultyState(
      {final RouteDifficulty difficulty,
      final bool isLoading,
      final String? errorMessage}) = _$RouteDifficultyStateImpl;

  @override
  RouteDifficulty get difficulty;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of RouteDifficultyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteDifficultyStateImplCopyWith<_$RouteDifficultyStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
