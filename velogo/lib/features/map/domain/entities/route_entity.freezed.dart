// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RouteEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<LatLng> get coordinates => throw _privateConstructorUsedError;
  double get totalDistance => throw _privateConstructorUsedError;
  double get totalElevationGain => throw _privateConstructorUsedError;
  double get averageDifficulty => throw _privateConstructorUsedError;
  RouteDifficulty get difficulty => throw _privateConstructorUsedError;
  List<RouteSectionEntity> get sections => throw _privateConstructorUsedError;
  List<PointOfInterestEntity> get pointsOfInterest =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;

  /// Create a copy of RouteEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteEntityCopyWith<RouteEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteEntityCopyWith<$Res> {
  factory $RouteEntityCopyWith(
          RouteEntity value, $Res Function(RouteEntity) then) =
      _$RouteEntityCopyWithImpl<$Res, RouteEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      List<LatLng> coordinates,
      double totalDistance,
      double totalElevationGain,
      double averageDifficulty,
      RouteDifficulty difficulty,
      List<RouteSectionEntity> sections,
      List<PointOfInterestEntity> pointsOfInterest,
      DateTime createdAt,
      DateTime updatedAt,
      String? userId,
      bool isPublic,
      bool isFavorite});
}

/// @nodoc
class _$RouteEntityCopyWithImpl<$Res, $Val extends RouteEntity>
    implements $RouteEntityCopyWith<$Res> {
  _$RouteEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? coordinates = null,
    Object? totalDistance = null,
    Object? totalElevationGain = null,
    Object? averageDifficulty = null,
    Object? difficulty = null,
    Object? sections = null,
    Object? pointsOfInterest = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = freezed,
    Object? isPublic = null,
    Object? isFavorite = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
      totalElevationGain: null == totalElevationGain
          ? _value.totalElevationGain
          : totalElevationGain // ignore: cast_nullable_to_non_nullable
              as double,
      averageDifficulty: null == averageDifficulty
          ? _value.averageDifficulty
          : averageDifficulty // ignore: cast_nullable_to_non_nullable
              as double,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as RouteDifficulty,
      sections: null == sections
          ? _value.sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<RouteSectionEntity>,
      pointsOfInterest: null == pointsOfInterest
          ? _value.pointsOfInterest
          : pointsOfInterest // ignore: cast_nullable_to_non_nullable
              as List<PointOfInterestEntity>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RouteEntityImplCopyWith<$Res>
    implements $RouteEntityCopyWith<$Res> {
  factory _$$RouteEntityImplCopyWith(
          _$RouteEntityImpl value, $Res Function(_$RouteEntityImpl) then) =
      __$$RouteEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      List<LatLng> coordinates,
      double totalDistance,
      double totalElevationGain,
      double averageDifficulty,
      RouteDifficulty difficulty,
      List<RouteSectionEntity> sections,
      List<PointOfInterestEntity> pointsOfInterest,
      DateTime createdAt,
      DateTime updatedAt,
      String? userId,
      bool isPublic,
      bool isFavorite});
}

