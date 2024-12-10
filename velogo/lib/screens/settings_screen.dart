import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/base_colors.dart';
import '../shared/base_fonts.dart';
import '../shared/base_widgets.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final selectedTheme = <String>{
      themeProvider.isSystemTheme
          ? "system"
          : (themeProvider.isDarkTheme ? "dark" : "light")
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: BaseFonts.appBarTitle),
        backgroundColor: BaseColors.headerDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: BaseColors.iconLight),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: BaseColors.backgroundDark,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "App Preferences",
              style: BaseFonts.headingLarge,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BaseColors.cardBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Theme",
                    style: BaseFonts.headingMedium,
                  ),
                  const SizedBox(height: 8),
                  CustomSegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: "dark", label: Text("Dark")),
                      ButtonSegment(value: "light", label: Text("Light")),
                      ButtonSegment(value: "system", label: Text("System")),
                    ],
                    selected: selectedTheme,
                    onSelectionChanged: (newValue) {
                      final selected = newValue.first;
                      if (selected == "dark") {
                        themeProvider.setThemeMode(AppThemeMode.dark);
                      } else if (selected == "light") {
                        themeProvider.setThemeMode(AppThemeMode.light);
                      } else {
                        themeProvider.setThemeMode(AppThemeMode.system);
                      }
                    },
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
