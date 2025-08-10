import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';
import '../route_logic/route_section.dart';
import '../services/route_difficulty_service.dart';
import '../features/weather/data/datasources/weather_service.dart';
import '../models/road_surface.dart';
import '../features/weather/data/models/weather_data.dart';
import '../shared/base_colors.dart';
import '../shared/base_widgets.dart';
import '../shared/dev_helpers.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({Key? key}) : super(key: key);

  @override
  _CreateRouteScreenState createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen> {
  final List<RouteSection> _sections = [];
  final defaultCenter = ReferenceValues.defaultMapCenter;
  LatLng? _lastPoint;
  bool _isDrawingMode = false;

  // Нові поля для системи складності
  final RouteDifficultyService _routeDifficultyService = RouteDifficultyService();
  final WeatherService _weatherService = WeatherService();
  double _totalDifficulty = 0.0;
  bool _isLoadingDifficulty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Route",
          style: TextStyle(
            color: BaseColors.white,
          ),
        ),
        backgroundColor: BaseColors.background,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: BaseColors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: /* Center(child: Text("This is Create Route Screen")) */
          Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: defaultCenter,
              initialZoom: 10,
              onTap: (_, point) => _isDrawingMode ? _addRoutePoint(point) : _addInterestPoint(point),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              PolylineLayer(
                polylines: _generatePolylines(),
              ),
              MarkerLayer(
                markers: _generateMarkers(),
              ),
            ],
          ),
          _buildControlPanel(),
          _buildBottomPanel(),
        ],
      ),
    );
  }

  void _addRoutePoint(LatLng point) async {
    if (_lastPoint != null) {
      final newSection = RouteSection(
        coordinates: [_lastPoint!, point],
        elevationGain: _calculateElevationGain(_lastPoint!, point),
        surfaceType: "asphalt",
        windEffect: _calculateWindEffect(_lastPoint!, point),
      );
      setState(() {
        _sections.add(newSection);
      });

      // Розраховуємо складність з новою системою
      await _calculateRouteDifficulty();
    }
    _lastPoint = point;
  }

  void _addInterestPoint(LatLng point) {
    // TODO: Implement interest point logic
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
      for (var section in _sections)
        Marker(
          point: section.coordinates.last,
          child: const Icon(Icons.flag, color: Colors.red),
        ),
    ];
  }

  Widget _buildControlPanel() {
    return Positioned(
      right: 16,
      // top: 100,
      bottom: 160,
      child: Column(
        children: [
          const SizedBox(height: 8),
          CustomFloatingButton(
            heroTag: 'mapLayers2Tag',
            onPressed: () {
              setState(() {});
              // Логіка для шарів карти
            },
            icon: Icons.layers,
          ),
          const SizedBox(height: 8),
          CustomFloatingButton(
            heroTag: 'compas2Tag',
            onPressed: () {
              setState(() {});
              // Логіка для Compass
            },
            icon: Icons.explore,
          ),
          const SizedBox(height: 8),
          // CustomFloatingButton(
          //   heroTag: 'completeRouteNavigateBackTag',
          //   onPressed: () {
          //     // Add the logic to finish the route or navigate back.
          //     Navigator.pop(context);
          //   },
          //   icon: Icons.check,
          // ),
          const SizedBox(height: 8),
          CustomFloatingButton(
            heroTag: 'createRouteAndBackTag',
            onPressed: () {
              setState(() {});
              // Логіка для cтворення маршруту
            },
            icon: Icons.create,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BaseColors.backgroundDark.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "Total Distance: ${_calculateTotalDistance().toStringAsFixed(2)} km",
              fontSize: 14,
              color: BaseColors.white,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: "Elevation Gain: ${_sections.fold(0.0, (sum, s) => sum + s.elevationGain)} m",
              fontSize: 14,
              color: BaseColors.white,
            ),
            const SizedBox(height: 4),
            if (_isLoadingDifficulty)
              const Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Calculating difficulty...",
                    style: TextStyle(color: BaseColors.white, fontSize: 12),
                  ),
                ],
              )
            else ...[
              CustomText(
                text: "Difficulty: ${_totalDifficulty.toStringAsFixed(2)}",
                fontSize: 14,
                color: BaseColors.white,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 2),
              CustomText(
                text: "Level: ${_routeDifficultyService.getDifficultyLevel(_totalDifficulty)}",
                fontSize: 12,
                color: Color(_routeDifficultyService.getDifficultyColor(_totalDifficulty)),
                fontWeight: FontWeight.w500,
              ),
            ],
          ],
        ),
      ),
    );
  }

  double _calculateElevationGain(LatLng start, LatLng end) => 10;

  double _calculateWindEffect(LatLng start, LatLng end) => -2;

  double _calculateTotalDistance() => _sections.fold(0, (sum, section) => sum + 1.0);

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
      final difficulty = _routeDifficultyService.calculateRouteDifficulty(
        weatherDataList,
        roadSurfaces,
        routePoints,
        DateTime.now(),
      );

      setState(() {
        _totalDifficulty = difficulty;
        _isLoadingDifficulty = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingDifficulty = false;
      });
      print('Error calculating route difficulty: $e');
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

  Color getColorBasedOnDifficulty(double difficulty) {
    final colorValue = _routeDifficultyService.getDifficultyColor(difficulty);
    return Color(colorValue);
  }
}
