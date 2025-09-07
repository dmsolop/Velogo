import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';
import '../../../../shared/base_widgets.dart';
import '../../../../shared/base_colors.dart';
import '../../../../shared/dev_helpers.dart';
import '../../data/models/route_logic/route_section.dart';
import '../../../weather/data/datasources/weather_service.dart';
import '../../data/models/road_surface.dart';
import '../../../weather/data/models/weather_data.dart';
import 'create_route_screen.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  RouteScreenState createState() => RouteScreenState();
}

class RouteScreenState extends State<RouteScreen> {
  final List<RouteSection> _sections = [];
  final List<String> _interestingPlaces = ["Place A", "Place B", "Place C"];
  final defaultCenter = ReferenceValues.defaultMapCenter;
  LatLng? _lastPoint;

  // Нові поля для системи складності
  final WeatherService _weatherService = WeatherService();
  List<WeatherData> _weatherDataList = [];
  double _totalDifficulty = 0.0;
  bool _isLoadingDifficulty = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: BaseColors.headerDark,
        statusBarIconBrightness: Brightness.dark, // Елементи статус-бару світлі
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: defaultCenter,
                initialZoom: 10,
                onTap: (_, point) => _addRoutePoint(point),
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom, // Панорамування і масштабування
                  rotationThreshold: 25.0, // Менш чутливе обертання
                  pinchZoomThreshold: 1.0, // Збільшений поріг масштабування
                  scrollWheelVelocity: 0.01, // Плавне масштабування для мишки
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                PolylineLayer(
                  polylines: _generatePolylines(),
                ),
                MarkerLayer(
                  markers: _generateMarkers(),
                ),
              ],
            ),
            _buildSearchBar(),
            _buildInterestingPlaces(),
            _buildControlButtons(),
            _buildDraggableBottomPanel(),
          ],
        ),
        // bottomNavigationBar: CustomBottomNavigationBar(
        //   currentIndex: 0, // Індекс для цього екрану
        //   onTap: (index) {
        //     // Логіка навігації між екранами
        //   },
        //   isDarkTheme: null,
        // ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 8,
      right: 8,
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search by location or coordinates",
          fillColor: BaseColors.headerDark, // Колір кнопок
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          hintStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildInterestingPlaces() {
    return Positioned(
      left: 8,
      right: 8,
      bottom: 40 + 8, // Відступ до інформаційної панелі (8 пікселів)
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _interestingPlaces.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: MediaQuery.of(context).size.width - 64, // Ширина панелі
              decoration: BoxDecoration(
                color: BaseColors.headerDark, // Колір кнопок
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _interestingPlaces[index],
                  style: const TextStyle(color: BaseColors.white, fontSize: 16),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Positioned(
      right: 8,
      bottom: 40 + 100 + 8 + 8, // Відступ до колекції цікавих місць (8 пікселів)
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomFloatingButton(
            heroTag: '3DViewTag',
            onPressed: () {
              // Логіка для 3D View
            },
            icon: Icons.threed_rotation,
          ),
          const SizedBox(height: 8),
          CustomFloatingButton(
            heroTag: 'mapLaers1Tag',
            onPressed: () {
              // Логіка для шарів карти
            },
            icon: Icons.layers,
          ),
          const SizedBox(height: 8),
          CustomFloatingButton(
            heroTag: 'compas1Tag',
            onPressed: () {
              // Логіка для Compass
            },
            icon: Icons.explore,
          ),
          const SizedBox(height: 8),
          CustomRoundedButton(
            onPressed: () {
              try {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateRouteScreen(),
                  ),
                );
              } catch (e) {
                // TODO: Add proper logging
                // print("Navigation error: $e");
                // print(stackTrace);
              }
            },
            text: "Plan Route",
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableBottomPanel() {
    return DraggableScrollableSheet(
      initialChildSize: 0.05,
      minChildSize: 0.05,
      maxChildSize: 0.6,
      snap: true,
      snapSizes: const [0.05, 0.6],
      builder: (context, scrollController) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: BaseColors.backgroundDark.withValues(alpha: 0.9),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Text(
                "Total Distance: ${_calculateTotalDistance().toStringAsFixed(2)} km",
                style: const TextStyle(color: BaseColors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (_isLoadingDifficulty)
                const Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Calculating difficulty...",
                      style: TextStyle(color: BaseColors.white, fontSize: 14),
                    ),
                  ],
                )
              else ...[
                Text(
                  "Total Difficulty: ${_totalDifficulty.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: BaseColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Level: ${_getDifficultyLevel(_totalDifficulty)}",
                  style: TextStyle(
                    color: Color(_getDifficultyColor(_totalDifficulty)),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              if (_weatherDataList.isNotEmpty)
                Text(
                  "Weather Points: ${_weatherDataList.length}",
                  style: const TextStyle(color: BaseColors.white, fontSize: 12),
                ),
            ],
          ),
        );
      },
    );
  }

  void _addRoutePoint(LatLng point) async {
    if (_lastPoint != null) {
      final newSection = RouteSection(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        coordinates: [_lastPoint!, point],
        distance: _calculateDistance(_lastPoint!.latitude, _lastPoint!.longitude, point.latitude, point.longitude),
        elevationGain: _calculateElevationGain(_lastPoint!, point),
        surfaceType: "asphalt",
        windEffect: _calculateWindEffect(_lastPoint!, point),
        averageSpeed: 15.0,
      );
      setState(() {
        _sections.add(newSection);
      });

      // Розраховуємо складність з новою системою
      await _calculateRouteDifficulty();
    }
    _lastPoint = point;
  }

  List<Polyline> _generatePolylines() {
    return _sections.map((section) {
      final color = getColorBasedOnDifficulty(section.difficulty);
      return Polyline(
        points: section.coordinates,
        color: color,
        strokeWidth: 4,
      );
    }).toList();
  }

  List<Marker> _generateMarkers() {
    return [
      if (_lastPoint != null)
        Marker(
          point: _lastPoint!,
          child: const Icon(Icons.place, color: Colors.green),
        ),
    ];
  }

  double _calculateElevationGain(LatLng start, LatLng end) => 10;

  double _calculateTotalDistance() => _sections.fold(0, (sum, section) => sum + 1.0);

  double _calculateWindEffect(LatLng start, LatLng end) => 0.0;

  Color getColorBasedOnDifficulty(double difficulty) {
    final colorValue = _getDifficultyColor(difficulty);
    return Color(colorValue);
  }

  /// Отримання рівня складності (текстовий опис)
  String _getDifficultyLevel(double difficulty) {
    if (difficulty < 2.0) {
      return 'Легкий';
    } else if (difficulty < 4.0) {
      return 'Помірний';
    } else if (difficulty < 6.0) {
      return 'Складний';
    } else if (difficulty < 8.0) {
      return 'Дуже складний';
    } else {
      return 'Екстремальний';
    }
  }

  /// Отримання кольору складності
  int _getDifficultyColor(double difficulty) {
    if (difficulty < 2.0) {
      return 0xFF4CAF50; // Зелений
    } else if (difficulty < 4.0) {
      return 0xFFFF9800; // Помаранчевий
    } else if (difficulty < 6.0) {
      return 0xFFFF5722; // Червоний
    } else if (difficulty < 8.0) {
      return 0xFF9C27B0; // Фіолетовий
    } else {
      return 0xFF000000; // Чорний
    }
  }

  /// Розрахунок складності маршруту з використанням нової системи
  Future<void> _calculateRouteDifficulty() async {
    if (_sections.isEmpty) return;

    setState(() {
      _isLoadingDifficulty = true;
    });

    try {
      // Конвертуємо RouteSection в формат для RouteDifficultyService
      final routePoints = <Map<String, double>>[];
      final weatherDataList = <WeatherData>[];
      final roadSurfaces = <RoadSurface>[];

      for (final section in _sections) {
        for (final coordinate in section.coordinates) {
          routePoints.add({
            'lat': coordinate.latitude,
            'lon': coordinate.longitude,
            'elevation': section.elevationGain,
            'slope': _calculateSlope(section),
          });

          // Отримуємо погодні дані для цієї точки
          try {
            final weatherData = await _weatherService.getWeather(
              coordinate.latitude,
              coordinate.longitude,
            );

            final weather = WeatherData(
              lat: coordinate.latitude,
              lon: coordinate.longitude,
              windSpeed: weatherData['hourly']['wind_speed'][0].toDouble(),
              windDirection: weatherData['hourly']['wind_direction'][0].toDouble(),
              windGust: weatherData['hourly']['wind_gust'][0].toDouble(),
              precipitation: weatherData['hourly']['precipitation']?[0]?.toDouble() ?? 0.0,
              precipitationType: weatherData['hourly']['precipitation_type']?[0]?.toDouble() ?? 0.0,
              humidity: weatherData['hourly']['humidity']?[0]?.toDouble() ?? 50.0,
              temperature: weatherData['hourly']['temperature']?[0]?.toDouble() ?? 20.0,
              visibility: weatherData['hourly']['visibility']?[0]?.toDouble() ?? 10.0,
              roadCondition: 0.0,
              timestamp: DateTime.now(),
              source: "API",
            );

            weatherDataList.add(weather);
          } catch (e) {
            // Якщо не вдалося отримати погоду, використовуємо дефолтні дані
            weatherDataList.add(WeatherData(
              lat: coordinate.latitude,
              lon: coordinate.longitude,
              windSpeed: 5.0,
              windDirection: 0.0,
              windGust: 7.0,
              precipitation: 0.0,
              precipitationType: 0.0,
              humidity: 50.0,
              temperature: 20.0,
              visibility: 10.0,
              roadCondition: 0.0,
              timestamp: DateTime.now(),
              source: "Default",
            ));
          }

          // Визначаємо тип покриття
          roadSurfaces.add(_getRoadSurfaceFromString(section.surfaceType));
        }
      }

      // Розраховуємо загальну складність
      // TODO: Використовувати новий RouteComplexityService
      final difficulty = 0.0;

      setState(() {
        _totalDifficulty = difficulty;
        _weatherDataList = weatherDataList;
        _isLoadingDifficulty = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingDifficulty = false;
      });
      // TODO: Add proper logging
      // print('Error calculating route difficulty: $e');
    }
  }

  /// Розрахунок уклону для секції
  double _calculateSlope(RouteSection section) {
    if (section.coordinates.length < 2) return 0.0;

    // Спрощений розрахунок уклону
    final elevationGain = section.elevationGain;
    final distance = _calculateDistance(
      section.coordinates.first.latitude,
      section.coordinates.first.longitude,
      section.coordinates.last.latitude,
      section.coordinates.last.longitude,
    );

    if (distance == 0) return 0.0;

    // Конвертуємо в градуси
    return (elevationGain / (distance * 1000)) * 100; // Відсотки
  }

  /// Конвертація типу покриття з рядка в enum
  RoadSurface _getRoadSurfaceFromString(String surfaceType) {
    switch (surfaceType.toLowerCase()) {
      case 'asphalt':
        return RoadSurface.asphalt;
      case 'concrete':
        return RoadSurface.concrete;
      case 'gravel':
        return RoadSurface.gravel;
      case 'dirt':
        return RoadSurface.dirt;
      case 'mud':
        return RoadSurface.mud;
      default:
        return RoadSurface.asphalt;
    }
  }

  /// Розрахунок відстані між двома точками
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371.0; // км

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) + cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Конвертація градусів в радіани
  double _toRadians(double degrees) {
    return degrees * pi / 180.0;
  }
}
