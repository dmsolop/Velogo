import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../shared/base_widgets.dart';
import '../shared/base_colors.dart';
import '../shared/dev_helpers.dart';
import '../route_logic/route_section.dart';
import '../route_logic/calculate_difficulty.dart';
import '../screens/create_route_screen.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  final List<RouteSection> _sections = [];
  final List<String> _interestingPlaces = ["Place A", "Place B", "Place C"];
  final defaultCenter = ReferenceValues.defaultMapCenter;
  LatLng? _lastPoint;

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
                center: defaultCenter,
                zoom: 10,
                onTap: (_, point) => _addRoutePoint(point),
                interactiveFlags: InteractiveFlag.all, // Увімкнути пінч
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
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
                    color: Colors.black.withOpacity(0.1),
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
      bottom:
          40 + 100 + 8 + 8, // Відступ до колекції цікавих місць (8 пікселів)
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
              } catch (e, stackTrace) {
                print("Navigation error: $e");
                print(stackTrace);
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
      initialChildSize: 0.05, // Майже невидима у згорнутому стані
      minChildSize: 0.05,
      maxChildSize: 0.6, // Висота для повністю розгорнутого стану
      snap: true,
      snapSizes: const [0.05, 0.6], // Два стани
      builder: (context, scrollController) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8), // Відступи
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: BaseColors.backgroundDark,
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
              Text(
                "Total Difficulty: ${_calculateTotalDifficulty().toStringAsFixed(2)}",
                style: const TextStyle(color: BaseColors.white, fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addRoutePoint(LatLng point) {
    if (_lastPoint != null) {
      final newSection = RouteSection(
        coordinates: [_lastPoint!, point],
        elevationGain: _calculateElevationGain(_lastPoint!, point),
        surfaceType: "asphalt",
        windEffect: _calculateWindEffect(_lastPoint!, point),
      );
      setState(() {
        _sections.add(newSection);
        calculateSectionDifficulty(_sections);
      });
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
          builder: (ctx) => const Icon(Icons.place, color: Colors.green),
        ),
    ];
  }

  double _calculateElevationGain(LatLng start, LatLng end) => 10;

  double _calculateTotalDistance() =>
      _sections.fold(0, (sum, section) => sum + 1.0);

  double _calculateWindEffect(LatLng start, LatLng end) => 0.0;

  Color getColorBasedOnDifficulty(double difficulty) {
    if (difficulty < 3) return Colors.green;
    if (difficulty < 6) return Colors.yellow;
    return Colors.red;
  }

  double _calculateTotalDifficulty() =>
      _sections.fold(0, (sum, section) => sum + section.difficulty);
}
