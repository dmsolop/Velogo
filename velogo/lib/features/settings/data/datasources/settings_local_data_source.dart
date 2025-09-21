import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velogo/core/error/exceptions.dart';
import 'package:velogo/features/settings/data/models/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();
  Future<void> saveSettings(SettingsModel settings);
  Future<void> updateVoiceInstructions(bool value);
  Future<void> updateUnitsOfMeasurement(String value);
  Future<void> updateMapStyle(String value);
  Future<void> updateNotifications(bool value);
  Future<void> updateRouteAlerts(bool value);
  Future<void> updateWeatherAlerts(bool value);
  Future<void> updateGeneralNotifications(bool value);
  Future<void> updateHealthDataIntegration(bool value);
  Future<void> updateRouteDragging(bool value);
  Future<void> updateRouteProfile(String value);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String settingsKey = 'settings';

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final jsonString = sharedPreferences.getString(settingsKey);
      if (jsonString != null) {
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        return SettingsModel.fromJson(jsonMap);
      } else {
        return const SettingsModel(); // Return default settings
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      final jsonString = json.encode(settings.toJson());
      await sharedPreferences.setString(settingsKey, jsonString);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateVoiceInstructions(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(voiceInstructions: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateUnitsOfMeasurement(String value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(unitsOfMeasurement: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateMapStyle(String value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(mapStyle: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateNotifications(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(notifications: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateRouteAlerts(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(routeAlerts: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateWeatherAlerts(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(weatherAlerts: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateGeneralNotifications(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(generalNotifications: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateHealthDataIntegration(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(healthDataIntegration: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateRouteDragging(bool value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(routeDragging: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateRouteProfile(String value) async {
    try {
      final settings = await getSettings();
      final updatedSettings = settings.copyWith(routeProfile: value);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw CacheException();
    }
  }
}
