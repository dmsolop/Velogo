class SettingsState {
  final bool voiceInstructions;
  final String unitsOfMeasurement;
  final String mapStyle;
  final bool notifications;

  // Додаткові параметри
  final bool routeAlerts;
  final bool weatherAlerts;
  final bool generalNotifications;
  final bool healthDataIntegration;

  const SettingsState({
    this.voiceInstructions = true,
    this.unitsOfMeasurement = "Metric",
    this.mapStyle = "Terrain",
    this.notifications = true,
    this.routeAlerts = false,
    this.weatherAlerts = false,
    this.generalNotifications = false,
    this.healthDataIntegration = false,
  });

  SettingsState copyWith({
    bool? voiceInstructions,
    String? unitsOfMeasurement,
    String? mapStyle,
    bool? notifications,
    bool? routeAlerts,
    bool? weatherAlerts,
    bool? generalNotifications,
    bool? healthDataIntegration,
  }) {
    return SettingsState(
      voiceInstructions: voiceInstructions ?? this.voiceInstructions,
      unitsOfMeasurement: unitsOfMeasurement ?? this.unitsOfMeasurement,
      mapStyle: mapStyle ?? this.mapStyle,
      notifications: notifications ?? this.notifications,
      routeAlerts: routeAlerts ?? this.routeAlerts,
      weatherAlerts: weatherAlerts ?? this.weatherAlerts,
      generalNotifications: generalNotifications ?? this.generalNotifications,
      healthDataIntegration:
          healthDataIntegration ?? this.healthDataIntegration,
    );
  }
}



// class SettingsState {
//   final bool voiceInstructions;
//   final String unitsOfMeasurement;
//   final String mapStyle;
//   final bool notifications;

//   const SettingsState({
//     this.voiceInstructions = true,
//     this.unitsOfMeasurement = "Metric",
//     this.mapStyle = "Terrain",
//     this.notifications = true,
//   });

//   SettingsState copyWith({
//     bool? voiceInstructions,
//     String? unitsOfMeasurement,
//     String? mapStyle,
//     bool? notifications,
//   }) {
//     return SettingsState(
//       voiceInstructions: voiceInstructions ?? this.voiceInstructions,
//       unitsOfMeasurement: unitsOfMeasurement ?? this.unitsOfMeasurement,
//       mapStyle: mapStyle ?? this.mapStyle,
//       notifications: notifications ?? this.notifications,
//     );
//   }
// }
