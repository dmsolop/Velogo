// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HealthMetrics _$HealthMetricsFromJson(Map<String, dynamic> json) {
  return _HealthMetrics.fromJson(json);
}

/// @nodoc
mixin _$HealthMetrics {
// Серцево-судинні показники
  int? get restingHeartRate =>
      throw _privateConstructorUsedError; // Пульс спокою (BPM)
  int? get maxHeartRate =>
      throw _privateConstructorUsedError; // Максимальний пульс
  double? get bloodPressure =>
      throw _privateConstructorUsedError; // Тиск (систолічний)
  int? get heartRateVariability =>
      throw _privateConstructorUsedError; // Варіабельність пульсу
// Фізична активність
  int? get dailySteps => throw _privateConstructorUsedError; // Кроки за день
  double? get activeMinutes =>
      throw _privateConstructorUsedError; // Активні хвилини
  double? get caloriesBurned =>
      throw _privateConstructorUsedError; // Спалені калорії
  String? get activityLevel =>
      throw _privateConstructorUsedError; // Рівень активності
// Відновлення та втома
  double? get sleepQuality =>
      throw _privateConstructorUsedError; // Якість сну (0-1)
  int? get sleepDuration =>
      throw _privateConstructorUsedError; // Тривалість сну (хвилини)
  double? get stressLevel =>
      throw _privateConstructorUsedError; // Рівень стресу (0-1)
  double? get recoveryScore =>
      throw _privateConstructorUsedError; // Оцінка відновлення (0-1)
// Метадані
  DateTime? get lastUpdated =>
      throw _privateConstructorUsedError; // Час останнього оновлення
  String? get source => throw _privateConstructorUsedError;

  /// Serializes this HealthMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthMetricsCopyWith<HealthMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthMetricsCopyWith<$Res> {
  factory $HealthMetricsCopyWith(
          HealthMetrics value, $Res Function(HealthMetrics) then) =
      _$HealthMetricsCopyWithImpl<$Res, HealthMetrics>;
  @useResult
  $Res call(
      {int? restingHeartRate,
      int? maxHeartRate,
      double? bloodPressure,
      int? heartRateVariability,
      int? dailySteps,
      double? activeMinutes,
      double? caloriesBurned,
      String? activityLevel,
      double? sleepQuality,
      int? sleepDuration,
      double? stressLevel,
      double? recoveryScore,
      DateTime? lastUpdated,
      String? source});
}

