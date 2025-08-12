import 'package:flutter/material.dart';
import '../../../../shared/base_widgets.dart'; // Для CustomButton
import '../../../../shared/base_colors.dart'; // Для кольорів
import '../../../../shared/base_fonts.dart'; // Для шрифтів

class MyRoutesScreen extends StatelessWidget {
  const MyRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> routes = [
      {"title": "Mountain Adventure", "description": "Explore the breathtaking mountain views."},
      {"title": "City Cycling Tour", "description": "Discover hidden gems in the city."},
      {"title": "Coastal Route", "description": "Enjoy a scenic ride along the coast."},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseColors.headerDark,
        title: const Text(
          "My Routes",
          style: BaseFonts.appBarTitle,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final route = routes[index];
          return Card(
            color: BaseColors.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route['title']!,
                    style: BaseFonts.headingMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    route['description']!,
                    style: BaseFonts.bodyTextLight,
                  ),
                  const SizedBox(height: 12.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CustomButton(
                      label: "View Details",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RouteDetailsScreen(
                              title: route['title']!,
                              description: route['description']!,
                            ),
                          ),
                        );
                      },
                      width: 150,
                      height: 40,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RouteDetailsScreen extends StatelessWidget {
  final String title;
  final String description;

  const RouteDetailsScreen({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseColors.headerDark,
        title: Text(
          title,
          style: BaseFonts.appBarTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: BaseFonts.headingLarge,
            ),
            const SizedBox(height: 16.0),
            Text(
              description,
              style: BaseFonts.bodyText,
            ),
            const SizedBox(height: 24.0),
            CustomButton(
              label: "Start Route",
              onPressed: () {
                // TODO: Implement route start functionality
                Navigator.pop(context);
              },
              width: double.infinity,
              height: 56,
            ),
          ],
        ),
      ),
    );
  }
}