/// @nodoc
class __$$RouteEntityImplCopyWithImpl<$Res>
    extends _$RouteEntityCopyWithImpl<$Res, _$RouteEntityImpl>
    implements _$$RouteEntityImplCopyWith<$Res> {
  __$$RouteEntityImplCopyWithImpl(
      _$RouteEntityImpl _value, $Res Function(_$RouteEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of RouteEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? coordinates = null,
    Object? totalDistance = null,
    Object? totalElevationGain = null,
    Object? averageDifficulty = null,
    Object? difficulty = null,
    Object? sections = null,
    Object? pointsOfInterest = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = freezed,
    Object? isPublic = null,
    Object? isFavorite = null,
  }) {
    return _then(_$RouteEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: null == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
      totalElevationGain: null == totalElevationGain
          ? _value.totalElevationGain
          : totalElevationGain // ignore: cast_nullable_to_non_nullable
              as double,
      averageDifficulty: null == averageDifficulty
          ? _value.averageDifficulty
          : averageDifficulty // ignore: cast_nullable_to_non_nullable
              as double,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as RouteDifficulty,
      sections: null == sections
          ? _value._sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<RouteSectionEntity>,
      pointsOfInterest: null == pointsOfInterest
          ? _value._pointsOfInterest
          : pointsOfInterest // ignore: cast_nullable_to_non_nullable
              as List<PointOfInterestEntity>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RouteEntityImpl implements _RouteEntity {
  const _$RouteEntityImpl(
      {required this.id,
      required this.name,
      required this.description,
      required final List<LatLng> coordinates,
      required this.totalDistance,
      required this.totalElevationGain,
      required this.averageDifficulty,
      required this.difficulty,
      required final List<RouteSectionEntity> sections,
      required final List<PointOfInterestEntity> pointsOfInterest,
      required this.createdAt,
      required this.updatedAt,
      this.userId,
      this.isPublic = false,
      this.isFavorite = false})
      : _coordinates = coordinates,
        _sections = sections,
        _pointsOfInterest = pointsOfInterest;

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  final List<LatLng> _coordinates;
  @override
  List<LatLng> get coordinates {
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coordinates);
  }

  @override
  final double totalDistance;
  @override
  final double totalElevationGain;
  @override
  final double averageDifficulty;
  @override
  final RouteDifficulty difficulty;
  final List<RouteSectionEntity> _sections;
  @override
  List<RouteSectionEntity> get sections {
    if (_sections is EqualUnmodifiableListView) return _sections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sections);
  }

  final List<PointOfInterestEntity> _pointsOfInterest;
  @override
  List<PointOfInterestEntity> get pointsOfInterest {
    if (_pointsOfInterest is EqualUnmodifiableListView)
      return _pointsOfInterest;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pointsOfInterest);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? userId;
  @override
  @JsonKey()
  final bool isPublic;
  @override
  @JsonKey()
  final bool isFavorite;

  @override
  String toString() {
    return 'RouteEntity(id: $id, name: $name, description: $description, coordinates: $coordinates, totalDistance: $totalDistance, totalElevationGain: $totalElevationGain, averageDifficulty: $averageDifficulty, difficulty: $difficulty, sections: $sections, pointsOfInterest: $pointsOfInterest, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, isPublic: $isPublic, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates) &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance) &&
            (identical(other.totalElevationGain, totalElevationGain) ||
                other.totalElevationGain == totalElevationGain) &&
            (identical(other.averageDifficulty, averageDifficulty) ||
                other.averageDifficulty == averageDifficulty) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality().equals(other._sections, _sections) &&
            const DeepCollectionEquality()
                .equals(other._pointsOfInterest, _pointsOfInterest) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      const DeepCollectionEquality().hash(_coordinates),
      totalDistance,
      totalElevationGain,
      averageDifficulty,
      difficulty,
      const DeepCollectionEquality().hash(_sections),
      const DeepCollectionEquality().hash(_pointsOfInterest),
      createdAt,
      updatedAt,
      userId,
      isPublic,
      isFavorite);

  /// Create a copy of RouteEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteEntityImplCopyWith<_$RouteEntityImpl> get copyWith =>
      __$$RouteEntityImplCopyWithImpl<_$RouteEntityImpl>(this, _$identity);
}

abstract class _RouteEntity implements RouteEntity {
  const factory _RouteEntity(
      {required final String id,
      required final String name,
      required final String description,
      required final List<LatLng> coordinates,
      required final double totalDistance,
      required final double totalElevationGain,
      required final double averageDifficulty,
      required final RouteDifficulty difficulty,
      required final List<RouteSectionEntity> sections,
      required final List<PointOfInterestEntity> pointsOfInterest,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? userId,
      final bool isPublic,
      final bool isFavorite}) = _$RouteEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  List<LatLng> get coordinates;
  @override
  double get totalDistance;
  @override
  double get totalElevationGain;
  @override
  double get averageDifficulty;
  @override
  RouteDifficulty get difficulty;
  @override
  List<RouteSectionEntity> get sections;
  @override
  List<PointOfInterestEntity> get pointsOfInterest;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get userId;
  @override
  bool get isPublic;
  @override
  bool get isFavorite;

  /// Create a copy of RouteEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteEntityImplCopyWith<_$RouteEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RouteSectionEntity {
  String get id => throw _privateConstructorUsedError;
  List<LatLng> get coordinates => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;
  double get elevationGain => throw _privateConstructorUsedError;
  RoadSurfaceType get surfaceType => throw _privateConstructorUsedError;
  double get windEffect => throw _privateConstructorUsedError;
  double get difficulty => throw _privateConstructorUsedError;
  double get averageSpeed => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Create a copy of RouteSectionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteSectionEntityCopyWith<RouteSectionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteSectionEntityCopyWith<$Res> {
  factory $RouteSectionEntityCopyWith(
          RouteSectionEntity value, $Res Function(RouteSectionEntity) then) =
      _$RouteSectionEntityCopyWithImpl<$Res, RouteSectionEntity>;
  @useResult
  $Res call(
      {String id,
      List<LatLng> coordinates,
      double distance,
      double elevationGain,
      RoadSurfaceType surfaceType,
      double windEffect,
      double difficulty,
      double averageSpeed,
      String? notes});
}

/// @nodoc
class _$RouteSectionEntityCopyWithImpl<$Res, $Val extends RouteSectionEntity>
    implements $RouteSectionEntityCopyWith<$Res> {
  _$RouteSectionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteSectionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coordinates = null,
    Object? distance = null,
    Object? elevationGain = null,
    Object? surfaceType = null,
    Object? windEffect = null,
    Object? difficulty = null,
    Object? averageSpeed = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      elevationGain: null == elevationGain
          ? _value.elevationGain
          : elevationGain // ignore: cast_nullable_to_non_nullable
              as double,
      surfaceType: null == surfaceType
          ? _value.surfaceType
          : surfaceType // ignore: cast_nullable_to_non_nullable
              as RoadSurfaceType,
      windEffect: null == windEffect
          ? _value.windEffect
          : windEffect // ignore: cast_nullable_to_non_nullable
              as double,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as double,
      averageSpeed: null == averageSpeed
          ? _value.averageSpeed
          : averageSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RouteSectionEntityImplCopyWith<$Res>
    implements $RouteSectionEntityCopyWith<$Res> {
  factory _$$RouteSectionEntityImplCopyWith(_$RouteSectionEntityImpl value,
          $Res Function(_$RouteSectionEntityImpl) then) =
      __$$RouteSectionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      List<LatLng> coordinates,
      double distance,
      double elevationGain,
      RoadSurfaceType surfaceType,
      double windEffect,
      double difficulty,
      double averageSpeed,
      String? notes});
}

/// @nodoc
class __$$RouteSectionEntityImplCopyWithImpl<$Res>
    extends _$RouteSectionEntityCopyWithImpl<$Res, _$RouteSectionEntityImpl>
    implements _$$RouteSectionEntityImplCopyWith<$Res> {
  __$$RouteSectionEntityImplCopyWithImpl(_$RouteSectionEntityImpl _value,
      $Res Function(_$RouteSectionEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of RouteSectionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coordinates = null,
    Object? distance = null,
    Object? elevationGain = null,
    Object? surfaceType = null,
    Object? windEffect = null,
    Object? difficulty = null,
    Object? averageSpeed = null,
    Object? notes = freezed,
  }) {
    return _then(_$RouteSectionEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: null == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      elevationGain: null == elevationGain
          ? _value.elevationGain
          : elevationGain // ignore: cast_nullable_to_non_nullable
              as double,
      surfaceType: null == surfaceType
          ? _value.surfaceType
          : surfaceType // ignore: cast_nullable_to_non_nullable
              as RoadSurfaceType,
      windEffect: null == windEffect
          ? _value.windEffect
          : windEffect // ignore: cast_nullable_to_non_nullable
              as double,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as double,
      averageSpeed: null == averageSpeed
          ? _value.averageSpeed
          : averageSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$RouteSectionEntityImpl implements _RouteSectionEntity {
  const _$RouteSectionEntityImpl(
      {required this.id,
      required final List<LatLng> coordinates,
      required this.distance,
      required this.elevationGain,
      required this.surfaceType,
      required this.windEffect,
      required this.difficulty,
      required this.averageSpeed,
      this.notes})
      : _coordinates = coordinates;

  @override
  final String id;
  final List<LatLng> _coordinates;
  @override
  List<LatLng> get coordinates {
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coordinates);
  }

  @override
  final double distance;
  @override
  final double elevationGain;
  @override
  final RoadSurfaceType surfaceType;
  @override
  final double windEffect;
  @override
  final double difficulty;
  @override
  final double averageSpeed;
  @override
  final String? notes;

  @override
  String toString() {
    return 'RouteSectionEntity(id: $id, coordinates: $coordinates, distance: $distance, elevationGain: $elevationGain, surfaceType: $surfaceType, windEffect: $windEffect, difficulty: $difficulty, averageSpeed: $averageSpeed, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteSectionEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.elevationGain, elevationGain) ||
                other.elevationGain == elevationGain) &&
            (identical(other.surfaceType, surfaceType) ||
                other.surfaceType == surfaceType) &&
            (identical(other.windEffect, windEffect) ||
                other.windEffect == windEffect) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.averageSpeed, averageSpeed) ||
                other.averageSpeed == averageSpeed) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_coordinates),
      distance,
      elevationGain,
      surfaceType,
      windEffect,
      difficulty,
      averageSpeed,
      notes);

  /// Create a copy of RouteSectionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteSectionEntityImplCopyWith<_$RouteSectionEntityImpl> get copyWith =>
      __$$RouteSectionEntityImplCopyWithImpl<_$RouteSectionEntityImpl>(
          this, _$identity);
}

