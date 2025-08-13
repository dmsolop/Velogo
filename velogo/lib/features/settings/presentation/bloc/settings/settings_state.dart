import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:velogo/core/error/failures.dart';
import 'package:velogo/features/settings/domain/entities/settings_entity.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.initial() = _Initial;
  const factory SettingsState.loading() = _Loading;
  const factory SettingsState.loaded(SettingsEntity settings) = _Loaded;
  const factory SettingsState.error(Failure failure) = _Error;
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
