import 'package:flutter/material.dart';
import '../../../../shared/base_colors.dart';
import '../../../../shared/base_fonts.dart';
import '../../../../shared/base_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
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
                    const Text(
                      "Alex Johnson",
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
                  const CompactLabelRow(
                    label: "Gender",
                    value: "Male",
                  ),
                  const SizedBox(height: 8),
                  const CompactLabelRow(
                    label: "Age",
                    value: "55",
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sync Status",
                          style: BaseFonts.bodyTextLight,
                        ),
                        Text(
                          "Connected",
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
            const SizedBox(
              width: double.infinity,
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fitness Level",
                      style: BaseFonts.headingMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Moderate - Keep up the great work!",
                      style: BaseFonts.bodyTextLight,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Recent Activity",
                      style: BaseFonts.headingMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Mountain Ride - 20km - 1hr 15min",
                      style: BaseFonts.bodyTextLight,
                    ),
                    Text(
                      "City Tour - 15km - 45min",
                      style: BaseFonts.bodyTextLight,
                    ),
                    Text(
                      "Trail Adventure - 30km - 2hr",
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
                        // Дія для очищення кешу
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
