import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/core/usecases/usecase.dart';
import 'package:velogo/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:velogo/features/profile/domain/usecases/save_profile_usecase.dart';
import 'package:velogo/features/profile/domain/usecases/update_name_usecase.dart';
import 'package:velogo/features/profile/domain/usecases/update_gender_usecase.dart';
import 'package:velogo/features/profile/domain/usecases/update_age_usecase.dart';
import 'package:velogo/features/profile/domain/usecases/update_health_data_integration_usecase.dart';
import 'package:velogo/features/profile/domain/usecases/clear_profile_cache_usecase.dart';
import 'package:velogo/features/profile/presentation/bloc/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfile;
  final SaveProfileUseCase saveProfile;
  final UpdateNameUseCase updateNameUseCase;
  final UpdateGenderUseCase updateGenderUseCase;
  final UpdateAgeUseCase updateAgeUseCase;
  final UpdateHealthDataIntegrationUseCase updateHealthDataIntegrationUseCase;
  final ClearProfileCacheUseCase clearProfileCacheUseCase;

  ProfileCubit({
    required this.getProfile,
    required this.saveProfile,
    required this.updateNameUseCase,
    required this.updateGenderUseCase,
    required this.updateAgeUseCase,
    required this.updateHealthDataIntegrationUseCase,
    required this.clearProfileCacheUseCase,
  }) : super(const ProfileState.initial());

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(const ProfileState.error(ServerFailure('User not authenticated')));
      return;
    }

    emit(const ProfileState.loading());

    final result = await getProfile(user.uid);
    result.fold(
      (failure) => emit(ProfileState.error(failure)),
      (profile) => emit(ProfileState.loaded(profile)),
    );
  }

  Future<void> updateName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await updateNameUseCase({'userId': user.uid, 'name': name});
    result.fold(
      (failure) => emit(ProfileState.error(failure)),
      (_) => loadProfile(), // Перезавантажуємо профіль після оновлення
    );
  }

  Future<void> updateGender(String gender) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await updateGenderUseCase({'userId': user.uid, 'gender': gender});
    result.fold(
      (failure) => emit(ProfileState.error(failure)),
      (_) => loadProfile(),
    );
  }

  Future<void> updateAge(int age) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await updateAgeUseCase({'userId': user.uid, 'age': age});
    result.fold(
      (failure) => emit(ProfileState.error(failure)),
      (_) => loadProfile(),
    );
  }

  Future<void> updateHealthDataIntegration(bool enabled) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await updateHealthDataIntegrationUseCase({'userId': user.uid, 'enabled': enabled});
    result.fold(
      (failure) => emit(ProfileState.error(failure)),
      (_) => loadProfile(),
    );
  }

  Future<void> clearProfileCache() async {
    final result = await clearProfileCacheUseCase(NoParams());
    result.fold(
      (failure) => emit(ProfileState.error(failure)),
      (_) => loadProfile(),
    );
  }
}
