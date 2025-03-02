import 'package:dio/dio.dart';

class WeatherService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.weather.com/v1', // ⚠️ Замініть на реальний API
    connectTimeout: const Duration(seconds: 10), // Таймаут підключення
    receiveTimeout: const Duration(seconds: 10), // Таймаут відповіді
  ));

  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    try {
      final response = await _dio.get('/forecast', queryParameters: {
        'lat': lat,
        'lon': lon,
        'apiKey': 'YOUR_API_KEY' // ⚠️ Замініть на реальний API ключ
      });

      return response.data; // Повертаємо JSON
    } on DioException catch (e) {
      print("❌ Error fetching weather: ${e.message}");
      throw Exception("Failed to load weather data");
    }
  }
}
