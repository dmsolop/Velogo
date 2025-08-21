import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/base_colors.dart';
import '../../../../shared/base_fonts.dart';
import '../../../../shared/base_widgets.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/profile/profile_cubit.dart';
import '../bloc/profile/profile_state.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..loadProfile(),
      child: Scaffold(
        backgroundColor: BaseColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: BaseColors.headerDark,
          title: const Row(
            children: [
              Icon(Icons.pedal_bike, color: BaseColors.iconLight),
              SizedBox(width: 8),
              Text(
                "Velogo",
                style: BaseFonts.appBarTitle,
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: BaseColors.iconLight),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (profile) => _buildProfileContent(context, profile),
              error: (failure) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${failure.message}'),
                    ElevatedButton(
                      onPressed: () => context.read<ProfileCubit>().loadProfile(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileEntity profile) {
    final profileCubit = context.read<ProfileCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: Image.asset(
                      'assets/images/avatar.png',
                      // width: 50,
                      // height: 50,
                      fit: BoxFit.cover, // Масштабування
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.name.isNotEmpty ? profile.name : "User",
                    style: BaseFonts.headingLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomCard(
            child: Column(
              children: [
                CompactLabelRow(
                  label: "Gender",
                  value: profile.gender.isNotEmpty ? profile.gender : "Not specified",
                ),
                const SizedBox(height: 8),
                CompactLabelRow(
                  label: "Age",
                  value: profile.age > 0 ? profile.age.toString() : "Not specified",
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: "Edit Personal Information",
                  onPressed: () {
                    // Дія при натисканні
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CustomCard(
              child: Column(
                children: [
                  OutlinedCustomButton(
                    label: "Change Password",
                    onPressed: () {
                      // Дія при натисканні
                    },
                  ),
                  const SizedBox(height: 8),
                  OutlinedCustomButton(
                    label: "Notification Preferences",
                    onPressed: () {
                      // Дія при натисканні
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                    label: "Connect to Health Apps",
                    onPressed: () {
                      // Дія для підключення до Health Apps
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Sync Status",
                        style: BaseFonts.bodyTextLight,
                      ),
                      Text(
                        profile.syncStatus.isNotEmpty ? profile.syncStatus : "Not connected",
                        style: BaseFonts.bodyTextBold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    label: "Energy & Performance Settings",
                    onPressed: () {
                      // Дія для налаштувань продуктивності
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Fitness Level",
                    style: BaseFonts.headingMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.fitnessLevel.isNotEmpty ? profile.fitnessLevel : "Not specified",
                    style: BaseFonts.bodyTextLight,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Recent Activity",
                    style: BaseFonts.headingMedium,
                  ),
                  const SizedBox(height: 8),
                  if (profile.recentActivities.isNotEmpty)
                    ...profile.recentActivities.take(3).map((activity) => Text(
                          activity,
                          style: BaseFonts.bodyTextLight,
                        ))
                  else
                    const Text(
                      "No recent activities",
                      style: BaseFonts.bodyTextLight,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Privacy Controls",
                      style: BaseFonts.headingMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedCustomButton(
                    label: "Data Sharing Settings",
                    onPressed: () {
                      // Дія для налаштувань приватності
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    label: "Clear Cache",
                    onPressed: () {
                      profileCubit.clearProfileCache();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
