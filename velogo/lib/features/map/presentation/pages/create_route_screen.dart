import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../../../core/services/route_drag_service.dart';
import '../../../settings/presentation/bloc/settings/settings_cubit.dart';
import '../../../settings/presentation/bloc/settings/settings_state.dart';
import '../../../../core/di/injection_container.dart';

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

  // Стан для перетягування
  bool _isDragging = false;
  int? _draggedSegmentIndex;

  @override
  void initState() {
    super.initState();
    // Ініціалізуємо RouteDragService з налаштувань
    _initializeRouteDragService();
  }

  Future<void> _initializeRouteDragService() async {
    // Завантажуємо налаштування з SharedPreferences
    try {
      // Тут можна додати логіку для завантаження налаштувань
      // Поки що використовуємо значення за замовчуванням
      RouteDragService.setDragEnabled(false);
    } catch (e) {
      // Якщо не вдалося завантажити налаштування, використовуємо значення за замовчуванням
      RouteDragService.setDragEnabled(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsCubit>()..loadSettings(),
      child: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            loaded: (settings) {
              // Оновлюємо RouteDragService при зміні налаштувань
              RouteDragService.updateFromSettings(settings.routeDragging);
            },
            error: (failure) {},
          );
        },
        child: Scaffold(
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
        ),
      ),
    );
  }

  void _addRoutePoint(LatLng point) async {
    if (_lastPoint != null) {
      // Розраховуємо маршрут по дорогах між точками
      final routeCoordinates = await RoadRoutingService.calculateRoute(
        startPoint: _lastPoint!,
        endPoint: point,
        profile: 'cycling-regular', // Велосипедний профіль
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
    final polylines = <Polyline>[];

    for (final entry in _sections.asMap().entries) {
      final index = entry.key;
      final section = entry.value;
      final color = getColorBasedOnDifficulty(section.difficulty);
      final isDragging = _isDragging && _draggedSegmentIndex == index;

      // Основна лінія
      polylines.add(Polyline(
        points: section.coordinates,
        color: isDragging ? Colors.orange : color,
        strokeWidth: isDragging ? 6 : 4,
      ));

      // Додаємо пунктирну лінію для відрізка, який готовий до перетягування
      if (isDragging) {
        polylines.add(Polyline(
          points: section.coordinates,
          color: Colors.orange.withOpacity(0.3),
          strokeWidth: 8,
          // pattern: const [10, 5], // Пунктирний паттерн - не підтримується в поточній версії
        ));
      }
    }

    return polylines;
  }

  List<Marker> _generateMarkers() {
    final markers = <Marker>[];
    final allPoints = _getAllRoutePoints();

    // Додаємо маркери для всіх точок маршруту
    for (int i = 0; i < allPoints.length; i++) {
      final point = allPoints[i];
      final isFirst = i == 0;
      final isLast = i == allPoints.length - 1;
      markers.add(
        Marker(
          point: point,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              isFirst ? Icons.place : (isLast ? Icons.flag : Icons.location_on),
              color: isFirst ? Colors.green : (isLast ? Colors.red : Colors.blue),
              size: isFirst ? 32 : (isLast ? 28 : 24),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  Widget _buildControlPanel() {
    return Positioned(
      right: 16,
      // top: 100,
      bottom: 160,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Column(
            children: [
              // Індикатор режиму перетягування
              state.when(
                initial: () => const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                loaded: (settings) {
                  if (settings.routeDragging) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.alt_route,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Перетягування увімкнено',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                error: (failure) => const SizedBox.shrink(),
              ),
              // Кнопка скасування режиму перетягування
              if (_isDragging)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: CustomFloatingButton(
                    heroTag: 'cancelDragTag',
                    onPressed: () {
                      setState(() {
                        _isDragging = false;
                        _draggedSegmentIndex = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Режим перетягування скасовано'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: Icons.close,
                    color: Colors.red,
                  ),
                ),
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
          );
        },
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

          // TODO: Змінити режим спливаючих вікон з рекомендаціями
          // Замість показу діалогу, можна додати рекомендації в UI або показувати їх в іншому форматі
          // final recommendations = complexityService.getRecommendations(complexityResult);
          // if (recommendations.isNotEmpty) {
          //   _showRecommendationsDialog(recommendations);
          // }
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

  // TODO: Видалено метод _showRecommendationsDialog - див. TODO_RECOMMENDATIONS.md

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
      onTap: (_, point) {
        if (_isDragging) {
          // Якщо ми в режимі перетягування, завершуємо перетягування
          _handleSegmentDrag(point);
        } else if (_isDrawingMode) {
          _addRoutePoint(point);
        } else {
          _addInterestPoint(point);
        }
      },
      onLongPress: (_, point) {
        // Обробка довгого натискання для перетягування відрізків
        _handleLongPressOnRoute(point);
      },
      onSecondaryTap: (_, point) {
        // Скасування режиму перетягування при вторинному натисканні
        if (_isDragging) {
          setState(() {
            _isDragging = false;
            _draggedSegmentIndex = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Режим перетягування скасовано'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
    );
  }

  /// Обробка довгого натискання на маршрут
  void _handleLongPressOnRoute(LatLng point) {
    if (!RouteDragService.isDragEnabled || _sections.isEmpty) {
      return;
    }

    // Знаходимо найближчий відрізок маршруту
    final nearestSegmentIndex = _findNearestSegment(point);

    if (nearestSegmentIndex == -1) {
      return;
    }

    setState(() {
      _isDragging = true;
      _draggedSegmentIndex = nearestSegmentIndex;
    });

    // Показуємо підказку користувачу
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Натисніть в новому місці для додавання проміжної точки'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Обробка перетягування відрізка маршруту
  Future<void> _handleSegmentDrag(LatLng newPosition) async {
    if (!_isDragging || _draggedSegmentIndex == null) {
      return;
    }

    try {
      // Вставляємо нову точку в маршрут безпосередньо
      await _insertNewRoutePoint(newPosition, _draggedSegmentIndex!);

      setState(() {
        _isDragging = false;
        _draggedSegmentIndex = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нова точка маршруту додана'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      setState(() {
        _isDragging = false;
        _draggedSegmentIndex = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Помилка при додаванні точки: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Вставити нову точку в маршрут
  Future<void> _insertNewRoutePoint(LatLng newPoint, int segmentIndex) async {
    if (segmentIndex < 0 || segmentIndex >= _sections.length) {
      return;
    }

    final section = _sections[segmentIndex];
    final coordinates = List<LatLng>.from(section.coordinates);

    // Знаходимо найближчу позицію для вставки нової точки
    int insertIndex = _findBestInsertionPoint(coordinates, newPoint);

    // Вставляємо нову точку
    coordinates.insert(insertIndex, newPoint);

    // Перераховуємо маршрут з новою точкою
    final newRoute = await RoadRoutingService.calculateRouteWithWaypoints(
      waypoints: coordinates,
      profile: 'cycling-regular',
    );

    if (newRoute.isNotEmpty) {
      // Оновлюємо секцію з новим маршрутом
      final updatedSection = RouteSection(
        id: section.id,
        coordinates: newRoute,
        distance: _calculateDistance(newRoute),
        elevationGain: section.elevationGain,
        surfaceType: section.surfaceType,
        windEffect: section.windEffect,
        difficulty: section.difficulty,
        averageSpeed: section.averageSpeed,
        notes: section.notes,
      );

      setState(() {
        _sections[segmentIndex] = updatedSection;
      });
    }
  }

  /// Знайти найкращу позицію для вставки нової точки
  int _findBestInsertionPoint(List<LatLng> coordinates, LatLng newPoint) {
    double minDistance = double.infinity;
    int bestIndex = 0;

    for (int i = 0; i < coordinates.length - 1; i++) {
      final distance = _distanceToLineSegment(
        newPoint,
        coordinates[i],
        coordinates[i + 1],
      );

      if (distance < minDistance) {
        minDistance = distance;
        bestIndex = i + 1;
      }
    }

    return bestIndex;
  }

  /// Розрахувати відстань маршруту
  double _calculateDistance(List<LatLng> coordinates) {
    if (coordinates.length < 2) return 0.0;

    double totalDistance = 0.0;
    for (int i = 0; i < coordinates.length - 1; i++) {
      totalDistance += _calculateDistanceBetweenPoints(
        coordinates[i],
        coordinates[i + 1],
      );
    }
    return totalDistance;
  }

  /// Розрахувати відстань між двома точками
  double _calculateDistanceBetweenPoints(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // Радіус Землі в метрах
    final double lat1Rad = point1.latitude * (3.14159265359 / 180);
    final double lat2Rad = point2.latitude * (3.14159265359 / 180);
    final double deltaLatRad = (point2.latitude - point1.latitude) * (3.14159265359 / 180);
    final double deltaLonRad = (point2.longitude - point1.longitude) * (3.14159265359 / 180);

    final double a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) + cos(lat1Rad) * cos(lat2Rad) * sin(deltaLonRad / 2) * sin(deltaLonRad / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Знайти найближчий відрізок маршруту до точки
  int _findNearestSegment(LatLng point) {
    double minDistance = double.infinity;
    int nearestIndex = -1;

    for (int i = 0; i < _sections.length; i++) {
      final section = _sections[i];

      for (int j = 0; j < section.coordinates.length - 1; j++) {
        final segmentStart = section.coordinates[j];
        final segmentEnd = section.coordinates[j + 1];

        // Розраховуємо відстань від точки до відрізка
        final distance = _distanceToLineSegment(point, segmentStart, segmentEnd);

        if (distance < minDistance) {
          minDistance = distance;
          nearestIndex = i;
        }
      }
    }

    return nearestIndex;
  }

  /// Отримати профіль маршруту з налаштувань
  String _getRouteProfile() {
    // Тимчасово повертаємо велосипедний профіль
    // TODO: Інтегрувати з SettingsCubit
    return 'cycling-regular';
  }

  /// Розрахувати відстань від точки до відрізка лінії
  double _distanceToLineSegment(LatLng point, LatLng lineStart, LatLng lineEnd) {
    final A = point.latitude - lineStart.latitude;
    final B = point.longitude - lineStart.longitude;
    final C = lineEnd.latitude - lineStart.latitude;
    final D = lineEnd.longitude - lineStart.longitude;

    final dot = A * C + B * D;
    final lenSq = C * C + D * D;

    if (lenSq == 0) {
      return sqrt(A * A + B * B);
    }

    final param = dot / lenSq;

    double xx, yy;
    if (param < 0) {
      xx = lineStart.latitude;
      yy = lineStart.longitude;
    } else if (param > 1) {
      xx = lineEnd.latitude;
      yy = lineEnd.longitude;
    } else {
      xx = lineStart.latitude + param * C;
      yy = lineStart.longitude + param * D;
    }

    final dx = point.latitude - xx;
    final dy = point.longitude - yy;
    return sqrt(dx * dx + dy * dy);
  }

  /// Отримати всі точки маршруту
  List<LatLng> _getAllRoutePoints() {
    final points = <LatLng>[];

    for (final section in _sections) {
      if (section.coordinates.isNotEmpty) {
        points.add(section.coordinates.first);
      }
    }

    // Додаємо останню точку
    if (_lastPoint != null) {
      points.add(_lastPoint!);
    }

    return points;
  }
}