/// @nodoc
class _$HealthMetricsCopyWithImpl<$Res, $Val extends HealthMetrics>
    implements $HealthMetricsCopyWith<$Res> {
  _$HealthMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? restingHeartRate = freezed,
    Object? maxHeartRate = freezed,
    Object? bloodPressure = freezed,
    Object? heartRateVariability = freezed,
    Object? dailySteps = freezed,
    Object? activeMinutes = freezed,
    Object? caloriesBurned = freezed,
    Object? activityLevel = freezed,
    Object? sleepQuality = freezed,
    Object? sleepDuration = freezed,
    Object? stressLevel = freezed,
    Object? recoveryScore = freezed,
    Object? lastUpdated = freezed,
    Object? source = freezed,
  }) {
    return _then(_value.copyWith(
      restingHeartRate: freezed == restingHeartRate
          ? _value.restingHeartRate
          : restingHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      maxHeartRate: freezed == maxHeartRate
          ? _value.maxHeartRate
          : maxHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      bloodPressure: freezed == bloodPressure
          ? _value.bloodPressure
          : bloodPressure // ignore: cast_nullable_to_non_nullable
              as double?,
      heartRateVariability: freezed == heartRateVariability
          ? _value.heartRateVariability
          : heartRateVariability // ignore: cast_nullable_to_non_nullable
              as int?,
      dailySteps: freezed == dailySteps
          ? _value.dailySteps
          : dailySteps // ignore: cast_nullable_to_non_nullable
              as int?,
      activeMinutes: freezed == activeMinutes
          ? _value.activeMinutes
          : activeMinutes // ignore: cast_nullable_to_non_nullable
              as double?,
      caloriesBurned: freezed == caloriesBurned
          ? _value.caloriesBurned
          : caloriesBurned // ignore: cast_nullable_to_non_nullable
              as double?,
      activityLevel: freezed == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      sleepQuality: freezed == sleepQuality
          ? _value.sleepQuality
          : sleepQuality // ignore: cast_nullable_to_non_nullable
              as double?,
      sleepDuration: freezed == sleepDuration
          ? _value.sleepDuration
          : sleepDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      stressLevel: freezed == stressLevel
          ? _value.stressLevel
          : stressLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      recoveryScore: freezed == recoveryScore
          ? _value.recoveryScore
          : recoveryScore // ignore: cast_nullable_to_non_nullable
              as double?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthMetricsImplCopyWith<$Res>
    implements $HealthMetricsCopyWith<$Res> {
  factory _$$HealthMetricsImplCopyWith(
          _$HealthMetricsImpl value, $Res Function(_$HealthMetricsImpl) then) =
      __$$HealthMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? restingHeartRate,
      int? maxHeartRate,
      double? bloodPressure,
      int? heartRateVariability,
      int? dailySteps,
      double? activeMinutes,
      double? caloriesBurned,
      String? activityLevel,
      double? sleepQuality,
      int? sleepDuration,
      double? stressLevel,
      double? recoveryScore,
      DateTime? lastUpdated,
      String? source});
}

/// @nodoc
class __$$HealthMetricsImplCopyWithImpl<$Res>
    extends _$HealthMetricsCopyWithImpl<$Res, _$HealthMetricsImpl>
    implements _$$HealthMetricsImplCopyWith<$Res> {
  __$$HealthMetricsImplCopyWithImpl(
      _$HealthMetricsImpl _value, $Res Function(_$HealthMetricsImpl) _then)
      : super(_value, _then);

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? restingHeartRate = freezed,
    Object? maxHeartRate = freezed,
    Object? bloodPressure = freezed,
    Object? heartRateVariability = freezed,
    Object? dailySteps = freezed,
    Object? activeMinutes = freezed,
    Object? caloriesBurned = freezed,
    Object? activityLevel = freezed,
    Object? sleepQuality = freezed,
    Object? sleepDuration = freezed,
    Object? stressLevel = freezed,
    Object? recoveryScore = freezed,
    Object? lastUpdated = freezed,
    Object? source = freezed,
  }) {
    return _then(_$HealthMetricsImpl(
      restingHeartRate: freezed == restingHeartRate
          ? _value.restingHeartRate
          : restingHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      maxHeartRate: freezed == maxHeartRate
          ? _value.maxHeartRate
          : maxHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      bloodPressure: freezed == bloodPressure
          ? _value.bloodPressure
          : bloodPressure // ignore: cast_nullable_to_non_nullable
              as double?,
      heartRateVariability: freezed == heartRateVariability
          ? _value.heartRateVariability
          : heartRateVariability // ignore: cast_nullable_to_non_nullable
              as int?,
      dailySteps: freezed == dailySteps
          ? _value.dailySteps
          : dailySteps // ignore: cast_nullable_to_non_nullable
              as int?,
      activeMinutes: freezed == activeMinutes
          ? _value.activeMinutes
          : activeMinutes // ignore: cast_nullable_to_non_nullable
              as double?,
      caloriesBurned: freezed == caloriesBurned
          ? _value.caloriesBurned
          : caloriesBurned // ignore: cast_nullable_to_non_nullable
              as double?,
      activityLevel: freezed == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      sleepQuality: freezed == sleepQuality
          ? _value.sleepQuality
          : sleepQuality // ignore: cast_nullable_to_non_nullable
              as double?,
      sleepDuration: freezed == sleepDuration
          ? _value.sleepDuration
          : sleepDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      stressLevel: freezed == stressLevel
          ? _value.stressLevel
          : stressLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      recoveryScore: freezed == recoveryScore
          ? _value.recoveryScore
          : recoveryScore // ignore: cast_nullable_to_non_nullable
              as double?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthMetricsImpl implements _HealthMetrics {
  const _$HealthMetricsImpl(
      {this.restingHeartRate,
      this.maxHeartRate,
      this.bloodPressure,
      this.heartRateVariability,
      this.dailySteps,
      this.activeMinutes,
      this.caloriesBurned,
      this.activityLevel,
      this.sleepQuality,
      this.sleepDuration,
      this.stressLevel,
      this.recoveryScore,
      this.lastUpdated,
      this.source});

  factory _$HealthMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthMetricsImplFromJson(json);

// Серцево-судинні показники
  @override
  final int? restingHeartRate;
// Пульс спокою (BPM)
  @override
  final int? maxHeartRate;
// Максимальний пульс
  @override
  final double? bloodPressure;
// Тиск (систолічний)
  @override
  final int? heartRateVariability;
// Варіабельність пульсу
// Фізична активність
  @override
  final int? dailySteps;
// Кроки за день
  @override
  final double? activeMinutes;
// Активні хвилини
  @override
  final double? caloriesBurned;
// Спалені калорії
  @override
  final String? activityLevel;
// Рівень активності
// Відновлення та втома
  @override
  final double? sleepQuality;
// Якість сну (0-1)
  @override
  final int? sleepDuration;
// Тривалість сну (хвилини)
  @override
  final double? stressLevel;
// Рівень стресу (0-1)
  @override
  final double? recoveryScore;
// Оцінка відновлення (0-1)
// Метадані
  @override
  final DateTime? lastUpdated;
// Час останнього оновлення
  @override
  final String? source;

  @override
  String toString() {
    return 'HealthMetrics(restingHeartRate: $restingHeartRate, maxHeartRate: $maxHeartRate, bloodPressure: $bloodPressure, heartRateVariability: $heartRateVariability, dailySteps: $dailySteps, activeMinutes: $activeMinutes, caloriesBurned: $caloriesBurned, activityLevel: $activityLevel, sleepQuality: $sleepQuality, sleepDuration: $sleepDuration, stressLevel: $stressLevel, recoveryScore: $recoveryScore, lastUpdated: $lastUpdated, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthMetricsImpl &&
            (identical(other.restingHeartRate, restingHeartRate) ||
                other.restingHeartRate == restingHeartRate) &&
            (identical(other.maxHeartRate, maxHeartRate) ||
                other.maxHeartRate == maxHeartRate) &&
            (identical(other.bloodPressure, bloodPressure) ||
                other.bloodPressure == bloodPressure) &&
            (identical(other.heartRateVariability, heartRateVariability) ||
                other.heartRateVariability == heartRateVariability) &&
            (identical(other.dailySteps, dailySteps) ||
                other.dailySteps == dailySteps) &&
            (identical(other.activeMinutes, activeMinutes) ||
                other.activeMinutes == activeMinutes) &&
            (identical(other.caloriesBurned, caloriesBurned) ||
                other.caloriesBurned == caloriesBurned) &&
            (identical(other.activityLevel, activityLevel) ||
                other.activityLevel == activityLevel) &&
            (identical(other.sleepQuality, sleepQuality) ||
                other.sleepQuality == sleepQuality) &&
            (identical(other.sleepDuration, sleepDuration) ||
                other.sleepDuration == sleepDuration) &&
            (identical(other.stressLevel, stressLevel) ||
                other.stressLevel == stressLevel) &&
            (identical(other.recoveryScore, recoveryScore) ||
                other.recoveryScore == recoveryScore) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.source, source) || other.source == source));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      restingHeartRate,
      maxHeartRate,
      bloodPressure,
      heartRateVariability,
      dailySteps,
      activeMinutes,
      caloriesBurned,
      activityLevel,
      sleepQuality,
      sleepDuration,
      stressLevel,
      recoveryScore,
      lastUpdated,
      source);

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthMetricsImplCopyWith<_$HealthMetricsImpl> get copyWith =>
      __$$HealthMetricsImplCopyWithImpl<_$HealthMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthMetricsImplToJson(
      this,
    );
  }
}

