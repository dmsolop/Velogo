import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../route_logic/draw_sections.dart';
import '../route_logic/route_section.dart';
import '../route_logic/calculate_difficulty.dart';
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
              onTap: (_, point) => _isDrawingMode
                  ? _addRoutePoint(point)
                  : _addInterestPoint(point),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 150, // Зменшена загальна висота панелі
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          color: BaseColors.background,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Базове текстове поле
                  const Expanded(
                    child: CustomTextField(
                      hintText: "Your route",
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Кнопка по ширині тексту
                  AdaptiveButton(
                    label: "Done",
                    onPressed: () {
                      // Логіка для збереження маршруту
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            CustomText(
              text: "Distance: ${_calculateTotalDistance()} km",
              fontSize: 14,
              color: BaseColors.white,
            ),
            const SizedBox(height: 4),
            CustomText(
              text:
                  "Elevation Gain: ${_sections.fold(0.0, (sum, s) => sum + s.elevationGain)} m",
              fontSize: 14,
              color: BaseColors.white,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: "Difficulty: ${_calculateTotalDifficulty()}",
              fontSize: 14,
              color: BaseColors.white,
            ),
          ],
        ),
      ),
    );
  }

  double _calculateElevationGain(LatLng start, LatLng end) => 10;

  double _calculateWindEffect(LatLng start, LatLng end) => -2;

  double _calculateTotalDistance() =>
      _sections.fold(0, (sum, section) => sum + 1.0);

  double _calculateTotalDifficulty() =>
      _sections.fold(0, (sum, section) => sum + section.difficulty);
}
