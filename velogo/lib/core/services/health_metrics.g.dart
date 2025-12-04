// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthMetricsImpl _$$HealthMetricsImplFromJson(Map<String, dynamic> json) =>
    _$HealthMetricsImpl(
      restingHeartRate: (json['restingHeartRate'] as num?)?.toInt(),
      maxHeartRate: (json['maxHeartRate'] as num?)?.toInt(),
      bloodPressure: (json['bloodPressure'] as num?)?.toDouble(),
      heartRateVariability: (json['heartRateVariability'] as num?)?.toInt(),
      dailySteps: (json['dailySteps'] as num?)?.toInt(),
      activeMinutes: (json['activeMinutes'] as num?)?.toDouble(),
      caloriesBurned: (json['caloriesBurned'] as num?)?.toDouble(),
      activityLevel: json['activityLevel'] as String?,
      sleepQuality: (json['sleepQuality'] as num?)?.toDouble(),
      sleepDuration: (json['sleepDuration'] as num?)?.toInt(),
      stressLevel: (json['stressLevel'] as num?)?.toDouble(),
      recoveryScore: (json['recoveryScore'] as num?)?.toDouble(),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      source: json['source'] as String?,
    );

Map<String, dynamic> _$$HealthMetricsImplToJson(_$HealthMetricsImpl instance) =>
    <String, dynamic>{
      'restingHeartRate': instance.restingHeartRate,
      'maxHeartRate': instance.maxHeartRate,
      'bloodPressure': instance.bloodPressure,
      'heartRateVariability': instance.heartRateVariability,
      'dailySteps': instance.dailySteps,
      'activeMinutes': instance.activeMinutes,
      'caloriesBurned': instance.caloriesBurned,
      'activityLevel': instance.activityLevel,
      'sleepQuality': instance.sleepQuality,
      'sleepDuration': instance.sleepDuration,
      'stressLevel': instance.stressLevel,
      'recoveryScore': instance.recoveryScore,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'source': instance.source,
    };

_$PersonalizedDifficultyResultImpl _$$PersonalizedDifficultyResultImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonalizedDifficultyResultImpl(
      baseDifficulty: (json['baseDifficulty'] as num).toDouble(),
      personalizedDifficulty:
          (json['personalizedDifficulty'] as num).toDouble(),
      personalizationFactor: (json['personalizationFactor'] as num).toDouble(),
      factors: (json['factors'] as List<dynamic>)
          .map((e) => DifficultyFactor.fromJson(e as Map<String, dynamic>))
          .toList(),
      difficultyLevel: json['difficultyLevel'] as String,
      difficultyColor: (json['difficultyColor'] as num).toInt(),
      calculatedAt: json['calculatedAt'] == null
          ? null
          : DateTime.parse(json['calculatedAt'] as String),
    );

Map<String, dynamic> _$$PersonalizedDifficultyResultImplToJson(
        _$PersonalizedDifficultyResultImpl instance) =>
    <String, dynamic>{
      'baseDifficulty': instance.baseDifficulty,
      'personalizedDifficulty': instance.personalizedDifficulty,
      'personalizationFactor': instance.personalizationFactor,
      'factors': instance.factors,
      'difficultyLevel': instance.difficultyLevel,
      'difficultyColor': instance.difficultyColor,
      'calculatedAt': instance.calculatedAt?.toIso8601String(),
    };

_$DifficultyFactorImpl _$$DifficultyFactorImplFromJson(
        Map<String, dynamic> json) =>
    _$DifficultyFactorImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      impact: (json['impact'] as num).toDouble(),
      category: json['category'] as String,
      isPositive: json['isPositive'] as bool,
    );

Map<String, dynamic> _$$DifficultyFactorImplToJson(
        _$DifficultyFactorImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'impact': instance.impact,
      'category': instance.category,
      'isPositive': instance.isPositive,
    };

_$SectionParametersImpl _$$SectionParametersImplFromJson(
        Map<String, dynamic> json) =>
    _$SectionParametersImpl(
      elevationGain: (json['elevationGain'] as num).toDouble(),
      windEffect: (json['windEffect'] as num).toDouble(),
      surfaceType: $enumDecode(_$RoadSurfaceTypeEnumMap, json['surfaceType']),
      difficulty: (json['difficulty'] as num).toDouble(),
      averageSpeed: (json['averageSpeed'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
    );

Map<String, dynamic> _$$SectionParametersImplToJson(
        _$SectionParametersImpl instance) =>
    <String, dynamic>{
      'elevationGain': instance.elevationGain,
      'windEffect': instance.windEffect,
      'surfaceType': _$RoadSurfaceTypeEnumMap[instance.surfaceType]!,
      'difficulty': instance.difficulty,
      'averageSpeed': instance.averageSpeed,
      'distance': instance.distance,
    };

const _$RoadSurfaceTypeEnumMap = {
  RoadSurfaceType.asphalt: 'asphalt',
  RoadSurfaceType.concrete: 'concrete',
  RoadSurfaceType.gravel: 'gravel',
  RoadSurfaceType.dirt: 'dirt',
  RoadSurfaceType.cobblestone: 'cobblestone',
  RoadSurfaceType.grass: 'grass',
  RoadSurfaceType.sand: 'sand',
};
