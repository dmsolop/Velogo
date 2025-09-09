import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../error/failures.dart';
import '../services/log_service.dart';

/// Сервіс для маршрутизації по дорогах
class RoadRoutingService {
  static const String _baseUrl = 'https://api.openrouteservice.org/v2/directions';
  static const String _apiKey = 'YOUR_API_KEY_HERE'; // TODO: Додати реальний API ключ
  
  /// Розрахунок маршруту між двома точками по дорогах
  static Future<List<LatLng>> calculateRoute({
    required LatLng startPoint,
    required LatLng endPoint,
    String profile = 'driving-car', // driving-car, cycling-regular, foot-walking
  }) async {
    try {
      LogService.log('🛣️ [RoadRoutingService] Розрахунок маршруту: ${startPoint.latitude},${startPoint.longitude} -> ${endPoint.latitude},${endPoint.longitude}');
      
      final url = '$_baseUrl/$profile';
      final body = {
        'coordinates': [
          [startPoint.longitude, startPoint.latitude],
          [endPoint.longitude, endPoint.latitude]
        ],
        'format': 'geojson',
        'options': {
          'avoid_features': ['highways', 'tollways'],
          'preference': 'fastest',
        }
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coordinates = _extractCoordinatesFromGeoJSON(data);
        LogService.log('✅ [RoadRoutingService] Маршрут розраховано: ${coordinates.length} точок');
        return coordinates;
      } else {
        LogService.log('❌ [RoadRoutingService] Помилка API: ${response.statusCode} - ${response.body}');
        return _fallbackStraightLineRoute(startPoint, endPoint);
      }
    } catch (e) {
      LogService.log('❌ [RoadRoutingService] Помилка: $e');
      return _fallbackStraightLineRoute(startPoint, endPoint);
    }
  }

  /// Розрахунок маршруту через кілька точок
  static Future<List<LatLng>> calculateRouteWithWaypoints({
    required List<LatLng> waypoints,
    String profile = 'driving-car',
  }) async {
    if (waypoints.length < 2) {
      return waypoints;
    }

    try {
      LogService.log('🛣️ [RoadRoutingService] Розрахунок маршруту через ${waypoints.length} точок');
      
      final url = '$_baseUrl/$profile';
      final coordinates = waypoints.map((point) => [point.longitude, point.latitude]).toList();
      
      final body = {
        'coordinates': coordinates,
        'format': 'geojson',
        'options': {
          'avoid_features': ['highways', 'tollways'],
          'preference': 'fastest',
        }
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final routeCoordinates = _extractCoordinatesFromGeoJSON(data);
        LogService.log('✅ [RoadRoutingService] Маршрут через ${waypoints.length} точок розраховано: ${routeCoordinates.length} точок');
        return routeCoordinates;
      } else {
        LogService.log('❌ [RoadRoutingService] Помилка API: ${response.statusCode} - ${response.body}');
        return _fallbackMultiPointRoute(waypoints);
      }
    } catch (e) {
      LogService.log('❌ [RoadRoutingService] Помилка: $e');
      return _fallbackMultiPointRoute(waypoints);
    }
  }

  /// Витягнення координат з GeoJSON відповіді
  static List<LatLng> _extractCoordinatesFromGeoJSON(Map<String, dynamic> data) {
    try {
      final features = data['features'] as List;
      if (features.isEmpty) return [];

      final geometry = features.first['geometry'];
      final coordinates = geometry['coordinates'] as List;
      
      return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
    } catch (e) {
      LogService.log('❌ [RoadRoutingService] Помилка парсингу GeoJSON: $e');
      return [];
    }
  }

  /// Fallback: пряма лінія між двома точками
  static List<LatLng> _fallbackStraightLineRoute(LatLng start, LatLng end) {
    LogService.log('⚠️ [RoadRoutingService] Використовуємо fallback: пряма лінія');
    return [start, end];
  }

  /// Fallback: маршрут через кілька точок (прямі лінії)
  static List<LatLng> _fallbackMultiPointRoute(List<LatLng> waypoints) {
    LogService.log('⚠️ [RoadRoutingService] Використовуємо fallback: прямі лінії через ${waypoints.length} точок');
    return waypoints;
  }

  /// Розрахунок відстані маршруту
  static double calculateRouteDistance(List<LatLng> coordinates) {
    if (coordinates.length < 2) return 0.0;

    double totalDistance = 0.0;
    for (int i = 1; i < coordinates.length; i++) {
      totalDistance += _calculateDistance(coordinates[i - 1], coordinates[i]);
    }
    return totalDistance;
  }

  /// Розрахунок відстані між двома точками (Haversine formula)
  static double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // Радіус Землі в метрах
    
    final lat1Rad = point1.latitude * pi / 180;
    final lat2Rad = point2.latitude * pi / 180;
    final deltaLatRad = (point2.latitude - point1.latitude) * pi / 180;
    final deltaLonRad = (point2.longitude - point1.longitude) * pi / 180;

    final a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) * cos(lat2Rad) *
        sin(deltaLonRad / 2) * sin(deltaLonRad / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Отримання профілю маршруту на основі типу активності
  static String getProfileForActivity(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'cycling':
      case 'bike':
        return 'cycling-regular';
      case 'walking':
      case 'hiking':
        return 'foot-walking';
      case 'driving':
      case 'car':
      default:
        return 'driving-car';
    }
  }
}
