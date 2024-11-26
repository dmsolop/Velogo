import 'package:flutter/material.dart';
import '../shared/base_widgets.dart'; // Для CustomButton і OutlinedCustomButton
import '../shared/base_colors.dart'; // Стилі кольорів
import '../shared/base_fonts.dart'; // Стилі текстів
import '../shared/custom_bottom_navigation_bar.dart'; // Для CustomBottomNavigationBar

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

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
              "VELOGO",
              style: BaseFonts.appBarTitle,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: BaseColors.iconLight),
            onPressed: () {
              // Дія при натисканні
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                      'https://example.com/avatar.jpg'), // URL аватарки
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back,",
                      style: BaseFonts.bodyTextLight,
                    ),
                    Text(
                      "John Doe",
                      style: BaseFonts.bodyTextBold,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for routes",
                      prefixIcon:
                          const Icon(Icons.search, color: BaseColors.iconLight),
                      filled: true,
                      fillColor: BaseColors.inputBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon:
                      const Icon(Icons.filter_alt, color: BaseColors.iconLight),
                  onPressed: () {
                    // Дія при натисканні
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Welcome back, Alex!",
              style: BaseFonts.headingLarge,
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: "Plan the Route",
              onPressed: () {
                // Дія при натисканні
              },
            ),
            const SizedBox(height: 8),
            CustomButton(
              label: "Start Navigation",
              onPressed: () {
                // Дія при натисканні
              },
            ),
            const SizedBox(height: 8),
            OutlinedCustomButton(
              label: "Explore Historical Sites",
              onPressed: () {
                // Дія при натисканні
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "Featured Routes",
              style: BaseFonts.headingMedium,
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://example.com/route_image.jpg',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Upcoming Events",
              style: BaseFonts.headingMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BaseColors.cardBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "City Cycling Marathon",
                    style: BaseFonts.headingSmall,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Join us for a citywide marathon on November 20th.",
                    style: BaseFonts.bodyTextLight,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BaseColors.cardBackgroundDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mountain Biking Challenge",
                    style: BaseFonts.headingSmall,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Test your limits on December 5th in the mountains.",
                    style: BaseFonts.bodyTextLight,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, // Вкажи активний індекс
        onTap: (index) {
          // Логіка навігації між екранами
          print("Selected index: $index");
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import '../shared/base_widgets.dart'; // Для CustomButton
// import '../shared/base_colors.dart'; // Стилі кольорів
// import '../shared/base_fonts.dart'; // Стилі текстів
// import '../shared/custom_bottom_navigation_bar.dart'; // Для CustomBottomNavigationBar

// class MainScreen extends StatelessWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: BaseColors.backgroundDark,
//       appBar: AppBar(
//         backgroundColor: BaseColors.headerDark,
//         title: Row(
//           children: [
//             Icon(Icons.pedal_bike, color: BaseColors.iconLight),
//             const SizedBox(width: 8),
//             Text(
//               "VELOGO",
//               style: BaseFonts.appBarTitle,
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications, color: BaseColors.iconLight),
//             onPressed: () {
//               // Дія при натисканні
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 24,
//                   backgroundImage: NetworkImage('https://example.com/avatar.jpg'), // URL аватарки
//                 ),
//                 const SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Welcome back,",
//                       style: BaseFonts.bodyTextLight,
//                     ),
//                     Text(
//                       "John Doe",
//                       style: BaseFonts.bodyTextBold,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: "Search for routes",
//                       prefixIcon: Icon(Icons.search, color: BaseColors.iconLight),
//                       filled: true,
//                       fillColor: BaseColors.inputBackground,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: Icon(Icons.filter_alt, color: BaseColors.iconLight),
//                   onPressed: () {
//                     // Дія при натисканні
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             Text(
//               "Welcome back, Alex!",
//               style: BaseFonts.headingLarge,
//             ),
//             const SizedBox(height: 16),
//             CustomButton(
//               label: "Plan the Route",
//               onPressed: () {
//                 // Дія при натисканні
//               },
//             ),
//             const SizedBox(height: 8),
//             CustomButton(
//               label: "Start Navigation",
//               onPressed: () {
//                 // Дія при натисканні
//               },
//             ),
//             const SizedBox(height: 8),
//             OutlinedButton(
//               onPressed: () {
//                 // Дія при натисканні
//               }, child: 
//               ,
//             ),
//             const SizedBox(height: 24),
//             Text(
//               "Featured Routes",
//               style: BaseFonts.headingMedium,
//             ),
//             const SizedBox(height: 8),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 'https://example.com/route_image.jpg',
//                 height: 150,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               "Upcoming Events",
//               style: BaseFonts.headingMedium,
//             ),
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: BaseColors.cardBackground,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "City Cycling Marathon",
//                     style: BaseFonts.headingSmall,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "Join us for a citywide marathon on November 20th.",
//                     style: BaseFonts.bodyTextLight,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: BaseColors.cardBackgroundDark,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Mountain Biking Challenge",
//                     style: BaseFonts.headingSmall,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "Test your limits on December 5th in the mountains.",
//                     style: BaseFonts.bodyTextLight,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: 0, // Вкажи активний індекс
//         onTap: (index) {
//           // Логіка навігації між екранами
//           print("Selected index: $index");
//         },
//       ),
//     );
//   }
// }

