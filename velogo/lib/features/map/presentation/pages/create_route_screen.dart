import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/route_entity.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../../domain/usecases/calculate_route_usecase.dart';
import '../../domain/usecases/calculate_route_distance_usecase.dart';
import '../../domain/usecases/calculate_elevation_gain_usecase.dart';
import '../../domain/usecases/calculate_wind_effect_usecase.dart';
import '../../domain/usecases/calculate_route_complexity_usecase.dart';
import '../../../profile/domain/usecases/get_profile_usecase.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/base_colors.dart';
import '../../../../shared/base_widgets.dart';
import '../../../../shared/dev_helpers.dart';
import '../../../../core/services/adaptive_map_options.dart';
import '../../../../core/services/map_context_service.dart';
import '../../../../core/services/offline_tile_provider.dart';
import '../../../../core/services/route_drag_service.dart';
import '../../../../core/services/log_service.dart';
import '../../../../core/services/road_routing_service.dart';
import '../../../../core/services/crashlytics_service.dart';
import '../../../settings/presentation/bloc/settings/settings_cubit.dart';
import '../../../settings/presentation/bloc/settings/settings_state.dart';
import '../../../../core/di/injection_container.dart';

/// Екран для створення та редагування маршрутів
///
/// Основні функції:
/// - Додавання точок маршруту натисканням на карту
/// - Перетягування існуючих точок маршруту (якщо увімкнено в налаштуваннях)
/// - Розрахунок маршрутів по дорогах через OpenRouteService API
/// - Відображення складності маршруту
/// - Збереження маршруту з назвою та описом
///
/// Використовується в: NavigationTab.myRoutes -> RouteScreen -> CreateRouteScreen
class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  CreateRouteScreenState createState() => CreateRouteScreenState();
}

class CreateRouteScreenState extends State<CreateRouteScreen> {
  final List<RouteSectionEntity> _sections = [];
  final defaultCenter = ReferenceValues.defaultMapCenter;
  LatLng? _lastPoint;
  bool _isDrawingMode = true;

  // Use Cases
  late final CalculateRouteUseCase _calculateRouteUseCase;
  late final CalculateRouteDistanceUseCase _calculateRouteDistanceUseCase;
  late final CalculateElevationGainUseCase _calculateElevationGainUseCase;
  late final CalculateWindEffectUseCase _calculateWindEffectUseCase;
  late final CalculateRouteComplexityUseCase _calculateRouteComplexityUseCase;
  late final GetProfileUseCase _getProfileUseCase;

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

  /// Ініціалізація екрану створення маршруту
  ///
  /// Виконується при створенні віджета.
  /// RouteDragService ініціалізується автоматично при завантаженні налаштувань.
  @override
  void initState() {
    super.initState();
    // RouteDragService буде ініціалізований автоматично при завантаженні налаштувань
    
    // Ініціалізуємо Use Cases
    _calculateRouteUseCase = sl<CalculateRouteUseCase>();
    _calculateRouteDistanceUseCase = sl<CalculateRouteDistanceUseCase>();
    _calculateElevationGainUseCase = sl<CalculateElevationGainUseCase>();
    _calculateWindEffectUseCase = sl<CalculateWindEffectUseCase>();
    _calculateRouteComplexityUseCase = sl<CalculateRouteComplexityUseCase>();
    _getProfileUseCase = sl<GetProfileUseCase>();
  }

  /// Побудова основного інтерфейсу екрану створення маршруту
  ///
  /// Створює:
  /// - BlocProvider для SettingsCubit (налаштування додатку)
  /// - FlutterMap з тайлами, полілініями та маркерами
  /// - Панель управління з кнопками та інформацією
  ///
  /// Використовується: автоматично Flutter при рендерингу віджета
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsCubit>()..loadSettings(),
      child: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          // BlocListener не потрібен, оскільки RouteDragService оновлюється в SettingsCubit
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