abstract class _RouteSectionEntity implements RouteSectionEntity {
  const factory _RouteSectionEntity(
      {required final String id,
      required final List<LatLng> coordinates,
      required final double distance,
      required final double elevationGain,
      required final RoadSurfaceType surfaceType,
      required final double windEffect,
      required final double difficulty,
      required final double averageSpeed,
      final String? notes}) = _$RouteSectionEntityImpl;

  @override
  String get id;
  @override
  List<LatLng> get coordinates;
  @override
  double get distance;
  @override
  double get elevationGain;
  @override
  RoadSurfaceType get surfaceType;
  @override
  double get windEffect;
  @override
  double get difficulty;
  @override
  double get averageSpeed;
  @override
  String? get notes;

  /// Create a copy of RouteSectionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteSectionEntityImplCopyWith<_$RouteSectionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PointOfInterestEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  LatLng get coordinates => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Create a copy of PointOfInterestEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PointOfInterestEntityCopyWith<PointOfInterestEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PointOfInterestEntityCopyWith<$Res> {
  factory $PointOfInterestEntityCopyWith(PointOfInterestEntity value,
          $Res Function(PointOfInterestEntity) then) =
      _$PointOfInterestEntityCopyWithImpl<$Res, PointOfInterestEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      LatLng coordinates,
      String description,
      String? imageUrl,
      double? rating,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$PointOfInterestEntityCopyWithImpl<$Res,
        $Val extends PointOfInterestEntity>
    implements $PointOfInterestEntityCopyWith<$Res> {
  _$PointOfInterestEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PointOfInterestEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? coordinates = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? rating = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as LatLng,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PointOfInterestEntityImplCopyWith<$Res>
    implements $PointOfInterestEntityCopyWith<$Res> {
  factory _$$PointOfInterestEntityImplCopyWith(
          _$PointOfInterestEntityImpl value,
          $Res Function(_$PointOfInterestEntityImpl) then) =
      __$$PointOfInterestEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      LatLng coordinates,
      String description,
      String? imageUrl,
      double? rating,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$PointOfInterestEntityImplCopyWithImpl<$Res>
    extends _$PointOfInterestEntityCopyWithImpl<$Res,
        _$PointOfInterestEntityImpl>
    implements _$$PointOfInterestEntityImplCopyWith<$Res> {
  __$$PointOfInterestEntityImplCopyWithImpl(_$PointOfInterestEntityImpl _value,
      $Res Function(_$PointOfInterestEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of PointOfInterestEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? coordinates = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? rating = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$PointOfInterestEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as LatLng,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$PointOfInterestEntityImpl implements _PointOfInterestEntity {
  const _$PointOfInterestEntityImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.coordinates,
      required this.description,
      this.imageUrl,
      this.rating,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  final LatLng coordinates;
  @override
  final String description;
  @override
  final String? imageUrl;
  @override
  final double? rating;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PointOfInterestEntity(id: $id, name: $name, type: $type, coordinates: $coordinates, description: $description, imageUrl: $imageUrl, rating: $rating, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PointOfInterestEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.coordinates, coordinates) ||
                other.coordinates == coordinates) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      coordinates,
      description,
      imageUrl,
      rating,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of PointOfInterestEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PointOfInterestEntityImplCopyWith<_$PointOfInterestEntityImpl>
      get copyWith => __$$PointOfInterestEntityImplCopyWithImpl<
          _$PointOfInterestEntityImpl>(this, _$identity);
}

abstract class _PointOfInterestEntity implements PointOfInterestEntity {
  const factory _PointOfInterestEntity(
      {required final String id,
      required final String name,
      required final String type,
      required final LatLng coordinates,
      required final String description,
      final String? imageUrl,
      final double? rating,
      final Map<String, dynamic>? metadata}) = _$PointOfInterestEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  LatLng get coordinates;
  @override
  String get description;
  @override
  String? get imageUrl;
  @override
  double? get rating;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PointOfInterestEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PointOfInterestEntityImplCopyWith<_$PointOfInterestEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
