import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'log_service.dart';
import 'road_routing_service.dart';

/// Категорії помилок маршрутизації
enum ErrorCategory {
  userActionable,    // Користувач може виправити (noInternet, noOfflineMaps)
  developerIssue,   // Проблема розробника (noApiKey)
  systemError,      // Проблема системи/сервера (apiError, offlineCalculationFailed, unknown)
}

/// Сервіс для відправки звітів про помилки в Firebase Crashlytics
///
/// Функціональність:
/// - Автоматична відправка звітів про критичні помилки
/// - Збір контексту: код помилки, час, версія додатку, інформація про пристрій
/// - Відправка тільки для помилок developerIssue та systemError
///
/// Використовується в: RoadRoutingService, Use Cases для обробки помилок
class CrashlyticsService {
  static final CrashlyticsService _instance = CrashlyticsService._internal();
  factory CrashlyticsService() => _instance;
  CrashlyticsService._internal();

  PackageInfo? _packageInfo;
  bool _isInitialized = false;

  /// Ініціалізація сервісу
  ///
  /// Завантажує інформацію про версію додатку
  ///
  /// Використовується в: main.dart при ініціалізації додатку
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _packageInfo = await PackageInfo.fromPlatform();
      _isInitialized = true;
      LogService.log('✅ [CrashlyticsService] Ініціалізовано');
    } catch (e) {
      LogService.log('❌ [CrashlyticsService] Помилка ініціалізації: $e');
    }
  }

  /// Відправка звіту про помилку маршрутизації
  ///
  /// Параметри:
  /// - error: тип помилки маршрутизації
  /// - message: повідомлення про помилку
  /// - profile: профіль маршрутизації (тільки для релевантних помилок)
  ///
  /// Використовується в: RoadRoutingService, RoutingRepository
  Future<void> reportRouteCalculationError({
    required RouteCalculationError error,
    required String message,
    String? profile,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Визначаємо категорію помилки
    final category = _getErrorCategory(error);

    // Відправляємо тільки для developerIssue та systemError
    if (category != ErrorCategory.userActionable) {
      try {
        // Генеруємо код помилки
        final errorCode = _generateErrorCode(error);

        // Додаємо контекст через setCustomKey
        _setErrorContext(error, message, profile, category);

        // Відправляємо в Crashlytics
        await FirebaseCrashlytics.instance.recordError(
          Exception(message),
          StackTrace.current,
          reason: 'Route calculation error: $errorCode',
          fatal: false,
        );

        LogService.log('📤 [CrashlyticsService] Звіт відправлено: $errorCode');
      } catch (e) {
        LogService.log('❌ [CrashlyticsService] Помилка відправки звіту: $e');
      }
    }
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

  /// Генерація коду помилки
  String _generateErrorCode(RouteCalculationError error) {
    switch (error) {
      case RouteCalculationError.noInternet:
        return 'ERR-NO-INTERNET';
      case RouteCalculationError.noApiKey:
        return 'ERR-NO-API-KEY';
      case RouteCalculationError.apiError:
        return 'ERR-API-ERROR';
      case RouteCalculationError.noOfflineMaps:
        return 'ERR-NO-OFFLINE-MAPS';
      case RouteCalculationError.offlineCalculationFailed:
        return 'ERR-OFFLINE-FAILED';
      case RouteCalculationError.unknown:
        return 'ERR-UNKNOWN';
    }
  }

  /// Встановлення контексту помилки для Crashlytics
  void _setErrorContext(
    RouteCalculationError error,
    String message,
    String? profile,
    ErrorCategory category,
  ) {
    // Код помилки
    FirebaseCrashlytics.instance.setCustomKey('error_code', _generateErrorCode(error));

    // Тип помилки
    FirebaseCrashlytics.instance.setCustomKey('error_type', error.toString());

    // Категорія
    FirebaseCrashlytics.instance.setCustomKey('category', category.toString());

    // Повідомлення
    FirebaseCrashlytics.instance.setCustomKey('message', message);

    // Версія додатку
    if (_packageInfo != null) {
      FirebaseCrashlytics.instance.setCustomKey('app_version', _packageInfo!.version);
      FirebaseCrashlytics.instance.setCustomKey('build_number', _packageInfo!.buildNumber);
    }

    // Інформація про пристрій
    FirebaseCrashlytics.instance.setCustomKey('platform', Platform.operatingSystem);
    FirebaseCrashlytics.instance.setCustomKey('platform_version', Platform.operatingSystemVersion);

    // Профіль маршруту (тільки для релевантних помилок)
    if (profile != null && _isProfileRelevant(error)) {
      FirebaseCrashlytics.instance.setCustomKey('route_profile', profile);
    }

    // Час помилки
    FirebaseCrashlytics.instance.setCustomKey('timestamp', DateTime.now().toIso8601String());
  }

  /// Перевірка чи профіль релевантний для цієї помилки
  bool _isProfileRelevant(RouteCalculationError error) {
    // Профіль релевантний для помилок API та офлайн розрахунку
    return error == RouteCalculationError.apiError ||
        error == RouteCalculationError.offlineCalculationFailed;
  }
}

