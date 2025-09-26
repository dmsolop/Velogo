import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../services/log_service.dart';
import 'offline_map_service.dart';
import 'remote_config_service.dart';

/// Сервіс для маршрутизації по дорогах
/// 
/// Основні функції:
/// - Розрахунок маршрутів між точками через OpenRouteService API
/// - Підтримка різних профілів (велосипед, автомобіль, пішки)
/// - Fallback на прямі лінії при відсутності інтернету
/// - Кешування та оптимізація запитів
/// 
/// Використовується в: CreateRouteScreen, RouteScreen, RouteDragService
class RoadRoutingService {
  static final RemoteConfigService _remoteConfig = RemoteConfigService();

  /// Перевірка доступності інтернет-з'єднання
  /// 
  /// Виконує HTTP запит до Google для перевірки з'єднання
  /// 
  /// Використовується в: calculateRoute(), calculateRouteWithWaypoints()
  static Future<bool> _isInternetAvailable() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Розрахунок маршруту між двома точками по дорогах
  /// 
  /// Функціональність:
  /// - Намагається використати OpenRouteService API (якщо є інтернет)
  /// - Fallback на пряму лінію при відсутності з'єднання
  /// - Підтримує різні профілі маршрутизації
  /// 
  /// Параметри:
  /// - startPoint: початкова точка маршруту
  /// - endPoint: кінцева точка маршруту  
  /// - profile: профіль маршрутизації (cycling-regular, driving-car, foot-walking)
  /// 
  /// Використовується в: CreateRouteScreen._addRoutePoint(), RouteScreen._addRoutePoint()
  static Future<List<LatLng>> calculateRoute({
    required LatLng startPoint,
    required LatLng endPoint,
    String profile = 'cycling-regular', // cycling-regular, driving-car, foot-walking
  }) async {
    try {
      LogService.log('🛣️ [RoadRoutingService] Розрахунок маршруту: ${startPoint.latitude},${startPoint.longitude} -> ${endPoint.latitude},${endPoint.longitude}');

      // 1. Спочатку намагаємося використати онлайн API (якщо є інтернет та API ключ)
      final apiKey = _remoteConfig.openRouteServiceApiKey;
      final hasInternet = await _isInternetAvailable();

      LogService.log('🔍 [RoadRoutingService] Перевірка умов:');
      LogService.log('  - Інтернет доступний: $hasInternet');
      LogService.log('  - API ключ: ${apiKey.substring(0, 10)}...');
      LogService.log('  - API ключ не placeholder: ${apiKey != 'YOUR_OPENROUTESERVICE_API_KEY_HERE'}');
      LogService.log('  - API ключ не порожній: ${apiKey.isNotEmpty}');

      if (hasInternet && apiKey != 'YOUR_OPENROUTESERVICE_API_KEY_HERE' && apiKey.isNotEmpty) {
        LogService.log('🌐 [RoadRoutingService] Використовуємо онлайн API');
        final onlineRoute = await _calculateOnlineRoute(startPoint, endPoint, profile);
        if (onlineRoute.isNotEmpty) {
          LogService.log('✅ [RoadRoutingService] Онлайн маршрут успішно розраховано: ${onlineRoute.length} точок');
          return onlineRoute;
        }
        LogService.log('⚠️ [RoadRoutingService] Онлайн API не повернув результат, переходимо до офлайн логіки');
      } else {
        LogService.log('📱 [RoadRoutingService] API ключ не налаштовано або немає інтернету, використовуємо офлайн маршрутизацію');
      }

      // 2. Якщо онлайн API недоступне, використовуємо офлайн маршрутизацію
      LogService.log('📱 [RoadRoutingService] Використовуємо офлайн маршрутизацію');
      return await _calculateOfflineRoute(startPoint, endPoint, profile);
    } catch (e) {
      LogService.log('❌ [RoadRoutingService] Помилка: $e');
      return _fallbackStraightLineRoute(startPoint, endPoint);
    }
  }

