// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileModelImpl _$$ProfileModelImplFromJson(Map<String, dynamic> json) =>
    _$ProfileModelImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      age: (json['age'] as num?)?.toInt() ?? 0,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      fitnessLevel: json['fitnessLevel'] as String? ?? '',
      healthDataIntegration: json['healthDataIntegration'] as bool? ?? false,
      syncStatus: json['syncStatus'] as String? ?? '',
      recentActivities: (json['recentActivities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      totalRides: (json['totalRides'] as num?)?.toInt() ?? 0,
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0.0,
      totalTime: (json['totalTime'] as num?)?.toInt() ?? 0,
      lastActivity: json['lastActivity'] == null
          ? null
          : DateTime.parse(json['lastActivity'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProfileModelImplToJson(_$ProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'gender': instance.gender,
      'age': instance.age,
      'avatarUrl': instance.avatarUrl,
      'fitnessLevel': instance.fitnessLevel,
      'healthDataIntegration': instance.healthDataIntegration,
      'syncStatus': instance.syncStatus,
      'recentActivities': instance.recentActivities,
      'totalRides': instance.totalRides,
      'totalDistance': instance.totalDistance,
      'totalTime': instance.totalTime,
      'lastActivity': instance.lastActivity?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
