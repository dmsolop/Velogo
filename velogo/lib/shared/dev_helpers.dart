import 'package:latlong2/latlong.dart';

/// Заглушки для тестових даних
class MockData {
  static const List<String> interestingPlaces = [
    "Mock Place A",
    "Mock Place B",
    "Mock Place C",
  ];

  static final List<LatLng> mockRoutePoints = [
    LatLng(48.8566, 2.3522), // Париж
    LatLng(48.858844, 2.294351), // Ейфелева вежа
    LatLng(48.861111, 2.336389), // Лувр
  ];
}

/// Референсні значення
class ReferenceValues {
  static LatLng defaultMapCenter = LatLng(48.4131760, 35.0710294);
  static const double defaultZoom = 10.0;

  static const String defaultSearchHint = "Search by location or coordinates";
}

/// Утиліти для тестування
class TestUtils {
  /// Фейкова затримка для імітації асинхронних викликів
  static Future<void> fakeDelay([int milliseconds = 500]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  /// Генератор фейкових точок маршруту
  static List<LatLng> generateMockRoute(int count) {
    return List.generate(
      count,
      (index) => LatLng(48.41 + (index * 0.01), 35.07 + (index * 0.01)),
    );
  }
}

/// Повідомлення та заглушки
class DevMessages {
  static const String featureNotImplemented = "Feature not implemented yet.";
  static const String apiUnavailable = "API is currently unavailable.";
}