  /// Додавання нової точки маршруту
  ///
  /// Функціональність:
  /// - Розраховує маршрут по дорогах між поточною та новою точкою
  /// - Створює нову секцію маршруту з розрахованими координатами
  /// - Оновлює складність маршруту
  /// - Зберігає нову точку як останню для наступного з'єднання
  ///
  /// Використовується в: _createAdaptiveMapOptionsWithTap() -> onTap
  void _addRoutePoint(LatLng point) async {
    if (_lastPoint != null) {
      // Розраховуємо маршрут по дорогах між точками через Use Case
      final routeResult = await _calculateRouteUseCase(
        CalculateRouteParams(
          startPoint: _lastPoint!,
          endPoint: point,
          profile: _getRouteProfile(),
        ),
      );

      // Перевіряємо результат розрахунку
      routeResult.fold(
        (failure) {
          LogService.log('❌ [CreateRouteScreen] Помилка розрахунку маршруту: ${failure.message}');
          // Мапимо Failure на RouteCalculationError для діалогу
          _showRouteErrorFromFailure(failure);
        },
        (routeCoordinates) async {
          LogService.log('✅ [CreateRouteScreen] Маршрут успішно розраховано: ${routeCoordinates.length} точок');

          // Розраховуємо відстань через Use Case
          final distanceResult = await _calculateRouteDistanceUseCase(
            CalculateRouteDistanceParams(coordinates: routeCoordinates),
          );

          // Розраховуємо набір висоти через Use Case
          final elevationResult = await _calculateElevationGainUseCase(
            CalculateElevationGainParams(
              startPoint: _lastPoint!,
              endPoint: point,
            ),
          );

          // Розраховуємо вплив вітру через Use Case
          final windResult = await _calculateWindEffectUseCase(
            CalculateWindEffectParams(
              startPoint: _lastPoint!,
              endPoint: point,
            ),
          );

          // Обробляємо результати
          final distance = distanceResult.fold((_) => 0.0, (d) => d);
          final elevationGain = elevationResult.fold((_) => 0.0, (e) => e);
          final windEffect = windResult.fold((_) => 0.0, (w) => w);

          // Завжди створюємо нову секцію для кожної ділянки маршруту
          // Це забезпечує правильне відображення маршруту по дорогах
          final newSection = RouteSectionEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            coordinates: routeCoordinates,
            distance: distance,
            elevationGain: elevationGain,
            surfaceType: RoadSurfaceType.asphalt,
            windEffect: windEffect,
            difficulty: 0.0,
            averageSpeed: 15.0,
          );

          setState(() {
            _sections.add(newSection);
          });

          // Розраховуємо складність з новою системою
          await _calculateRouteDifficulty();
        },
      );
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

  /// Мапінг Failure на RouteCalculationError для відображення діалогу
  void _showRouteErrorFromFailure(Failure failure) {
    RouteCalculationError error = RouteCalculationError.unknown;
    String message = 'Сталася неочікувана помилка.';

    // Перевіряємо чи це RouteCalculationFailure
    failure.when(
      server: (msg) {
        error = RouteCalculationError.apiError;
        message = msg ?? 'Помилка сервера маршрутизації.';
      },
      cache: (msg) {
        error = RouteCalculationError.noOfflineMaps;
        message = msg ?? 'Немає офлайн карт для цієї області. Завантажте карти або перевірте інтернет.';
      },
      network: (msg) {
        error = RouteCalculationError.noInternet;
        message = msg ?? 'Немає інтернет-з\'єднання. Перевірте підключення до мережі.';
      },
      auth: (msg) {
        error = RouteCalculationError.unknown;
        message = msg ?? 'Помилка авторизації.';
      },
      validation: (msg) {
        error = RouteCalculationError.unknown;
        message = msg ?? 'Помилка валідації.';
      },
      permission: (msg) {
        error = RouteCalculationError.unknown;
        message = msg ?? 'Помилка дозволів.';
      },
      routeCalculation: (msg, errorType) {
        error = errorType ?? RouteCalculationError.unknown;
        message = msg ?? 'Помилка розрахунку маршруту.';
      },
    );

    _showRouteErrorDialog(error, message);
  }

  double _calculateTotalDistance() => _sections.fold(0.0, (sum, section) => sum + section.distance);

  /// Розрахунок складності маршруту з використанням нового RouteComplexityService
  Future<void> _calculateRouteDifficulty() async {
    if (_sections.isEmpty) return;

    setState(() {
      _isLoadingDifficulty = true;
    });

    try {
      // Створюємо RouteEntity з поточних секцій
      final routeEntity = _createRouteEntityFromSections();

      // Отримуємо профіль користувача через Use Case
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isLoadingDifficulty = false;
        });
        return;
      }

