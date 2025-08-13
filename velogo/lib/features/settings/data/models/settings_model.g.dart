// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsModelImpl _$$SettingsModelImplFromJson(Map<String, dynamic> json) =>
    _$SettingsModelImpl(
      voiceInstructions: json['voiceInstructions'] as bool? ?? true,
      unitsOfMeasurement: json['unitsOfMeasurement'] as String? ?? "Metric",
      mapStyle: json['mapStyle'] as String? ?? "Terrain",
      notifications: json['notifications'] as bool? ?? true,
      routeAlerts: json['routeAlerts'] as bool? ?? false,
      weatherAlerts: json['weatherAlerts'] as bool? ?? false,
      generalNotifications: json['generalNotifications'] as bool? ?? false,
      healthDataIntegration: json['healthDataIntegration'] as bool? ?? false,
    );

Map<String, dynamic> _$$SettingsModelImplToJson(_$SettingsModelImpl instance) =>
    <String, dynamic>{
      'voiceInstructions': instance.voiceInstructions,
      'unitsOfMeasurement': instance.unitsOfMeasurement,
      'mapStyle': instance.mapStyle,
      'notifications': instance.notifications,
      'routeAlerts': instance.routeAlerts,
      'weatherAlerts': instance.weatherAlerts,
      'generalNotifications': instance.generalNotifications,
      'healthDataIntegration': instance.healthDataIntegration,
    };