abstract class _HealthMetrics implements HealthMetrics {
  const factory _HealthMetrics(
      {final int? restingHeartRate,
      final int? maxHeartRate,
      final double? bloodPressure,
      final int? heartRateVariability,
      final int? dailySteps,
      final double? activeMinutes,
      final double? caloriesBurned,
      final String? activityLevel,
      final double? sleepQuality,
      final int? sleepDuration,
      final double? stressLevel,
      final double? recoveryScore,
      final DateTime? lastUpdated,
      final String? source}) = _$HealthMetricsImpl;

  factory _HealthMetrics.fromJson(Map<String, dynamic> json) =
      _$HealthMetricsImpl.fromJson;

// Серцево-судинні показники
  @override
  int? get restingHeartRate; // Пульс спокою (BPM)
  @override
  int? get maxHeartRate; // Максимальний пульс
  @override
  double? get bloodPressure; // Тиск (систолічний)
  @override
  int? get heartRateVariability; // Варіабельність пульсу
// Фізична активність
  @override
  int? get dailySteps; // Кроки за день
  @override
  double? get activeMinutes; // Активні хвилини
  @override
  double? get caloriesBurned; // Спалені калорії
  @override
  String? get activityLevel; // Рівень активності
// Відновлення та втома
  @override
  double? get sleepQuality; // Якість сну (0-1)
  @override
  int? get sleepDuration; // Тривалість сну (хвилини)
  @override
  double? get stressLevel; // Рівень стресу (0-1)
  @override
  double? get recoveryScore; // Оцінка відновлення (0-1)
// Метадані
  @override
  DateTime? get lastUpdated; // Час останнього оновлення
  @override
  String? get source;

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthMetricsImplCopyWith<_$HealthMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PersonalizedDifficultyResult _$PersonalizedDifficultyResultFromJson(
    Map<String, dynamic> json) {
  return _PersonalizedDifficultyResult.fromJson(json);
}

/// @nodoc
mixin _$PersonalizedDifficultyResult {
  double get baseDifficulty =>
      throw _privateConstructorUsedError; // Базова складність
  double get personalizedDifficulty =>
      throw _privateConstructorUsedError; // Персоналізована складність
  double get personalizationFactor =>
      throw _privateConstructorUsedError; // Коефіцієнт персоналізації
  List<DifficultyFactor> get factors =>
      throw _privateConstructorUsedError; // Фактори впливу
  String get difficultyLevel =>
      throw _privateConstructorUsedError; // Рівень складності (текст)
  int get difficultyColor =>
      throw _privateConstructorUsedError; // Колір складності
  DateTime? get calculatedAt => throw _privateConstructorUsedError;

  /// Serializes this PersonalizedDifficultyResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonalizedDifficultyResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonalizedDifficultyResultCopyWith<PersonalizedDifficultyResult>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalizedDifficultyResultCopyWith<$Res> {
  factory $PersonalizedDifficultyResultCopyWith(
          PersonalizedDifficultyResult value,
          $Res Function(PersonalizedDifficultyResult) then) =
      _$PersonalizedDifficultyResultCopyWithImpl<$Res,
          PersonalizedDifficultyResult>;
  @useResult
  $Res call(
      {double baseDifficulty,
      double personalizedDifficulty,
      double personalizationFactor,
      List<DifficultyFactor> factors,
      String difficultyLevel,
      int difficultyColor,
      DateTime? calculatedAt});
}

/// @nodoc
class _$PersonalizedDifficultyResultCopyWithImpl<$Res,
        $Val extends PersonalizedDifficultyResult>
    implements $PersonalizedDifficultyResultCopyWith<$Res> {
  _$PersonalizedDifficultyResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonalizedDifficultyResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseDifficulty = null,
    Object? personalizedDifficulty = null,
    Object? personalizationFactor = null,
    Object? factors = null,
    Object? difficultyLevel = null,
    Object? difficultyColor = null,
    Object? calculatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      baseDifficulty: null == baseDifficulty
          ? _value.baseDifficulty
          : baseDifficulty // ignore: cast_nullable_to_non_nullable
              as double,
      personalizedDifficulty: null == personalizedDifficulty
          ? _value.personalizedDifficulty
          : personalizedDifficulty // ignore: cast_nullable_to_non_nullable
              as double,
      personalizationFactor: null == personalizationFactor
          ? _value.personalizationFactor
          : personalizationFactor // ignore: cast_nullable_to_non_nullable
              as double,
      factors: null == factors
          ? _value.factors
          : factors // ignore: cast_nullable_to_non_nullable
              as List<DifficultyFactor>,
      difficultyLevel: null == difficultyLevel
          ? _value.difficultyLevel
          : difficultyLevel // ignore: cast_nullable_to_non_nullable
              as String,
      difficultyColor: null == difficultyColor
          ? _value.difficultyColor
          : difficultyColor // ignore: cast_nullable_to_non_nullable
              as int,
      calculatedAt: freezed == calculatedAt
          ? _value.calculatedAt
          : calculatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonalizedDifficultyResultImplCopyWith<$Res>
    implements $PersonalizedDifficultyResultCopyWith<$Res> {
  factory _$$PersonalizedDifficultyResultImplCopyWith(
          _$PersonalizedDifficultyResultImpl value,
          $Res Function(_$PersonalizedDifficultyResultImpl) then) =
      __$$PersonalizedDifficultyResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double baseDifficulty,
      double personalizedDifficulty,
      double personalizationFactor,
      List<DifficultyFactor> factors,
      String difficultyLevel,
      int difficultyColor,
      DateTime? calculatedAt});
}

