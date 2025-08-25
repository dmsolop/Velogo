import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velogo/core/error/exceptions.dart';
import 'package:velogo/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String userId);
  Future<void> saveProfile(ProfileModel profile);
  Future<void> updateName(String userId, String name);
  Future<void> updateGender(String userId, String gender);
  Future<void> updateAge(String userId, int age);
  Future<void> updateAvatar(String userId, String avatarUrl);
  Future<void> updateFitnessLevel(String userId, String fitnessLevel);
  Future<void> updateHealthDataIntegration(String userId, bool enabled);
  Future<void> updateSyncStatus(String userId, String status);
  Future<void> addRecentActivity(String userId, String activity);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProfileRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      final doc = await firestore.collection('profiles').doc(userId).get();

      if (doc.exists) {
        return ProfileModel.fromJson(doc.data()!);
      } else {
        // Створюємо дефолтний профіль
        final defaultProfile = ProfileModel(
          id: userId,
          name: '',
          email: auth.currentUser?.email ?? '',
          gender: '',
          age: 0,
          avatarUrl: '',
          fitnessLevel: '',
          healthDataIntegration: false,
          syncStatus: 'Not connected',
          recentActivities: [],
          totalRides: 0,
          totalDistance: 0.0,
          totalTime: 0,
          lastActivity: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Зберігаємо дефолтний профіль
        await saveProfile(defaultProfile);
        return defaultProfile;
      }
    } catch (e) {
      throw ServerException('Failed to get profile: $e');
    }
  }

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    try {
      await firestore.collection('profiles').doc(profile.id).set(profile.toJson());
    } catch (e) {
      throw ServerException('Failed to save profile: $e');
    }
  }

  @override
  Future<void> updateName(String userId, String name) async {
    try {
      await firestore.collection('profiles').doc(userId).update({
        'name': name,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerException('Failed to update name: $e');
    }
  }

  @override
  Future<void> updateGender(String userId, String gender) async {
    try {
      await firestore.collection('profiles').doc(userId).update({
        'gender': gender,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerException('Failed to update gender: $e');
    }
  }

  @override
  Future<void> updateAge(String userId, int age) async {
    try {
      await firestore.collection('profiles').doc(userId).update({
        'age': age,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerException('Failed to update age: $e');
    }
  }

  @override
  Future<void> updateAvatar(String userId, String avatarUrl) async {
    try {
      await firestore.collection('profiles').doc(userId).update({
        'avatarUrl': avatarUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerException('Failed to update avatar: $e');
    }
  }

  @override
  Future<void> updateFitnessLevel(String userId, String fitnessLevel) async {
    try {
      await firestore.collection('profiles').doc(userId).update({
        'fitnessLevel': fitnessLevel,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerException('Failed to update fitness level: $e');
    }
  }

  @override
  Future<void> updateHealthDataIntegration(String userId, bool enabled) async {
    try {
      await firestore.collection('profiles').doc(userId).update({
        'healthDataIntegration': enabled,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerException('Failed to update health data integration: $e');
    }
  }

  @override
  Future<void> updateSyncStatus(String userId, String status) async {
    try {
      await firestore.collection('profiles').doc(userId).update({
        'syncStatus': status,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerException('Failed to update sync status: $e');
    }
  }

  @override
  Future<void> addRecentActivity(String userId, String activity) async {
    try {
      final doc = await firestore.collection('profiles').doc(userId).get();
      List<String> activities = [];

      if (doc.exists && doc.data()!.containsKey('recentActivities')) {
        activities = List<String>.from(doc.data()!['recentActivities']);
      }

      activities.insert(0, activity);
      if (activities.length > 10) {
        activities = activities.take(10).toList();
      }

      await firestore.collection('profiles').doc(userId).update({
        'recentActivities': activities,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerException('Failed to add recent activity: $e');
    }
  }
}

