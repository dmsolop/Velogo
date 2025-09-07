import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import '../../data/models/route_logic/route_section.dart';
import '../../domain/entities/route_entity.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../../../../core/services/route_complexity_service.dart';
import '../../../../shared/base_colors.dart';
import '../../../../shared/base_widgets.dart';
import '../../../../shared/dev_helpers.dart';

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

  // Поля для системи складності
  double _routeDifficulty = 0.0;
  String _difficultyLevel = 'Помірний';
  Color _difficultyColor = Colors.orange;
  bool _isLoadingDifficulty = false;

  // Контролери для форми
  final TextEditingController _routeNameController = TextEditingController();
  final TextEditingController _routeDescriptionController = TextEditingController();

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
          _buildControlPanel(),
          _buildBottomPanel(),
        ],
      ),
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
                text: "Difficulty: ${_routeDifficulty.toStringAsFixed(2)}",
                fontSize: 14,
                color: BaseColors.white,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 2),
              CustomText(
                text: "Level: $_difficultyLevel",
                fontSize: 12,
                color: _difficultyColor,
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

  /// Розрахунок складності маршруту з використанням нового RouteComplexityService
  Future<void> _calculateRouteDifficulty() async {
    if (_sections.isEmpty) return;

    setState(() {
      _isLoadingDifficulty = true;
    });

    try {
      // Створюємо RouteEntity з поточних секцій
      final routeEntity = _createRouteEntityFromSections();

      // Отримуємо профіль користувача
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isLoadingDifficulty = false;
        });
        return;
      }

      // TODO: Отримати профіль користувача через ProfileRepository
      // Поки що створюємо базовий профіль
      final profile = ProfileEntity(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        fitnessLevel: 'intermediate', // TODO: Отримати з профілю
        age: 30, // TODO: Отримати з профілю
      );

      // Використовуємо новий RouteComplexityService
      final complexityService = RouteComplexityService();
      final result = await complexityService.calculateRouteComplexity(
        route: routeEntity,
        userProfile: profile,
        startTime: DateTime.now(),
        useHealthData: true,
      );

      result.fold(
        (failure) {
          // Обробка помилки
          setState(() {
            _isLoadingDifficulty = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Помилка розрахунку складності: ${failure.message}')),
          );
        },
        (complexityResult) {
          // Оновлюємо UI з результатами
          setState(() {
            _isLoadingDifficulty = false;
            _routeDifficulty = complexityResult.personalizedDifficulty;
            _difficultyLevel = complexityResult.difficultyLevel;
            _difficultyColor = Color(complexityResult.difficultyColor);
          });

          // Показуємо рекомендації
          final recommendations = complexityService.getRecommendations(complexityResult);
          if (recommendations.isNotEmpty) {
            _showRecommendationsDialog(recommendations);
          }
        },
      );
    } catch (e) {
      setState(() {
        _isLoadingDifficulty = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка: $e')),
      );
    }
  }

  /// Створення RouteEntity з поточних секцій
  RouteEntity _createRouteEntityFromSections() {
    final coordinates = <LatLng>[];
    final sections = <RouteSectionEntity>[];
    double totalDistance = 0.0;
    double totalElevationGain = 0.0;

    for (final section in _sections) {
      coordinates.addAll(section.coordinates);
      totalDistance += section.distance;
      totalElevationGain += section.elevationGain;

      // Створюємо RouteSectionEntity
      final routeSection = RouteSectionEntity(
        id: section.id,
        coordinates: section.coordinates,
        distance: section.distance,
        elevationGain: section.elevationGain,
        surfaceType: _mapToRoadSurfaceType(section.surfaceType),
        windEffect: section.windEffect,
        difficulty: section.difficulty,
        averageSpeed: section.averageSpeed,
        notes: section.notes,
      );
      sections.add(routeSection);
    }

    return RouteEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _routeNameController.text.isNotEmpty ? _routeNameController.text : 'Новий маршрут',
      description: _routeDescriptionController.text,
      coordinates: coordinates,
      totalDistance: totalDistance,
      totalElevationGain: totalElevationGain,
      averageDifficulty: _routeDifficulty,
      difficulty: _mapToRouteDifficulty(_difficultyLevel),
      sections: sections,
      pointsOfInterest: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Мапінг типу покриття
  RoadSurfaceType _mapToRoadSurfaceType(String surfaceType) {
    switch (surfaceType.toLowerCase()) {
      case 'asphalt':
        return RoadSurfaceType.asphalt;
      case 'concrete':
        return RoadSurfaceType.concrete;
      case 'gravel':
        return RoadSurfaceType.gravel;
      case 'dirt':
        return RoadSurfaceType.dirt;
      case 'cobblestone':
        return RoadSurfaceType.cobblestone;
      case 'grass':
        return RoadSurfaceType.grass;
      case 'sand':
        return RoadSurfaceType.sand;
      default:
        return RoadSurfaceType.asphalt;
    }
  }

  /// Мапінг рівня складності
  RouteDifficulty _mapToRouteDifficulty(String difficultyLevel) {
    switch (difficultyLevel) {
      case 'Легкий':
        return RouteDifficulty.easy;
      case 'Помірний':
        return RouteDifficulty.moderate;
      case 'Складний':
        return RouteDifficulty.hard;
      case 'Дуже складний':
      case 'Екстремальний':
        return RouteDifficulty.expert;
      default:
        return RouteDifficulty.moderate;
    }
  }

  /// Показ діалогу з рекомендаціями
  void _showRecommendationsDialog(List<String> recommendations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Рекомендації'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: recommendations
              .map((rec) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('• $rec'),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Зрозуміло'),
          ),
        ],
      ),
    );
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
    if (difficulty < 2.0) {
      return const Color(0xFF4CAF50); // Зелений
    } else if (difficulty < 4.0) {
      return const Color(0xFFFF9800); // Помаранчевий
    } else if (difficulty < 6.0) {
      return const Color(0xFFFF5722); // Червоний
    } else if (difficulty < 8.0) {
      return const Color(0xFF9C27B0); // Фіолетовий
    } else {
      return const Color(0xFF000000); // Чорний
    }
  }
}
