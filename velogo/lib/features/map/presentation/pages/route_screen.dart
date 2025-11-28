import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';
import '../../../../shared/base_widgets.dart';
import '../../../../shared/base_colors.dart';
import '../../../../shared/dev_helpers.dart';
import '../../domain/entities/route_entity.dart';
import '../../../weather/data/datasources/weather_service.dart';
import '../../data/models/road_surface.dart';
import '../../../weather/data/models/weather_data.dart';
import 'create_route_screen.dart';
import '../../../../core/services/adaptive_map_options.dart';
import '../../../../core/services/map_context_service.dart';
import '../../domain/usecases/calculate_route_usecase.dart';
import '../../domain/usecases/calculate_route_distance_usecase.dart';
import '../../domain/usecases/calculate_elevation_gain_usecase.dart';
import '../../domain/usecases/calculate_wind_effect_usecase.dart';
import '../../../../core/services/offline_tile_provider.dart';
import '../../../../core/services/road_routing_service.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/di/injection_container.dart';
import '../../../settings/presentation/bloc/settings/settings_cubit.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  RouteScreenState createState() => RouteScreenState();
}

class RouteScreenState extends State<RouteScreen> {
  final List<RouteSectionEntity> _sections = [];
  final List<String> _interestingPlaces = ["Place A", "Place B", "Place C"];
  final defaultCenter = ReferenceValues.defaultMapCenter;
  LatLng? _lastPoint;

  // Use Cases
  late final CalculateRouteUseCase _calculateRouteUseCase;
  late final CalculateRouteDistanceUseCase _calculateRouteDistanceUseCase;
  late final CalculateElevationGainUseCase _calculateElevationGainUseCase;
  late final CalculateWindEffectUseCase _calculateWindEffectUseCase;

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

    // Ініціалізуємо Use Cases
    _calculateRouteUseCase = sl<CalculateRouteUseCase>();
    _calculateRouteDistanceUseCase = sl<CalculateRouteDistanceUseCase>();
    _calculateElevationGainUseCase = sl<CalculateElevationGainUseCase>();
    _calculateWindEffectUseCase = sl<CalculateWindEffectUseCase>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
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
                    color: getColorBasedOnDifficulty(_totalDifficulty),
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
      // Розраховуємо маршрут по дорогах між точками через Use Case
      final routeResult = await _calculateRouteUseCase(
        CalculateRouteParams(
          startPoint: _lastPoint!,
          endPoint: point,
          profile: _getRouteProfile(),
        ),
      );

      routeResult.fold(
        (failure) {
          // Обробка помилки
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Помилка розрахунку маршруту: ${failure.message}')),
          );
        },
        (routeCoordinates) async {
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

  double _calculateTotalDistance() => _sections.fold(0.0, (sum, section) => sum + section.distance);

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
          roadSurfaces.add(_getRoadSurfaceFromType(section.surfaceType));
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
  double _calculateSlope(RouteSectionEntity section) {
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

  /// Конвертація типу покриття з RoadSurfaceType в RoadSurface
  RoadSurface _getRoadSurfaceFromType(RoadSurfaceType surfaceType) {
    switch (surfaceType) {
      case RoadSurfaceType.asphalt:
        return RoadSurface.asphalt;
      case RoadSurfaceType.concrete:
        return RoadSurface.concrete;
      case RoadSurfaceType.gravel:
        return RoadSurface.gravel;
      case RoadSurfaceType.dirt:
        return RoadSurface.dirt;
      case RoadSurfaceType.cobblestone:
        return RoadSurface.asphalt; // Fallback
      case RoadSurfaceType.grass:
        return RoadSurface.dirt; // Fallback
      case RoadSurfaceType.sand:
        return RoadSurface.dirt; // Fallback
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

  /// Створення адаптивних опцій карти для контексту перегляду маршруту
  MapOptions _createAdaptiveMapOptions() {
    final screenSize = MediaQuery.of(context).size;
    final routePoints = _sections.isNotEmpty ? _sections.expand((section) => section.coordinates).toList() : null;

    final adaptiveOptions = AdaptiveMapOptions(
      context: MapContext.routeViewing,
      routePoints: routePoints,
      screenSize: screenSize,
      customCenter: defaultCenter,
      enableAutoFit: routePoints != null && routePoints.length > 1,
      padding: 0.1, // 10% відступ від країв
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
      onTap: (_, point) => _addRoutePoint(point),
    );
  }

  /// Отримати профіль маршруту з налаштувань
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
}
