import 'package:flutter/material.dart';
import '../shared/base_widgets.dart';
import '../shared/base_colors.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.background,
      body: Stack(
        children: [
          // Карта (заглушка)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://via.placeholder.com/800x600',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Кнопка назад
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: BaseColors.primary,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: BaseColors.white),
                  onPressed: () {
                    print('Back button pressed');
                  },
                ),
              ),
            ),
          ),

          // Панель "Route Details"
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 200),
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: BaseColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок і кнопка Collapse
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Route Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: BaseColors.white,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: ProportionalButton(
                          label: 'Collapse',
                          onPressed: () {
                            print('Collapse pressed');
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Інформація про маршрут
                  const Text(
                    'Distance: 24 miles',
                    style: TextStyle(fontSize: 14, color: BaseColors.white),
                  ),
                  const Text(
                    'Estimated Time: 1h 45m',
                    style: TextStyle(fontSize: 14, color: BaseColors.white),
                  ),

                  const SizedBox(height: 16),

                  // Графік маршруту (заглушка)
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.black,
                    child: const Center(
                      child: Text(
                        'Route Graph Placeholder',
                        style: TextStyle(fontSize: 12, color: BaseColors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Кнопки управління в один ряд із пропорційним текстом
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ProportionalButton(
                          label: 'Start Navigation',
                          onPressed: () {
                            print('Start Navigation pressed');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ProportionalButton(
                          label: 'Add Stop',
                          onPressed: () {
                            print('Add Stop pressed');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ProportionalButton(
                          label: 'Save',
                          onPressed: () {
                            print('Save pressed');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ProportionalButton(
                          label: 'Share',
                          onPressed: () {
                            print('Share pressed');
                          },
                        ),
                      ),
                    ],
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
