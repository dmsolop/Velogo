import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:velogo/features/settings/domain/entities/settings_entity.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

/// Model для налаштувань додатку в Data шарі
/// 
/// Функціональність:
/// - Представляє налаштування в Data шарі для серіалізації/десеріалізації
/// - Використовує Freezed та json_annotation для JSON обробки
/// - Містить ті ж поля що й SettingsEntity
/// - Надає методи конвертації між Entity та Model
/// 
/// Поля: (ідентичні SettingsEntity)
/// - voiceInstructions: голосові інструкції
/// - unitsOfMeasurement: одиниці вимірювання
/// - mapStyle: стиль карти
/// - notifications: загальні сповіщення
/// - routeAlerts: сповіщення про маршрути
/// - weatherAlerts: сповіщення про погоду
/// - generalNotifications: загальні сповіщення
/// - healthDataIntegration: інтеграція з даними здоров'я
/// - routeDragging: перетягування маршрутів
/// - routeProfile: профіль маршрутизації
/// 
/// Використовується в: SettingsLocalDataSource, SettingsRepositoryImpl
@freezed
class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    @Default(true) bool voiceInstructions,
    @Default("Metric") String unitsOfMeasurement,
    @Default("Terrain") String mapStyle,
    @Default(true) bool notifications,
    @Default(false) bool routeAlerts,
    @Default(false) bool weatherAlerts,
    @Default(false) bool generalNotifications,
    @Default(false) bool healthDataIntegration,
    @Default(false) bool routeDragging,
    @Default("cycling-regular") String routeProfile,
  }) = _SettingsModel;

  /// Створення SettingsModel з JSON
  /// Параметри: json - Map<String, dynamic> з JSON даними
  factory SettingsModel.fromJson(Map<String, dynamic> json) => _$SettingsModelFromJson(json);
}

/// Extension для конвертації SettingsModel в SettingsEntity
/// 
/// Використовується в: SettingsRepositoryImpl для конвертації з Data в Domain шар
extension SettingsModelExtension on SettingsModel {
  /// Конвертація SettingsModel в SettingsEntity
  /// 
  /// Повертає: SettingsEntity - об'єкт Domain шару
  SettingsEntity toDomain() {
    return SettingsEntity(
      voiceInstructions: voiceInstructions,
      unitsOfMeasurement: unitsOfMeasurement,
      mapStyle: mapStyle,
      notifications: notifications,
      routeAlerts: routeAlerts,
      weatherAlerts: weatherAlerts,
      generalNotifications: generalNotifications,
      healthDataIntegration: healthDataIntegration,
      routeDragging: routeDragging,
      routeProfile: routeProfile,
    );
  }
}

/// Extension для конвертації SettingsEntity в SettingsModel
/// 
/// Використовується в: SettingsRepositoryImpl для конвертації з Domain в Data шар
extension SettingsEntityExtension on SettingsEntity {
  /// Конвертація SettingsEntity в SettingsModel
  /// 
  /// Повертає: SettingsModel - об'єкт Data шару
  SettingsModel toModel() {
    return SettingsModel(
      voiceInstructions: voiceInstructions,
      unitsOfMeasurement: unitsOfMeasurement,
      mapStyle: mapStyle,
      notifications: notifications,
      routeAlerts: routeAlerts,
      weatherAlerts: weatherAlerts,
      generalNotifications: generalNotifications,
      healthDataIntegration: healthDataIntegration,
      routeDragging: routeDragging,
      routeProfile: routeProfile,
    );
  }
}
