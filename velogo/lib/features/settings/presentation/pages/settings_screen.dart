import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/base_widgets.dart';
import '../../../../shared/base_colors.dart';
import '../../../../shared/base_fonts.dart';
import '../../../navigation/presentation/bloc/theme/theme_cubit.dart';
import '../bloc/settings/settings_cubit.dart';
import '../bloc/settings/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();

    return Scaffold(
      backgroundColor: BaseColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: BaseColors.headerDark,
        title: const Text(
          "Settings",
          style: BaseFonts.appBarTitle,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Navigation Settings
            const CustomSectionTitle(title: "Navigation Settings"),
            CustomCard(
              child: Column(
                children: [
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return CustomToggleTile(
                        label: "Voice Instructions",
                        value: state.voiceInstructions,
                        onChanged: settingsCubit.toggleVoiceInstructions,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return CompactDropdown<String>(
                        label: "Units of Measurement",
                        hintText: "Select Unit",
                        selectedValue: state.unitsOfMeasurement,
                        items: const ["Metric", "Imperial"],
                        itemLabelBuilder: (item) => item,
                        onChanged: (value) {
                          if (value != null) {
                            settingsCubit.changeUnitsOfMeasurement(value);
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return CompactDropdown<String>(
                        label: "Map Style",
                        hintText: "Select Style",
                        selectedValue: state.mapStyle,
                        items: const ["Terrain", "Satellite", "Hybrid"],
                        itemLabelBuilder: (item) => item,
                        onChanged: (value) {
                          if (value != null) {
                            settingsCubit.changeMapStyle(value);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // App Preferences
            const CustomSectionTitle(title: "App Preferences"),
            CustomCard(
              child: Column(
                children: [
                  BlocBuilder<ThemeCubit, AppThemeMode>(
                    builder: (context, themeMode) {
                      return CustomSegmentedButton<AppThemeMode>(
                        segments: const [
                          ButtonSegment(
                              value: AppThemeMode.system,
                              label: Text("System")),
                          ButtonSegment(
                              value: AppThemeMode.light, label: Text("Light")),
                          ButtonSegment(
                              value: AppThemeMode.dark, label: Text("Dark")),
                        ],
                        selected: {themeMode},
                        onSelectionChanged: (value) =>
                            context.read<ThemeCubit>().setTheme(value.first),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return CustomToggleTile(
                        label: "Notifications",
                        value: state.notifications,
                        onChanged: settingsCubit.toggleNotifications,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Notification Preferences
            const CustomSectionTitle(title: "Notification Preferences"),
            CustomCard(
              child: Column(
                children: [
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return CustomToggleTile(
                        label: 'Route Alerts',
                        value: state.routeAlerts,
                        onChanged: settingsCubit.toggleRouteAlerts,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return CustomToggleTile(
                        label: "Weather Alerts",
                        value: state.weatherAlerts,
                        onChanged: settingsCubit.toggleWeatherAlerts,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return CustomToggleTile(
                        label: "General Notifications",
                        value: state.generalNotifications,
                        onChanged: settingsCubit.toggleGeneralNotifications,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Energy Expenditure Settings
            const CustomSectionTitle(title: "Energy Expenditure Settings"),
            CustomCard(
              child: Column(
                children: [
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return CustomToggleTile(
                        label: "Health Data Integration",
                        value: state.healthDataIntegration,
                        onChanged: settingsCubit.toggleHealthDataIntegration,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CompactElevatedButtonRow(
                    label: 'Manual Input Options',
                    buttonText: 'Edit',
                    onPressed: () {
                      // TODO: Implement Manual Input Edit
                      print('Manual Input Options Pressed');
                    },
                    borderColor: BaseColors.grey,
                    backgroundColor: BaseColors.headerDark,
                    borderWidth: 2.0,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Privacy and Security
            const CustomSectionTitle(title: "Privacy and Security"),
            SizedBox(
              width: double.infinity,
              child: CustomCard(
                child: Column(
                  children: [
                    CompactElevatedButtonRow(
                      label: 'Data Sharing Preferences',
                      buttonText: 'Manage',
                      onPressed: () {
                        // TODO: Implement Data Sharing Preferences Edit
                        print('Data Sharing Preferences Pressed');
                      },
                      borderColor: BaseColors.grey,
                      backgroundColor: BaseColors.headerDark,
                      borderWidth: 2.0,
                    ),
                    const SizedBox(height: 16),
                    CompactElevatedButtonRow(
                      label: 'Clear Cache',
                      buttonText: 'Clear',
                      onPressed: () {
                        // TODO: Implement Clear Cache Edit
                        print('Clear Cache Pressed');
                      },
                      borderColor: BaseColors.grey,
                      backgroundColor: BaseColors.headerDark,
                      borderWidth: 2.0,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Help & Support
            const CustomSectionTitle(title: "Help & Support"),
            SizedBox(
              width: double.infinity,
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextLink(
                        text: "FAQ Section",
                        onTap: () {
                          // TODO: Implement FAQ Section Edit
                          print("FAQ Section Pressed");
                        }),
                    const SizedBox(height: 16),
                    CustomTextLink(
                      text: "Contact Support",
                      onTap: () {
                        // TODO: Implement Contact Support Edit
                        print("Contact Support Pressed");
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextLink(
                        text: "User Guide",
                        onTap: () {
                          // TODO: Implement User Guide Edit
                          print("User Guide Pressed");
                        }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Legal & Terms
            const CustomSectionTitle(title: "Legal & Terms"),
            SizedBox(
              width: double.infinity,
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextLink(
                        text: "Terms of Service",
                        onTap: () {
                          // TODO: Implement Terms of Service Edit
                          print("Terms of Service Pressed");
                        }),
                    const SizedBox(height: 16),
                    CustomTextLink(
                        text: "Privacy Policy",
                        onTap: () {
                          // TODO: Implement Privacy Policy Edit
                          print("Privacy Policy Pressed");
                        }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // About the App
            const CustomSectionTitle(title: "About the App"),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomKeyValue(
                      keyText: "Version Information", valueText: "v1.0"),
                  const SizedBox(height: 16),
                  CompactElevatedButtonRow(
                    label: 'Terms and Conditions',
                    buttonText: 'View',
                    onPressed: () {
                      // TODO: Implement Terms Edit
                      print("Terms Pressed");
                    },
                    borderColor: BaseColors.grey,
                    backgroundColor: BaseColors.headerDark,
                    borderWidth: 2.0,
                  ),
                  const SizedBox(height: 16),
                  CompactElevatedButtonRow(
                    label: 'Privacy Policy',
                    buttonText: 'View',
                    onPressed: () {
                      // TODO: Implement Privacy Policy Edit
                      print("Privacy Policy Pressed");
                    },
                    borderColor: BaseColors.grey,
                    backgroundColor: BaseColors.headerDark,
                    borderWidth: 2.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
