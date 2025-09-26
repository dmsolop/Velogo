import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_entity.freezed.dart';

/// Entity для налаштувань додатку
/// 
/// Функціональність:
/// - Представляє налаштування додатку в Domain шарі
/// - Використовує Freezed для immutable об'єктів
/// - Містить всі налаштування користувача з дефолтними значеннями
/// - Слідує Clean Architecture принципам
/// 
/// Поля:
/// - voiceInstructions: голосові інструкції (за замовчуванням: true)
/// - unitsOfMeasurement: одиниці вимірювання (за замовчуванням: "Metric")
/// - mapStyle: стиль карти (за замовчуванням: "Terrain")
/// - notifications: загальні сповіщення (за замовчуванням: true)
/// - routeAlerts: сповіщення про маршрути (за замовчуванням: false)
/// - weatherAlerts: сповіщення про погоду (за замовчуванням: false)
/// - generalNotifications: загальні сповіщення (за замовчуванням: false)
/// - healthDataIntegration: інтеграція з даними здоров'я (за замовчуванням: false)
/// - routeDragging: перетягування маршрутів (за замовчуванням: false)
/// - routeProfile: профіль маршрутизації (за замовчуванням: "cycling-regular")
/// 
/// Використовується в: SettingsRepository, SettingsCubit, Use Cases
@freezed
class SettingsEntity with _$SettingsEntity {
  const factory SettingsEntity({
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
  }) = _SettingsEntity;
}
