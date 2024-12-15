import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../shared/base_widgets.dart';
import '../shared/base_colors.dart';
import '../shared/base_fonts.dart';
import '../bloc/theme/theme_cubit.dart';
import '../bloc/settings/settings_cubit.dart';
import '../bloc/settings/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

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
                      return CustomSwitchTile(
                        label: "Voice Instructions",
                        value: state.voiceInstructions,
                        onChanged: settingsCubit.toggleVoiceInstructions,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return CustomDropdown<String>(
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
                      return CustomDropdown<String>(
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
                      return CustomSwitchTile(
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
                      return CustomSwitchTile(
                        label: "Route Alerts",
                        value: state.routeAlerts,
                        onChanged: settingsCubit.toggleRouteAlerts,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return CustomSwitchTile(
                        label: "Weather Alerts",
                        value: state.weatherAlerts,
                        onChanged: settingsCubit.toggleWeatherAlerts,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return CustomSwitchTile(
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
                      return CustomSwitchTile(
                        label: "Health Data Integration",
                        value: state.healthDataIntegration,
                        onChanged: settingsCubit.toggleHealthDataIntegration,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    label: "Edit",
                    onPressed: () {
                      // TODO: Implement Manual Input Edit
                      print("Manual Input Options Pressed");
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Privacy and Security
            const CustomSectionTitle(title: "Privacy and Security"),
            CustomCard(
              child: Column(
                children: [
                  CustomTextLink(
                    text: "Data Sharing Preferences",
                    onTap: () => print("Data Sharing Preferences Pressed"),
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    label: "Clear Cache",
                    onPressed: () => print("Clear Cache Pressed"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Help & Support
            const CustomSectionTitle(title: "Help & Support"),
            CustomCard(
              child: Column(
                children: [
                  CustomTextLink(
                      text: "FAQ Section",
                      onTap: () => print("FAQ Section Pressed")),
                  CustomTextLink(
                      text: "Contact Support",
                      onTap: () => print("Contact Support Pressed")),
                  CustomTextLink(
                      text: "User Guide",
                      onTap: () => print("User Guide Pressed")),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Legal & Terms
            const CustomSectionTitle(title: "Legal & Terms"),
            CustomCard(
              child: Column(
                children: [
                  CustomTextLink(
                      text: "Terms of Service",
                      onTap: () => print("Terms of Service Pressed")),
                  CustomTextLink(
                      text: "Privacy Policy",
                      onTap: () => print("Privacy Policy Pressed")),
                ],
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
                  const SizedBox(height: 8),
                  CustomButton(
                      label: "Terms and Conditions",
                      onPressed: () => print("Terms Pressed")),
                  const SizedBox(height: 8),
                  CustomButton(
                      label: "Privacy Policy",
                      onPressed: () => print("Privacy Policy Pressed")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../shared/base_widgets.dart';
// import '../shared/base_colors.dart';
// import '../shared/base_fonts.dart';
// import '../bloc/theme/theme_cubit.dart';
// import '../bloc/settings/settings_cubit.dart';
// import '../bloc/settings/settings_state.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final settingsCubit = context.read<SettingsCubit>();

//     return Scaffold(
//       backgroundColor: BaseColors.backgroundDark,
//       appBar: AppBar(
//         backgroundColor: BaseColors.headerDark,
//         title: const Text(
//           "Settings",
//           style: BaseFonts.appBarTitle,
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Navigation Settings
//             const CustomSectionTitle(title: "Navigation Settings"),
//             CustomCard(
//               child: Column(
//                 children: [
//                   BlocBuilder<SettingsCubit, SettingsState>(
//                     builder: (context, state) {
//                       return CustomSwitchTile(
//                         label: "Voice Instructions",
//                         value: state.voiceInstructions,
//                         onChanged: (value) {
//                           settingsCubit.toggleVoiceInstructions(value);
//                           print("Voice Instructions: $value");
//                         },
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 8),
//                   BlocBuilder<SettingsCubit, SettingsState>(
//                     builder: (context, state) {
//                       return CustomDropdown<String>(
//                         label: "Units of Measurement",
//                         hintText: "Select Unit",
//                         selectedValue: state.unitsOfMeasurement,
//                         items: const ["Metric", "Imperial"],
//                         itemLabelBuilder: (item) => item,
//                         onChanged: (value) {
//                           if (value != null) {
//                             settingsCubit.changeUnitsOfMeasurement(value);
//                             print("Units: $value");
//                           }
//                         },
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 8),
//                   BlocBuilder<SettingsCubit, SettingsState>(
//                     builder: (context, state) {
//                       return CustomDropdown<String>(
//                         label: "Map Style",
//                         hintText: "Select Style",
//                         selectedValue: state.mapStyle,
//                         items: const ["Terrain", "Satellite", "Hybrid"],
//                         itemLabelBuilder: (item) => item,
//                         onChanged: (value) {
//                           if (value != null) {
//                             settingsCubit.changeMapStyle(value);
//                             print("Map Style: $value");
//                           }
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),

//             // App Preferences
//             const CustomSectionTitle(title: "App Preferences"),
//             CustomCard(
//               child: Column(
//                 children: [
//                   BlocBuilder<ThemeCubit, AppThemeMode>(
//                     builder: (context, themeMode) {
//                       return CustomSegmentedButton<AppThemeMode>(
//                         segments: const [
//                           ButtonSegment(
//                               value: AppThemeMode.system,
//                               label: Text("System")),
//                           ButtonSegment(
//                               value: AppThemeMode.light, label: Text("Light")),
//                           ButtonSegment(
//                               value: AppThemeMode.dark, label: Text("Dark")),
//                         ],
//                         selected: {themeMode},
//                         onSelectionChanged: (value) {
//                           context.read<ThemeCubit>().setTheme(value.first);
//                           print("Theme Changed: ${value.first}");
//                         },
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 8),
//                   BlocBuilder<SettingsCubit, SettingsState>(
//                     builder: (context, state) {
//                       return CustomSwitchTile(
//                         label: "Notifications",
//                         value: state.notifications,
//                         onChanged: (value) {
//                           settingsCubit.toggleNotifications(value);
//                           print("Notifications: $value");
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Privacy and Security
//             const CustomSectionTitle(title: "Privacy and Security"),
//             CustomCard(
//               child: Column(
//                 children: [
//                   CustomTextLink(
//                     text: "Data Sharing Preferences",
//                     onTap: () {
//                       // TODO: Implement Data Sharing Preferences Navigation
//                       print("Data Sharing Preferences Pressed");
//                     },
//                   ),
//                   const SizedBox(height: 8),
//                   CustomButton(
//                     label: "Clear Cache",
//                     onPressed: () {
//                       // TODO: Implement Clear Cache Functionality
//                       print("Clear Cache Pressed");
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }

