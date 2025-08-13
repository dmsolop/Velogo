import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velogo/core/usecases/usecase.dart';
import 'package:velogo/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:velogo/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:velogo/features/settings/domain/usecases/update_voice_instructions_usecase.dart';
import 'package:velogo/features/settings/domain/usecases/update_units_of_measurement_usecase.dart';
import 'package:velogo/features/settings/domain/usecases/update_map_style_usecase.dart';
import 'package:velogo/features/settings/domain/usecases/update_notifications_usecase.dart';
import 'package:velogo/features/settings/domain/usecases/update_route_alerts_usecase.dart';
import 'package:velogo/features/settings/domain/usecases/update_weather_alerts_usecase.dart';
import 'package:velogo/features/settings/domain/usecases/update_general_notifications_usecase.dart';
import 'package:velogo/features/settings/domain/usecases/update_health_data_integration_usecase.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final SaveSettingsUseCase saveSettingsUseCase;
  final UpdateVoiceInstructionsUseCase updateVoiceInstructionsUseCase;
  final UpdateUnitsOfMeasurementUseCase updateUnitsOfMeasurementUseCase;
  final UpdateMapStyleUseCase updateMapStyleUseCase;
  final UpdateNotificationsUseCase updateNotificationsUseCase;
  final UpdateRouteAlertsUseCase updateRouteAlertsUseCase;
  final UpdateWeatherAlertsUseCase updateWeatherAlertsUseCase;
  final UpdateGeneralNotificationsUseCase updateGeneralNotificationsUseCase;
  final UpdateHealthDataIntegrationUseCase updateHealthDataIntegrationUseCase;

  SettingsCubit({
    required this.getSettingsUseCase,
    required this.saveSettingsUseCase,
    required this.updateVoiceInstructionsUseCase,
    required this.updateUnitsOfMeasurementUseCase,
    required this.updateMapStyleUseCase,
    required this.updateNotificationsUseCase,
    required this.updateRouteAlertsUseCase,
    required this.updateWeatherAlertsUseCase,
    required this.updateGeneralNotificationsUseCase,
    required this.updateHealthDataIntegrationUseCase,
  }) : super(const SettingsState.initial());

  Future<void> loadSettings() async {
    emit(const SettingsState.loading());
    final result = await getSettingsUseCase(NoParams());
    result.fold(
      (failure) => emit(SettingsState.error(failure)),
      (settings) => emit(SettingsState.loaded(settings)),
    );
  }

  Future<void> toggleVoiceInstructions(bool value) async {
    state.when(
      initial: () {},
      loading: () {},
      loaded: (settings) async {
        final result = await updateVoiceInstructionsUseCase(value);
        result.fold(
          (failure) => emit(SettingsState.error(failure)),
          (_) => emit(SettingsState.loaded(settings.copyWith(voiceInstructions: value))),
        );
      },
      error: (failure) {},
    );
  }

  Future<void> changeUnitsOfMeasurement(String value) async {
    state.when(
      initial: () {},
      loading: () {},
      loaded: (settings) async {
        final result = await updateUnitsOfMeasurementUseCase(value);
        result.fold(
          (failure) => emit(SettingsState.error(failure)),
          (_) => emit(SettingsState.loaded(settings.copyWith(unitsOfMeasurement: value))),
        );
      },
      error: (failure) {},
    );
  }

  Future<void> changeMapStyle(String value) async {
    state.when(
      initial: () {},
      loading: () {},
      loaded: (settings) async {
        final result = await updateMapStyleUseCase(value);
        result.fold(
          (failure) => emit(SettingsState.error(failure)),
          (_) => emit(SettingsState.loaded(settings.copyWith(mapStyle: value))),
        );
      },
      error: (failure) {},
    );
  }

  Future<void> toggleNotifications(bool value) async {
    state.when(
      initial: () {},
      loading: () {},
      loaded: (settings) async {
        final result = await updateNotificationsUseCase(value);
        result.fold(
          (failure) => emit(SettingsState.error(failure)),
          (_) => emit(SettingsState.loaded(settings.copyWith(notifications: value))),
        );
      },
      error: (failure) {},
    );
  }

  Future<void> toggleRouteAlerts(bool value) async {
    state.when(
      initial: () {},
      loading: () {},
      loaded: (settings) async {
        final result = await updateRouteAlertsUseCase(value);
        result.fold(
          (failure) => emit(SettingsState.error(failure)),
          (_) => emit(SettingsState.loaded(settings.copyWith(routeAlerts: value))),
        );
      },
      error: (failure) {},
    );
  }

  Future<void> toggleWeatherAlerts(bool value) async {
    state.when(
      initial: () {},
      loading: () {},
      loaded: (settings) async {
        final result = await updateWeatherAlertsUseCase(value);
        result.fold(
          (failure) => emit(SettingsState.error(failure)),
          (_) => emit(SettingsState.loaded(settings.copyWith(weatherAlerts: value))),
        );
      },
      error: (failure) {},
    );
  }

  Future<void> toggleGeneralNotifications(bool value) async {
    state.when(
      initial: () {},
      loading: () {},
      loaded: (settings) async {
        final result = await updateGeneralNotificationsUseCase(value);
        result.fold(
          (failure) => emit(SettingsState.error(failure)),
          (_) => emit(SettingsState.loaded(settings.copyWith(generalNotifications: value))),
        );
      },
      error: (failure) {},
    );
  }

  Future<void> toggleHealthDataIntegration(bool value) async {
    state.when(
      initial: () {},
      loading: () {},
      loaded: (settings) async {
        final result = await updateHealthDataIntegrationUseCase(value);
        result.fold(
          (failure) => emit(SettingsState.error(failure)),
          (_) => emit(SettingsState.loaded(settings.copyWith(healthDataIntegration: value))),
        );
      },
      error: (failure) {},
    );
  }
}