  /// Розрахунок маршруту через онлайн API
  static Future<List<LatLng>> _calculateOnlineRoute(LatLng startPoint, LatLng endPoint, String profile) async {
    try {
      final baseUrl = _remoteConfig.openRouteServiceBaseUrl;
      final apiKey = _remoteConfig.openRouteServiceApiKey;
      final url = '$baseUrl/directions/$profile';

      // Виправлений формат запиту для OpenRouteService API
      final body = {
        'coordinates': [
          [startPoint.longitude, startPoint.latitude],
          [endPoint.longitude, endPoint.latitude]
        ],
        'format': 'geojson',
        'instructions': false, // Відключаємо інструкції для зменшення розміру відповіді
        'options': {
          'avoid_features': _getAvoidFeaturesForProfile(profile),
        }
      };

      LogService.log('🌐 [RoadRoutingService] Запит до API: $url');
      LogService.log('🌐 [RoadRoutingService] Тіло запиту: ${jsonEncode(body)}');
      LogService.log('🌐 [RoadRoutingService] Заголовки: Authorization: Bearer ${apiKey.substring(0, 10)}...');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey', // Виправлений формат авторизації
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      LogService.log('🌐 [RoadRoutingService] Відповідь API: ${response.statusCode}');
      LogService.log('🌐 [RoadRoutingService] Тіло відповіді: ${response.body}');

      if (response.statusCode != 200) {
        LogService.log('❌ [RoadRoutingService] Детальна помилка API:');
        LogService.log('  - Статус: ${response.statusCode}');
        LogService.log('  - Заголовки відповіді: ${response.headers}');
        LogService.log('  - Тіло помилки: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coordinates = _extractCoordinatesFromGeoJSON(data);
        LogService.log('✅ [RoadRoutingService] Онлайн маршрут розраховано: ${coordinates.length} точок');
        return coordinates;
      } else {
        LogService.log('❌ [RoadRoutingService] Помилка онлайн API: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      LogService.log('❌ [RoadRoutingService] Помилка онлайн API: $e');
      return [];
    }
  }

  /// Розрахунок маршруту в офлайн режимі
  static Future<List<LatLng>> _calculateOfflineRoute(LatLng startPoint, LatLng endPoint, String profile) async {
    try {
      LogService.log('📱 [RoadRoutingService] Розрахунок офлайн маршруту');

      // Перевіряємо чи є офлайн карти для цієї області
      final hasOfflineMaps = await _hasOfflineMapsForArea(startPoint, endPoint);

      if (hasOfflineMaps) {
        LogService.log('🗺️ [RoadRoutingService] Використовуємо офлайн карти для маршрутизації');
        return await _calculateRouteWithOfflineMaps(startPoint, endPoint, profile);
      } else {
        LogService.log('⚠️ [RoadRoutingService] Офлайн карти недоступні, використовуємо розумний fallback');
        return _calculateSmartRoute(startPoint, endPoint, profile);
      }
    } catch (e) {
      LogService.log('❌ [RoadRoutingService] Помилка офлайн маршрутизації: $e');
      return _fallbackStraightLineRoute(startPoint, endPoint);
    }
  }

  /// Перевірити чи є офлайн карти для області
  static Future<bool> _hasOfflineMapsForArea(LatLng start, LatLng end) async {
    try {
      // Перевіряємо кілька тайлів на різних рівнях zoom
      final testZoom = 14; // Середній рівень деталізації
      final testTiles = [
        _latLngToTile(start.latitude, start.longitude, testZoom),
        _latLngToTile(end.latitude, end.longitude, testZoom),
        _latLngToTile((start.latitude + end.latitude) / 2, (start.longitude + end.longitude) / 2, testZoom),
      ];

      for (final tile in testTiles) {
        final isCached = await OfflineMapService.isTileCached(tile.x, tile.y, testZoom);
        if (!isCached) {
          return false;
        }
      }

      return true;
    } catch (e) {
      LogService.log('❌ [RoadRoutingService] Помилка перевірки офлайн карт: $e');
      return false;
    }
  }

  /// Розрахунок маршруту з використанням офлайн карт
  static Future<List<LatLng>> _calculateRouteWithOfflineMaps(LatLng start, LatLng end, String profile) async {
    // Тут можна реалізувати складну логіку маршрутизації на основі офлайн карт
    // Поки що використовуємо розумний fallback
    return _calculateSmartRoute(start, end, profile);
  }

  /// Розумний fallback маршрут (не просто пряма лінія)
  static List<LatLng> _calculateSmartRoute(LatLng start, LatLng end, String profile) {
    LogService.log('🧠 [RoadRoutingService] Розрахунок розумного маршруту для профілю: $profile');

    // Розраховуємо відстань
    final distance = _calculateDistance(start, end);

    // Якщо відстань невелика, використовуємо пряму лінію
    if (distance < 0.3) {
      // менше 300м
      LogService.log('📏 [RoadRoutingService] Коротка відстань (${distance.toStringAsFixed(2)}км), використовуємо пряму лінію');
      return [start, end];
    }

    // Для більших відстаней додаємо проміжні точки для більш реалістичного маршруту
    final numPoints = (distance * 3).round().clamp(4, 15); // 3 точки на км, мінімум 4, максимум 15
    final points = <LatLng>[];

    for (int i = 0; i < numPoints; i++) {
      final ratio = i / (numPoints - 1);
      final lat = start.latitude + (end.latitude - start.latitude) * ratio;
      final lng = start.longitude + (end.longitude - start.longitude) * ratio;

      // Додаємо невеликі відхилення для імітації доріг
      // Різні профілі мають різні відхилення
      double deviation = 0.0;
      switch (profile) {
        case 'cycling-regular':
          // Велосипедні маршрути можуть бути більш звивистими
          deviation = 0.0002 * sin(ratio * pi * 4) + 0.0001 * cos(ratio * pi * 2);
          break;
        case 'foot-walking':
          // Пішохідні маршрути можуть бути найбільш звивистими
          deviation = 0.0003 * sin(ratio * pi * 5) + 0.0002 * cos(ratio * pi * 3);
          break;
        case 'driving-car':
        default:
          // Автомобільні маршрути найменш звивисті
          deviation = 0.0001 * sin(ratio * pi * 3) + 0.00005 * cos(ratio * pi * 2);
          break;
      }

      points.add(LatLng(lat + deviation, lng + deviation * 0.3));
    }

    LogService.log('✅ [RoadRoutingService] Розумний маршрут: ${points.length} точок, відстань: ${distance.toStringAsFixed(2)}км');
    return points;
  }

  /// Розрахунок маршруту через кілька проміжних точок
  /// 
  /// Функціональність:
  /// - Розраховує маршрут через всі передані waypoints
  /// - Використовує OpenRouteService API для точного маршруту
  /// - Повертає всі координати маршруту
  /// 
  /// Параметри:
  /// - waypoints: список проміжних точок маршруту
  /// - profile: профіль маршрутизації
  /// 
  /// Використовується в: CreateRouteScreen._moveRouteSection()
  static Future<List<LatLng>> calculateRouteWithWaypoints({
    required List<LatLng> waypoints,
    String profile = 'cycling-regular',
  }) async {
    if (waypoints.length < 2) {
      return waypoints;
    }

    try {
      LogService.log('🛣️ [RoadRoutingService] Розрахунок маршруту через ${waypoints.length} точок');

      final baseUrl = _remoteConfig.openRouteServiceBaseUrl;
      final url = '$baseUrl/directions/$profile';
      final coordinates = waypoints.map((point) => [point.longitude, point.latitude]).toList();

      final body = {
        'coordinates': coordinates,
        'format': 'geojson',
        'instructions': false, // Відключаємо інструкції для зменшення розміру відповіді
        'options': {
          'avoid_features': _getAvoidFeaturesForProfile(profile),
        }
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${_remoteConfig.openRouteServiceApiKey}',
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
      LogService.log('🔍 [RoadRoutingService] Парсинг GeoJSON відповіді...');
      LogService.log('🔍 [RoadRoutingService] Структура даних: ${data.keys.toList()}');

      // Перевіряємо чи є routes (OpenRouteService формат)
      if (data.containsKey('routes')) {
        final routes = data['routes'] as List;
        if (routes.isNotEmpty) {
          final route = routes.first;
          LogService.log('🔍 [RoadRoutingService] Знайдено route: ${route.keys.toList()}');

          // Перевіряємо geometry в route
          if (route.containsKey('geometry')) {
            final geometry = route['geometry'];
            LogService.log('🔍 [RoadRoutingService] Geometry тип: ${geometry.runtimeType}');

            // Якщо geometry є encoded polyline string
            if (geometry is String) {
              LogService.log('🔍 [RoadRoutingService] Geometry є encoded polyline string, декодуємо...');
              return _decodePolyline(geometry);
            }

            // Якщо geometry є об'єктом з coordinates
            if (geometry is Map && geometry.containsKey('coordinates')) {
              final coordinates = geometry['coordinates'] as List;
              LogService.log('🔍 [RoadRoutingService] Знайдено coordinates: ${coordinates.length} точок');
              return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
            }
          }
        }
      }

      // Перевіряємо чи є features (стандартний GeoJSON формат)
      if (data.containsKey('features')) {
        final features = data['features'] as List;
        if (features.isNotEmpty) {
          final feature = features.first;
          LogService.log('🔍 [RoadRoutingService] Знайдено feature: ${feature.keys.toList()}');

          if (feature.containsKey('geometry')) {
            final geometry = feature['geometry'];
            LogService.log('🔍 [RoadRoutingService] Feature geometry тип: ${geometry.runtimeType}');

            // Якщо geometry є encoded polyline string
            if (geometry is String) {
              LogService.log('🔍 [RoadRoutingService] Feature geometry є encoded polyline string, декодуємо...');
              return _decodePolyline(geometry);
            }

            // Якщо geometry є об'єктом з coordinates
            if (geometry is Map && geometry.containsKey('coordinates')) {
              final coordinates = geometry['coordinates'] as List;
              LogService.log('🔍 [RoadRoutingService] Знайдено feature coordinates: ${coordinates.length} точок');
              return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
            }
          }
        }
      }

      LogService.log('❌ [RoadRoutingService] Не знайдено підтримуваної структури GeoJSON');
      return [];
    } catch (e) {
      LogService.log('❌ [RoadRoutingService] Помилка парсингу GeoJSON: $e');
      LogService.log('❌ [RoadRoutingService] Дані: $data');
      return [];
    }
  }

  /// Декодування polyline string в список координат
  static List<LatLng> _decodePolyline(String polyline) {
    try {
      final List<LatLng> points = [];
      int index = 0;
      int lat = 0;
      int lng = 0;

      while (index < polyline.length) {
        int shift = 0;
        int result = 0;
        int b;
        do {
          b = polyline.codeUnitAt(index++) - 63;
          result |= (b & 0x1f) << shift;
          shift += 5;
        } while (b >= 0x20);
        int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lat += dlat;

        shift = 0;
        result = 0;
        do {
          b = polyline.codeUnitAt(index++) - 63;
          result |= (b & 0x1f) << shift;
          shift += 5;
        } while (b >= 0x20);
        int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lng += dlng;

        points.add(LatLng(lat / 1e5, lng / 1e5));
      }

      LogService.log('✅ [RoadRoutingService] Декодовано polyline: ${points.length} точок');
      return points;
    } catch (e) {
      LogService.log('❌ [RoadRoutingService] Помилка декодування polyline: $e');
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

    final a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) + cos(lat1Rad) * cos(lat2Rad) * sin(deltaLonRad / 2) * sin(deltaLonRad / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Отримання профілю маршрутизації за типом активності
  /// 
  /// Мапить типи активності на профілі OpenRouteService:
  /// - cycling/bike -> cycling-regular
  /// - walking/hiking -> foot-walking  
  /// - driving/car -> driving-car
  /// - default -> cycling-regular
  /// 
  /// Використовується в: різних місцях для визначення профілю за типом активності
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
        return 'driving-car';
      default:
        return 'cycling-regular'; // За замовчуванням велосипедний профіль
    }
  }

  /// Отримання avoid_features для конкретного профілю
  static List<String> _getAvoidFeaturesForProfile(String profile) {
    switch (profile) {
      case 'cycling-regular':
      case 'cycling-road':
      case 'cycling-mountain':
      case 'cycling-electric':
        return []; // Для велосипедів немає обмежень - можуть їхати скрізь
      case 'foot-walking':
      case 'foot-hiking':
        return ['ferries']; // Для пішоходів тільки пароми
      case 'driving-car':
      default:
        return ['highways', 'tollways', 'ferries']; // Для автомобілів всі обмеження
    }
  }

  /// Конвертація координат в тайл карти
  static MapTile _latLngToTile(double lat, double lng, int zoom) {
    final n = pow(2, zoom).toDouble();
    final x = ((lng + 180) / 360 * n).floor();
    final y = ((1 - log(tan(lat * pi / 180) + 1 / cos(lat * pi / 180)) / pi) / 2 * n).floor();
    return MapTile(x: x, y: y);
  }
}

/// Клас для представлення тайлу карти
class MapTile {
  final int x;
  final int y;

  MapTile({required this.x, required this.y});
}