/// @nodoc
class __$$PersonalizedDifficultyResultImplCopyWithImpl<$Res>
    extends _$PersonalizedDifficultyResultCopyWithImpl<$Res,
        _$PersonalizedDifficultyResultImpl>
    implements _$$PersonalizedDifficultyResultImplCopyWith<$Res> {
  __$$PersonalizedDifficultyResultImplCopyWithImpl(
      _$PersonalizedDifficultyResultImpl _value,
      $Res Function(_$PersonalizedDifficultyResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of PersonalizedDifficultyResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseDifficulty = null,
    Object? personalizedDifficulty = null,
    Object? personalizationFactor = null,
    Object? factors = null,
    Object? difficultyLevel = null,
    Object? difficultyColor = null,
    Object? calculatedAt = freezed,
  }) {
    return _then(_$PersonalizedDifficultyResultImpl(
      baseDifficulty: null == baseDifficulty
          ? _value.baseDifficulty
          : baseDifficulty // ignore: cast_nullable_to_non_nullable
              as double,
      personalizedDifficulty: null == personalizedDifficulty
          ? _value.personalizedDifficulty
          : personalizedDifficulty // ignore: cast_nullable_to_non_nullable
              as double,
      personalizationFactor: null == personalizationFactor
          ? _value.personalizationFactor
          : personalizationFactor // ignore: cast_nullable_to_non_nullable
              as double,
      factors: null == factors
          ? _value._factors
          : factors // ignore: cast_nullable_to_non_nullable
              as List<DifficultyFactor>,
      difficultyLevel: null == difficultyLevel
          ? _value.difficultyLevel
          : difficultyLevel // ignore: cast_nullable_to_non_nullable
              as String,
      difficultyColor: null == difficultyColor
          ? _value.difficultyColor
          : difficultyColor // ignore: cast_nullable_to_non_nullable
              as int,
      calculatedAt: freezed == calculatedAt
          ? _value.calculatedAt
          : calculatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonalizedDifficultyResultImpl
    implements _PersonalizedDifficultyResult {
  const _$PersonalizedDifficultyResultImpl(
      {required this.baseDifficulty,
      required this.personalizedDifficulty,
      required this.personalizationFactor,
      required final List<DifficultyFactor> factors,
      required this.difficultyLevel,
      required this.difficultyColor,
      this.calculatedAt})
      : _factors = factors;

  factory _$PersonalizedDifficultyResultImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PersonalizedDifficultyResultImplFromJson(json);

  @override
  final double baseDifficulty;
// Базова складність
  @override
  final double personalizedDifficulty;
// Персоналізована складність
  @override
  final double personalizationFactor;
// Коефіцієнт персоналізації
  final List<DifficultyFactor> _factors;
// Коефіцієнт персоналізації
  @override
  List<DifficultyFactor> get factors {
    if (_factors is EqualUnmodifiableListView) return _factors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_factors);
  }

// Фактори впливу
  @override
  final String difficultyLevel;
// Рівень складності (текст)
  @override
  final int difficultyColor;
// Колір складності
  @override
  final DateTime? calculatedAt;

  @override
  String toString() {
    return 'PersonalizedDifficultyResult(baseDifficulty: $baseDifficulty, personalizedDifficulty: $personalizedDifficulty, personalizationFactor: $personalizationFactor, factors: $factors, difficultyLevel: $difficultyLevel, difficultyColor: $difficultyColor, calculatedAt: $calculatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalizedDifficultyResultImpl &&
            (identical(other.baseDifficulty, baseDifficulty) ||
                other.baseDifficulty == baseDifficulty) &&
            (identical(other.personalizedDifficulty, personalizedDifficulty) ||
                other.personalizedDifficulty == personalizedDifficulty) &&
            (identical(other.personalizationFactor, personalizationFactor) ||
                other.personalizationFactor == personalizationFactor) &&
            const DeepCollectionEquality().equals(other._factors, _factors) &&
            (identical(other.difficultyLevel, difficultyLevel) ||
                other.difficultyLevel == difficultyLevel) &&
            (identical(other.difficultyColor, difficultyColor) ||
                other.difficultyColor == difficultyColor) &&
            (identical(other.calculatedAt, calculatedAt) ||
                other.calculatedAt == calculatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      baseDifficulty,
      personalizedDifficulty,
      personalizationFactor,
      const DeepCollectionEquality().hash(_factors),
      difficultyLevel,
      difficultyColor,
      calculatedAt);

  /// Create a copy of PersonalizedDifficultyResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalizedDifficultyResultImplCopyWith<
          _$PersonalizedDifficultyResultImpl>
      get copyWith => __$$PersonalizedDifficultyResultImplCopyWithImpl<
          _$PersonalizedDifficultyResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonalizedDifficultyResultImplToJson(
      this,
    );
  }
}

abstract class _PersonalizedDifficultyResult
    implements PersonalizedDifficultyResult {
  const factory _PersonalizedDifficultyResult(
      {required final double baseDifficulty,
      required final double personalizedDifficulty,
      required final double personalizationFactor,
      required final List<DifficultyFactor> factors,
      required final String difficultyLevel,
      required final int difficultyColor,
      final DateTime? calculatedAt}) = _$PersonalizedDifficultyResultImpl;

  factory _PersonalizedDifficultyResult.fromJson(Map<String, dynamic> json) =
      _$PersonalizedDifficultyResultImpl.fromJson;

  @override
  double get baseDifficulty; // Базова складність
  @override
  double get personalizedDifficulty; // Персоналізована складність
  @override
  double get personalizationFactor; // Коефіцієнт персоналізації
  @override
  List<DifficultyFactor> get factors; // Фактори впливу
  @override
  String get difficultyLevel; // Рівень складності (текст)
  @override
  int get difficultyColor; // Колір складності
  @override
  DateTime? get calculatedAt;

  /// Create a copy of PersonalizedDifficultyResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalizedDifficultyResultImplCopyWith<
          _$PersonalizedDifficultyResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}

DifficultyFactor _$DifficultyFactorFromJson(Map<String, dynamic> json) {
  return _DifficultyFactor.fromJson(json);
}

/// @nodoc
mixin _$DifficultyFactor {
  String get name => throw _privateConstructorUsedError; // Назва фактора
  String get description => throw _privateConstructorUsedError; // Опис впливу
  double get impact =>
      throw _privateConstructorUsedError; // Вплив на складність (-1.0 до 1.0)
  String get category =>
      throw _privateConstructorUsedError; // Категорія (age, fitness, health, weather, terrain)
  bool get isPositive => throw _privateConstructorUsedError;

  /// Serializes this DifficultyFactor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DifficultyFactor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DifficultyFactorCopyWith<DifficultyFactor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DifficultyFactorCopyWith<$Res> {
  factory $DifficultyFactorCopyWith(
          DifficultyFactor value, $Res Function(DifficultyFactor) then) =
      _$DifficultyFactorCopyWithImpl<$Res, DifficultyFactor>;
  @useResult
  $Res call(
      {String name,
      String description,
      double impact,
      String category,
      bool isPositive});
}

/// @nodoc
class _$DifficultyFactorCopyWithImpl<$Res, $Val extends DifficultyFactor>
    implements $DifficultyFactorCopyWith<$Res> {
  _$DifficultyFactorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DifficultyFactor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? impact = null,
    Object? category = null,
    Object? isPositive = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isPositive: null == isPositive
          ? _value.isPositive
          : isPositive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DifficultyFactorImplCopyWith<$Res>
    implements $DifficultyFactorCopyWith<$Res> {
  factory _$$DifficultyFactorImplCopyWith(_$DifficultyFactorImpl value,
          $Res Function(_$DifficultyFactorImpl) then) =
      __$$DifficultyFactorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String description,
      double impact,
      String category,
      bool isPositive});
}

/// @nodoc
class __$$DifficultyFactorImplCopyWithImpl<$Res>
    extends _$DifficultyFactorCopyWithImpl<$Res, _$DifficultyFactorImpl>
    implements _$$DifficultyFactorImplCopyWith<$Res> {
  __$$DifficultyFactorImplCopyWithImpl(_$DifficultyFactorImpl _value,
      $Res Function(_$DifficultyFactorImpl) _then)
      : super(_value, _then);

  /// Create a copy of DifficultyFactor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? impact = null,
    Object? category = null,
    Object? isPositive = null,
  }) {
    return _then(_$DifficultyFactorImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isPositive: null == isPositive
          ? _value.isPositive
          : isPositive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DifficultyFactorImpl implements _DifficultyFactor {
  const _$DifficultyFactorImpl(
      {required this.name,
      required this.description,
      required this.impact,
      required this.category,
      required this.isPositive});

  factory _$DifficultyFactorImpl.fromJson(Map<String, dynamic> json) =>
      _$$DifficultyFactorImplFromJson(json);

  @override
  final String name;
// Назва фактора
  @override
  final String description;
// Опис впливу
  @override
  final double impact;
// Вплив на складність (-1.0 до 1.0)
  @override
  final String category;
// Категорія (age, fitness, health, weather, terrain)
  @override
  final bool isPositive;

  @override
  String toString() {
    return 'DifficultyFactor(name: $name, description: $description, impact: $impact, category: $category, isPositive: $isPositive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DifficultyFactorImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.impact, impact) || other.impact == impact) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isPositive, isPositive) ||
                other.isPositive == isPositive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, description, impact, category, isPositive);

  /// Create a copy of DifficultyFactor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DifficultyFactorImplCopyWith<_$DifficultyFactorImpl> get copyWith =>
      __$$DifficultyFactorImplCopyWithImpl<_$DifficultyFactorImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DifficultyFactorImplToJson(
      this,
    );
  }
}

abstract class _DifficultyFactor implements DifficultyFactor {
  const factory _DifficultyFactor(
      {required final String name,
      required final String description,
      required final double impact,
      required final String category,
      required final bool isPositive}) = _$DifficultyFactorImpl;

  factory _DifficultyFactor.fromJson(Map<String, dynamic> json) =
      _$DifficultyFactorImpl.fromJson;

  @override
  String get name; // Назва фактора
  @override
  String get description; // Опис впливу
  @override
  double get impact; // Вплив на складність (-1.0 до 1.0)
  @override
  String get category; // Категорія (age, fitness, health, weather, terrain)
  @override
  bool get isPositive;

  /// Create a copy of DifficultyFactor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DifficultyFactorImplCopyWith<_$DifficultyFactorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