      // Отримуємо профіль користувача через GetProfileUseCase
      final profileResult = await _getProfileUseCase(user.uid);
      final profile = profileResult.fold(
        (failure) {
          // Якщо не вдалося отримати профіль, створюємо базовий
          LogService.log('⚠️ [CreateRouteScreen] Не вдалося отримати профіль: ${failure.message}');
          return ProfileEntity(
            id: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            fitnessLevel: 'intermediate',
            age: 30,
          );
        },
        (profile) => profile,
      );

      // Використовуємо CalculateRouteComplexityUseCase
      final result = await _calculateRouteComplexityUseCase(
        CalculateRouteComplexityParams(
          route: routeEntity,
          userProfile: profile,
          startTime: DateTime.now(),
          useHealthData: true,
        ),
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

      // RouteSectionEntity вже використовується, просто додаємо до списку
      sections.add(section);
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

  /// Створення налаштувань карти з обробкою натискань
  ///
  /// Додає до базових налаштувань карти обробники подій:
  /// - onTap: додавання точок маршруту або завершення перетягування
  /// - onLongPress: початок перетягування відрізка маршруту
  /// - onSecondaryTap: скасування режиму перетягування
  ///
  /// Використовується в: build() -> FlutterMap.options
  MapOptions _createAdaptiveMapOptionsWithTap() {
    final baseOptions = _createAdaptiveMapOptions();
    return MapOptions(
      initialCenter: baseOptions.initialCenter,
      initialZoom: baseOptions.initialZoom,
      minZoom: baseOptions.minZoom,
      maxZoom: baseOptions.maxZoom,
      interactionOptions: baseOptions.interactionOptions,
      onTap: (_, point) {
        LogService.log('🔍 [CreateRouteScreen] Звичайне натискання на: ${point.latitude},${point.longitude}');
        LogService.log('🔍 [CreateRouteScreen] _isDragging: $_isDragging, _isDrawingMode: $_isDrawingMode');

        if (_isDragging) {
          // Якщо ми в режимі перетягування, завершуємо перетягування
          LogService.log('🔍 [CreateRouteScreen] Завершуємо перетягування');
          _handleSegmentDrag(point);
        } else if (_isDrawingMode) {
          LogService.log('🔍 [CreateRouteScreen] Додаємо точку маршруту');
          _addRoutePoint(point);
        } else {
          LogService.log('🔍 [CreateRouteScreen] Додаємо точку інтересу');
          _addInterestPoint(point);
        }
      },
      onLongPress: (_, point) {
        LogService.log('🔍 [CreateRouteScreen] Довге натискання на: ${point.latitude},${point.longitude}');
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

  /// Обробка довгого натискання на маршрут для початку перетягування
  ///
  /// Функціональність:
  /// - Перевіряє чи увімкнено перетягування в налаштуваннях
  /// - Знаходить найближчий відрізок маршруту до точки натискання
  /// - Активує режим перетягування для знайденого відрізка
  /// - Показує підказку користувачу
  ///
  /// Використовується в: _createAdaptiveMapOptionsWithTap() -> onLongPress
  void _handleLongPressOnRoute(LatLng point) {
    LogService.log('🔍 [CreateRouteScreen] Довге натискання на точку: ${point.latitude},${point.longitude}');
    LogService.log('🔍 [CreateRouteScreen] RouteDragService.isDragEnabled: ${RouteDragService.isDragEnabled}');
    LogService.log('🔍 [CreateRouteScreen] _sections.length: ${_sections.length}');

    if (!RouteDragService.isDragEnabled || _sections.isEmpty) {
      LogService.log('⚠️ [CreateRouteScreen] Перетягування вимкнено або немає секцій');
      return;
    }

    // Знаходимо найближчий відрізок маршруту
    final nearestSegmentIndex = _findNearestSegment(point);
    LogService.log('🔍 [CreateRouteScreen] Найближчий відрізок: $nearestSegmentIndex');

    if (nearestSegmentIndex == -1) {
      LogService.log('⚠️ [CreateRouteScreen] Не знайдено найближчий відрізок');
      return;
    }

    setState(() {
      _isDragging = true;
      _draggedSegmentIndex = nearestSegmentIndex;
    });

    LogService.log('✅ [CreateRouteScreen] Режим перетягування активовано для відрізка $nearestSegmentIndex');

    // Показуємо підказку користувачу
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Натисніть в новому місці для переміщення точки маршруту'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Обробка перетягування відрізка маршруту до нової позиції
  ///
  /// Функціональність:
  /// - Перевіряє чи активний режим перетягування
  /// - Викликає _moveRouteSection для переміщення секції
  /// - Скидає стан перетягування після завершення
  /// - Показує повідомлення про успіх або помилку
  ///
  /// Використовується в: _createAdaptiveMapOptionsWithTap() -> onTap (коли _isDragging = true)
  Future<void> _handleSegmentDrag(LatLng newPosition) async {
    LogService.log('🔍 [CreateRouteScreen] Обробка перетягування до: ${newPosition.latitude},${newPosition.longitude}');
    LogService.log('🔍 [CreateRouteScreen] _isDragging: $_isDragging, _draggedSegmentIndex: $_draggedSegmentIndex');

    if (!_isDragging || _draggedSegmentIndex == null) {
      LogService.log('⚠️ [CreateRouteScreen] Перетягування не активне або немає індексу відрізка');
      return;
    }

    try {
      LogService.log('✅ [CreateRouteScreen] Переміщуємо секцію $_draggedSegmentIndex до нової позиції');
      // Переміщуємо секцію до нової позиції
      await _moveRouteSection(newPosition, _draggedSegmentIndex!);

      setState(() {
        _isDragging = false;
        _draggedSegmentIndex = null;
      });

      LogService.log('✅ [CreateRouteScreen] Точка маршруту успішно переміщена');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Точка маршруту переміщена'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      LogService.log('❌ [CreateRouteScreen] Помилка при переміщенні секції: $e');
      setState(() {
        _isDragging = false;
        _draggedSegmentIndex = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Помилка при переміщенні секції: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Переміщення секції маршруту до нової позиції
  ///
  /// Функціональність:
  /// - Знаходить найближчу точку в секції до нової позиції
  /// - Оновлює координати цієї точки
  /// - Перераховує відстань секції
  /// - Оновлює секцію в списку _sections
  ///
  /// Примітка: НЕ перераховує маршрут через API, щоб уникнути створення зайвих гілок
  ///
  /// Використовується в: _handleSegmentDrag()
  Future<void> _moveRouteSection(LatLng newPosition, int segmentIndex) async {
    LogService.log('🔍 [CreateRouteScreen] Переміщення секції $segmentIndex до: ${newPosition.latitude},${newPosition.longitude}');
    LogService.log('🔍 [CreateRouteScreen] Кількість секцій: ${_sections.length}');

    if (segmentIndex < 0 || segmentIndex >= _sections.length) {
      LogService.log('⚠️ [CreateRouteScreen] Невірний індекс відрізка: $segmentIndex');
      return;
    }

    final section = _sections[segmentIndex];
    LogService.log('🔍 [CreateRouteScreen] Поточна секція має ${section.coordinates.length} точок');

    // Знаходимо найближчу точку в секції до нової позиції
    int closestPointIndex = _findClosestPointInSection(section.coordinates, newPosition);
    LogService.log('🔍 [CreateRouteScreen] Найближча точка в секції: $closestPointIndex');

    // Створюємо нові координати з переміщеною точкою
    final newCoordinates = List<LatLng>.from(section.coordinates);
    newCoordinates[closestPointIndex] = newPosition;
    LogService.log('🔍 [CreateRouteScreen] Точка $closestPointIndex переміщена до нової позиції');

    // Замість перерахунку всього маршруту, просто оновлюємо координати
    // Це збереже структуру маршруту без створення зайвих гілок
    final updatedSection = section.copyWith(
      coordinates: newCoordinates,
      distance: _calculateDistance(newCoordinates),
    );

    setState(() {
      _sections[segmentIndex] = updatedSection;
    });

    LogService.log('✅ [CreateRouteScreen] Секція оновлена успішно без перерахунку маршруту');
  }

  /// Знайти найближчу точку в секції до заданої позиції
  int _findClosestPointInSection(List<LatLng> coordinates, LatLng targetPoint) {
    double minDistance = double.infinity;
    int closestIndex = 0;

    for (int i = 0; i < coordinates.length; i++) {
      final distance = _calculateDistanceBetweenPoints(coordinates[i], targetPoint);
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    return closestIndex;
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
    LogService.log('🔍 [CreateRouteScreen] Пошук найближчого відрізка для точки: ${point.latitude},${point.longitude}');
    double minDistance = double.infinity;
    int nearestIndex = -1;

    for (int i = 0; i < _sections.length; i++) {
      final section = _sections[i];
      LogService.log('🔍 [CreateRouteScreen] Перевіряємо секцію $i з ${section.coordinates.length} точками');

      for (int j = 0; j < section.coordinates.length - 1; j++) {
        final segmentStart = section.coordinates[j];
        final segmentEnd = section.coordinates[j + 1];

        // Розраховуємо відстань від точки до відрізка
        final distance = _distanceToLineSegment(point, segmentStart, segmentEnd);

        if (distance < minDistance) {
          minDistance = distance;
          nearestIndex = i;
          LogService.log('🔍 [CreateRouteScreen] Новий найближчий відрізок: $i, відстань: $distance');
        }
      }
    }

    LogService.log('🔍 [CreateRouteScreen] Найближчий відрізок: $nearestIndex, мінімальна відстань: $minDistance');
    return nearestIndex;
  }

  /// Отримання профілю маршруту з налаштувань користувача
  ///
  /// Повертає:
  /// - 'cycling-regular' - за замовчуванням або при помилці
  /// - Значення з налаштувань користувача (cycling-regular, driving-car, foot-walking)
  ///
  /// Показ діалогу з помилкою маршрутизації та пропозиціями рішень
  ///
  /// Функціональність:
  /// - Показує користувачу детальну інформацію про помилку
  /// - Надає конкретні дії для вирішення проблеми (тільки для userActionable)
  /// - Показує загальне повідомлення для developerIssue та systemError
  /// - Дозволяє спробувати знову або скасувати дію
  ///
  /// Параметри:
  /// - error: тип помилки маршрутизації
  /// - message: детальне повідомлення про помилку
  ///
  /// Використовується в: _addRoutePoint() при помилці розрахунку маршруту
  void _showRouteErrorDialog(RouteCalculationError error, String message) {
    // Визначаємо категорію помилки
    final category = _getErrorCategory(error);
    
    String title;
    String actionText;
    VoidCallback? action;
    bool showRecommendations = false;

    switch (error) {
      case RouteCalculationError.noInternet:
        title = 'Немає інтернет-з\'єднання';
        actionText = 'Перевірити з\'єднання';
        showRecommendations = true;
        action = () {
          Navigator.of(context).pop();
        };
        break;
      case RouteCalculationError.noApiKey:
        title = 'Виникла критична помилка';
        actionText = 'Зрозуміло';
        showRecommendations = false; // Не показуємо детальні рекомендації
        action = () {
          Navigator.of(context).pop();
        };
        break;
      case RouteCalculationError.noOfflineMaps:
        title = 'Немає офлайн карт';
        actionText = 'Завантажити карти';
        showRecommendations = true;
        action = () {
          Navigator.of(context).pop();
        };
        break;
      case RouteCalculationError.apiError:
        title = 'Виникла критична помилка';
        actionText = 'Спробувати знову';
        showRecommendations = false; // Не показуємо детальні рекомендації
        action = () {
          Navigator.of(context).pop();
          // Повторна спроба додати точку
          if (_lastPoint != null) {
            _addRoutePoint(_lastPoint!);
          }
        };
        break;
      case RouteCalculationError.offlineCalculationFailed:
        title = 'Виникла критична помилка';
        actionText = 'Спробувати знову';
        showRecommendations = false; // Не показуємо детальні рекомендації
        action = () {
          Navigator.of(context).pop();
        };
        break;
      default:
        title = 'Виникла критична помилка';
        actionText = 'Спробувати знову';
        showRecommendations = false;
        action = () {
          Navigator.of(context).pop();
        };
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              if (showRecommendations) ...[
                const SizedBox(height: 16),
                const Text(
                  'Рекомендації:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._getErrorRecommendations(error),
              ] else if (category == ErrorCategory.developerIssue || category == ErrorCategory.systemError) ...[
                const SizedBox(height: 16),
                const Text(
                  'Помилка автоматично відправлена розробникам для вирішення.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Скасувати'),
            ),
            if (action != null)
              ElevatedButton(
                onPressed: action,
                child: Text(actionText),
              ),
          ],
        );
      },
    );
  }

  /// Визначення категорії помилки
  ErrorCategory _getErrorCategory(RouteCalculationError error) {
    switch (error) {
      case RouteCalculationError.noInternet:
      case RouteCalculationError.noOfflineMaps:
        return ErrorCategory.userActionable;
      case RouteCalculationError.noApiKey:
        return ErrorCategory.developerIssue;
      case RouteCalculationError.apiError:
      case RouteCalculationError.offlineCalculationFailed:
      case RouteCalculationError.unknown:
        return ErrorCategory.systemError;
    }
  }

  /// Отримання рекомендацій для різних типів помилок
  ///
  /// Параметри:
  /// - error: тип помилки маршрутизації
  ///
  /// Повертає: список рекомендацій для користувача
  List<Widget> _getErrorRecommendations(RouteCalculationError error) {
    switch (error) {
      case RouteCalculationError.noInternet:
        return [
          const Text('• Перевірте підключення до Wi-Fi або мобільного інтернету'),
          const Text('• Перезапустіть додаток'),
          const Text('• Спробуйте пізніше'),
        ];
      case RouteCalculationError.noApiKey:
        return [
          const Text('• Зверніться до служби підтримки'),
          const Text('• Перевірте налаштування додатку'),
        ];
      case RouteCalculationError.noOfflineMaps:
        return [
          const Text('• Завантажте офлайн карти для цієї області'),
          const Text('• Перевірте підключення до інтернету'),
          const Text('• Оберіть інші точки маршруту'),
        ];
      case RouteCalculationError.apiError:
        return [
          const Text('• Перевірте підключення до інтернету'),
          const Text('• Спробуйте через кілька хвилин'),
          const Text('• Оберіть інші точки маршруту'),
        ];
      default:
        return [
          const Text('• Спробуйте пізніше'),
          const Text('• Оберіть інші точки маршруту'),
          const Text('• Перезапустіть додаток'),
        ];
    }
  }

  /// Отримання профілю маршруту з налаштувань користувача
  ///
  /// Повертає:
  /// - 'cycling-regular' - за замовчуванням або при помилці
  /// - Значення з налаштувань користувача (cycling-regular, driving-car, foot-walking)
  ///
  /// Використовується в: _addRoutePoint(), _moveRouteSection()
  String _getRouteProfile() {
    // Отримуємо поточний стан налаштувань
    final settingsState = context.read<SettingsCubit>().state;
    return settingsState.when(
      initial: () => 'cycling-regular', // Значення за замовчуванням
      loading: () => 'cycling-regular', // Значення за замовчуванням
      loaded: (settings) => settings.routeProfile,
      error: (failure) => 'cycling-regular', // Fallback значення
    );
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
