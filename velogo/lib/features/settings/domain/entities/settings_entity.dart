import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_entity.freezed.dart';

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
