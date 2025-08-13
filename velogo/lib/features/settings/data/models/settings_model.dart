import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:velogo/features/settings/domain/entities/settings_entity.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

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
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) => _$SettingsModelFromJson(json);
}

extension SettingsModelExtension on SettingsModel {
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
    );
  }
}

extension SettingsEntityExtension on SettingsEntity {
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
    );
  }
}
