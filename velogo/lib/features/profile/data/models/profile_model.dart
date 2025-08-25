import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:velogo/features/profile/domain/entities/profile_entity.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    @Default('') String id,
    @Default('') String name,
    @Default('') String email,
    @Default('') String gender,
    @Default(0) int age,
    @Default('') String avatarUrl,
    @Default('') String fitnessLevel,
    @Default(false) bool healthDataIntegration,
    @Default('') String syncStatus,
    @Default([]) List<String> recentActivities,
    @Default(0) int totalRides,
    @Default(0.0) double totalDistance,
    @Default(0) int totalTime,
    DateTime? lastActivity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
}

// Extension methods for conversion
extension ProfileModelExtension on ProfileModel {
  ProfileEntity toDomain() {
    return ProfileEntity(
      id: id,
      name: name,
      email: email,
      gender: gender,
      age: age,
      avatarUrl: avatarUrl,
      fitnessLevel: fitnessLevel,
      healthDataIntegration: healthDataIntegration,
      syncStatus: syncStatus,
      recentActivities: recentActivities,
      totalRides: totalRides,
      totalDistance: totalDistance,
      totalTime: totalTime,
      lastActivity: lastActivity ?? DateTime.now(),
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

extension ProfileEntityExtension on ProfileEntity {
  ProfileModel toModel() {
    return ProfileModel(
      id: id,
      name: name,
      email: email,
      gender: gender,
      age: age,
      avatarUrl: avatarUrl,
      fitnessLevel: fitnessLevel,
      healthDataIntegration: healthDataIntegration,
      syncStatus: syncStatus,
      recentActivities: recentActivities,
      totalRides: totalRides,
      totalDistance: totalDistance,
      totalTime: totalTime,
      lastActivity: lastActivity,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

