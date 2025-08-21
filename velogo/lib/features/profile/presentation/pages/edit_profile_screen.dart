import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/base_colors.dart';
import '../../../../shared/base_fonts.dart';
import '../../../../shared/base_widgets.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/profile/profile_cubit.dart';
import '../bloc/profile/profile_state.dart';
import '../../domain/entities/profile_entity.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String nameValue = '';
  String ageValue = '';
  String selectedGender = 'Male';
  bool healthDataIntegration = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..loadProfile(),
      child: Scaffold(
        backgroundColor: BaseColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: BaseColors.headerDark,
          title: const Text(
            "Edit profile",
            style: BaseFonts.appBarTitle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: BaseColors.iconLight),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (profile) => _buildEditProfileContent(context, profile),
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

  Widget _buildEditProfileContent(BuildContext context, ProfileEntity profile) {
    final profileCubit = context.read<ProfileCubit>();
    // Ініціалізуємо змінні з профілю
    nameValue = profile.name;
    ageValue = profile.age > 0 ? profile.age.toString() : '';
    selectedGender = profile.gender.isNotEmpty ? profile.gender : 'Male';
    healthDataIntegration = profile.healthDataIntegration;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Аватар
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
          ),
          const SizedBox(height: 24),

          // Поле для введення імені
          CustomTextFieldWithLabel(
            label: "Name",
            hintText: "Enter your name",
            initialValue: nameValue,
            onChanged: (value) {
              setState(() {
                nameValue = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Поле для вибору статі
          CustomDropdown<String>(
            label: "Gender",
            hintText: "Select Gender",
            selectedValue: selectedGender,
            items: const ["Male", "Female", "Other"],
            itemLabelBuilder: (item) => item,
            onChanged: (value) {
              setState(() {
                selectedGender = value ?? 'Male';
              });
            },
          ),
          const SizedBox(height: 16),

          // Поле для віку
          CustomTextFieldWithLabel(
            label: "Age",
            hintText: "Enter your age",
            initialValue: ageValue,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                ageValue = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Перемикач Health Data Integration
          CustomSwitchTile(
            label: "Health Data Integration",
            value: healthDataIntegration,
            onChanged: (value) {
              setState(() {
                healthDataIntegration = value;
              });
            },
          ),
          const SizedBox(height: 24),

          // Кнопки дій
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: "Save Changes",
                  onPressed: () {
                    // Зберігаємо зміни
                    if (nameValue.isNotEmpty) {
                      profileCubit.updateName(nameValue);
                    }
                    if (ageValue.isNotEmpty) {
                      final age = int.tryParse(ageValue);
                      if (age != null && age > 0) {
                        profileCubit.updateAge(age);
                      }
                    }
                    profileCubit.updateGender(selectedGender);
                    profileCubit.updateHealthDataIntegration(healthDataIntegration);
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedCustomButton(
                  label: "Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                    print("Cancel Pressed");
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
