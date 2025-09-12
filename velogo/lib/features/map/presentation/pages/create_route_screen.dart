import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/route_logic/route_section.dart';
import '../../domain/entities/route_entity.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../../../../core/services/route_complexity_service.dart';
import '../../../../shared/base_colors.dart';
import '../../../../shared/base_widgets.dart';
import '../../../../shared/dev_helpers.dart';
import '../../../../core/services/adaptive_map_options.dart';
import '../../../../core/services/map_context_service.dart';
import '../../../../core/services/road_routing_service.dart';
import '../../../../core/services/offline_tile_provider.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  CreateRouteScreenState createState() => CreateRouteScreenState();
}

class CreateRouteScreenState extends State<CreateRouteScreen> {
  final List<RouteSection> _sections = [];
  final defaultCenter = ReferenceValues.defaultMapCenter;
  LatLng? _lastPoint;
  bool _isDrawingMode = true;

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
            options: _createAdaptiveMapOptionsWithTap(),
            children: [
              TileLayer(
                tileProvider: OfflineTileProvider(),
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
      // Розраховуємо маршрут по дорогах між точками
      final routeCoordinates = await RoadRoutingService.calculateRoute(
        startPoint: _lastPoint!,
        endPoint: point,
        profile: 'driving-car', // Можна змінити на 'cycling-regular' для велосипедів
      );

      // Завжди створюємо нову секцію для кожної ділянки маршруту
      // Це забезпечує правильне відображення маршруту по дорогах
      final newSection = RouteSection(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        coordinates: routeCoordinates,
        distance: RoadRoutingService.calculateRouteDistance(routeCoordinates),
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
    final markers = <Marker>[];

    // Додаємо маркер для початкової точки (якщо є)
    if (_sections.isNotEmpty) {
      markers.add(
        Marker(
          point: _sections.first.coordinates.first,
          child: const Icon(Icons.place, color: Colors.green, size: 32),
        ),
      );
    }

    // Додаємо маркери для кінцевих точок секцій
    for (int i = 0; i < _sections.length; i++) {
      final section = _sections[i];
      final isLastSection = i == _sections.length - 1;

      markers.add(
        Marker(
          point: section.coordinates.last,
          child: Icon(
            isLastSection ? Icons.flag : Icons.location_on,
            color: isLastSection ? Colors.red : Colors.blue,
            size: 28,
          ),
        ),
      );
    }

    // Додаємо маркер для поточної точки (якщо є і не збігається з останньою)
    if (_lastPoint != null && _sections.isNotEmpty) {
      final lastSectionEnd = _sections.last.coordinates.last;
      if (_lastPoint!.latitude != lastSectionEnd.latitude || _lastPoint!.longitude != lastSectionEnd.longitude) {
        markers.add(
          Marker(
            point: _lastPoint!,
            child: const Icon(Icons.add_location, color: Colors.orange, size: 24),
          ),
        );
      }
    }

    return markers;
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка: $e')),
        );
      }
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

  /// Створення адаптивних опцій карти для контексту створення маршруту
  MapOptions _createAdaptiveMapOptions() {
    final screenSize = MediaQuery.of(context).size;
    final routePoints = _sections.isNotEmpty ? _sections.expand((section) => section.coordinates).toList() : null;

    final adaptiveOptions = AdaptiveMapOptions(
      context: MapContext.routeCreation,
      routePoints: routePoints,
      screenSize: screenSize,
      customCenter: defaultCenter,
      enableAutoFit: routePoints != null && routePoints.length > 1,
      padding: 0.15, // 15% відступ від країв
    );

    return adaptiveOptions.toMapOptions();
  }

  /// Створення адаптивних опцій карти з обробкою натискань
  MapOptions _createAdaptiveMapOptionsWithTap() {
    final baseOptions = _createAdaptiveMapOptions();
    return MapOptions(
      initialCenter: baseOptions.initialCenter,
      initialZoom: baseOptions.initialZoom,
      minZoom: baseOptions.minZoom,
      maxZoom: baseOptions.maxZoom,
      interactionOptions: baseOptions.interactionOptions,
      onTap: (_, point) => _isDrawingMode ? _addRoutePoint(point) : _addInterestPoint(point),
    );
  }
}
