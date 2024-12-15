import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  // Navigation Settings
  void toggleVoiceInstructions(bool value) {
    emit(state.copyWith(voiceInstructions: value));
  }

  void changeUnitsOfMeasurement(String value) {
    emit(state.copyWith(unitsOfMeasurement: value));
  }

  void changeMapStyle(String value) {
    emit(state.copyWith(mapStyle: value));
  }

  // App Preferences
  void toggleNotifications(bool value) {
    emit(state.copyWith(notifications: value));
  }

  // Notification Preferences
  void toggleRouteAlerts(bool value) {
    emit(state.copyWith(routeAlerts: value));
  }

  void toggleWeatherAlerts(bool value) {
    emit(state.copyWith(weatherAlerts: value));
  }

  void toggleGeneralNotifications(bool value) {
    emit(state.copyWith(generalNotifications: value));
  }

  // Energy Expenditure Settings
  void toggleHealthDataIntegration(bool value) {
    emit(state.copyWith(healthDataIntegration: value));
  }

  // --- HydratedMixin Methods ---
  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    try {
      return SettingsState(
        voiceInstructions: json['voiceInstructions'] as bool? ?? true,
        unitsOfMeasurement: json['unitsOfMeasurement'] as String? ?? "Metric",
        mapStyle: json['mapStyle'] as String? ?? "Terrain",
        notifications: json['notifications'] as bool? ?? true,
        routeAlerts: json['routeAlerts'] as bool? ?? false,
        weatherAlerts: json['weatherAlerts'] as bool? ?? false,
        generalNotifications: json['generalNotifications'] as bool? ?? false,
        healthDataIntegration: json['healthDataIntegration'] as bool? ?? false,
      );
    } catch (e) {
      return const SettingsState(); // Повертаємо дефолтний стан у разі помилки
    }
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return {
      'voiceInstructions': state.voiceInstructions,
      'unitsOfMeasurement': state.unitsOfMeasurement,
      'mapStyle': state.mapStyle,
      'notifications': state.notifications,
      'routeAlerts': state.routeAlerts,
      'weatherAlerts': state.weatherAlerts,
      'generalNotifications': state.generalNotifications,
      'healthDataIntegration': state.healthDataIntegration,
    };
  }
}



// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'settings_state.dart';

// class SettingsCubit extends Cubit<SettingsState> {
//   SettingsCubit() : super(const SettingsState());

//   // Navigation Settings
//   void toggleVoiceInstructions(bool value) {
//     emit(state.copyWith(voiceInstructions: value));
//   }

//   void changeUnitsOfMeasurement(String value) {
//     emit(state.copyWith(unitsOfMeasurement: value));
//   }

//   void changeMapStyle(String value) {
//     emit(state.copyWith(mapStyle: value));
//   }

//   // App Preferences
//   void toggleNotifications(bool value) {
//     emit(state.copyWith(notifications: value));
//   }

//   // Notification Preferences
//   void toggleRouteAlerts(bool value) {
//     emit(state.copyWith(routeAlerts: value));
//   }

//   void toggleWeatherAlerts(bool value) {
//     emit(state.copyWith(weatherAlerts: value));
//   }

//   void toggleGeneralNotifications(bool value) {
//     emit(state.copyWith(generalNotifications: value));
//   }

//   // Energy Expenditure Settings
//   void toggleHealthDataIntegration(bool value) {
//     emit(state.copyWith(healthDataIntegration: value));
//   }
// }



// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'settings_state.dart';

// class SettingsCubit extends Cubit<SettingsState> {
//   SettingsCubit() : super(const SettingsState());

//   void toggleVoiceInstructions(bool value) {
//     emit(state.copyWith(voiceInstructions: value));
//   }

//   void changeUnitsOfMeasurement(String value) {
//     emit(state.copyWith(unitsOfMeasurement: value));
//   }

//   void changeMapStyle(String value) {
//     emit(state.copyWith(mapStyle: value));
//   }

//   void toggleNotifications(bool value) {
//     emit(state.copyWith(notifications: value));
//   }
// }
