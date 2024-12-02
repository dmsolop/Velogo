import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:velogo/route_logic/draw_sections.dart';
import '../route_logic/route_section.dart';
import '../route_logic/calculate_difficulty.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({Key? key}) : super(key: key);

  @override
  _CreateRouteScreenState createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen> {
  final List<RouteSection> _sections = [];
  LatLng? _lastPoint;
  bool _isDrawingMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Route"),
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(48.858844, 2.294351),
              zoom: 10,
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
          builder: (ctx) => const Icon(Icons.place, color: Colors.green),
        ),
      for (var section in _sections)
        Marker(
          point: section.coordinates.last,
          builder: (ctx) => const Icon(Icons.flag, color: Colors.red),
        ),
    ];
  }

  Widget _buildControlPanel() {
    return Positioned(
      right: 16,
      top: 100,
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: "zoomIn",
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "zoomOut",
            onPressed: () {},
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "toggleDraw",
            onPressed: () {
              setState(() {
                _isDrawingMode = !_isDrawingMode;
              });
            },
            backgroundColor: _isDrawingMode ? Colors.orange : Colors.blue,
            child: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Distance: ${_calculateTotalDistance()} km",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              "Total Difficulty: ${_calculateTotalDifficulty()}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Логіка завершення маршруту
              },
              child: const Text("Done"),
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
