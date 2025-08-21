import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_entity.freezed.dart';

@freezed
class ProfileEntity with _$ProfileEntity {
  const factory ProfileEntity({
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
  }) = _ProfileEntity;
}
