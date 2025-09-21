import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velogo/core/services/log_service.dart';
import 'package:velogo/core/services/remote_config_service.dart';
import 'package:velogo/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:velogo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:velogo/features/auth/domain/repositories/auth_repository.dart';
import 'package:velogo/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:velogo/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:velogo/features/auth/presentation/bloc/registration/registration_cubit.dart';
import 'package:velogo/features/weather/data/datasources/weather_service.dart';
import 'package:velogo/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:velogo/features/weather/domain/repositories/weather_repository.dart';
import 'package:velogo/features/weather/domain/usecases/get_weather_data_usecase.dart';
import 'package:velogo/features/weather/domain/usecases/get_weather_forecast_usecase.dart';
import 'package:velogo/features/weather/presentation/bloc/weather/weather_cubit.dart';
import 'package:velogo/features/navigation/domain/repositories/navigation_repository.dart';
import 'package:velogo/features/navigation/domain/repositories/theme_repository.dart';
import 'package:velogo/features/navigation/domain/usecases/get_navigation_state_usecase.dart';
import 'package:velogo/features/navigation/domain/usecases/save_navigation_state_usecase.dart';
import 'package:velogo/features/navigation/domain/usecases/get_theme_usecase.dart';
import 'package:velogo/features/navigation/domain/usecases/save_theme_usecase.dart';
import 'package:velogo/features/navigation/data/repositories/navigation_repository_impl.dart';
import 'package:velogo/features/navigation/data/repositories/theme_repository_impl.dart';
import 'package:velogo/features/navigation/presentation/bloc/navigation/navigation_cubit.dart';
import 'package:velogo/features/navigation/presentation/bloc/theme/theme_cubit.dart';
import 'package:velogo/features/settings/presentation/bloc/settings/settings_cubit.dart';
import 'package:velogo/features/settings/domain/repositories/settings_repository.dart';
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
import 'package:velogo/features/settings/domain/usecases/update_route_dragging_usecase.dart';
import 'package:velogo/features/settings/domain/usecases/update_route_profile_usecase.dart';
import 'package:velogo/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:velogo/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velogo/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:velogo/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:velogo/features/profile/domain/repositories/profile_repository.dart';
import 'package:velogo/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:velogo/features/profile/domain/usecases/save_profile_usecase.dart';
import 'package:velogo/features/profile/domain/usecases/update_name_usecase.dart';
import 'package:velogo/features/profile/domain/usecases/update_gender_usecase.dart';
import 'package:velogo/features/profile/domain/usecases/update_age_usecase.dart';
import 'package:velogo/features/profile/domain/usecases/update_health_data_integration_usecase.dart' as profile;
import 'package:velogo/features/profile/domain/usecases/clear_profile_cache_usecase.dart';
import 'package:velogo/features/profile/presentation/bloc/profile/profile_cubit.dart';
import 'package:velogo/features/map/data/datasources/route_remote_data_source.dart';
import 'package:velogo/features/map/data/datasources/map_remote_data_source.dart';
import 'package:velogo/features/map/data/repositories/route_repository_impl.dart';
import 'package:velogo/features/map/data/repositories/map_repository_impl.dart';
import 'package:velogo/features/map/domain/repositories/route_repository.dart';
import 'package:velogo/features/map/domain/repositories/map_repository.dart';
import 'package:velogo/features/map/domain/usecases/get_all_routes_usecase.dart';
import 'package:velogo/features/map/domain/usecases/create_route_usecase.dart';
import 'package:velogo/features/map/domain/usecases/create_automatic_route_usecase.dart';
import 'package:velogo/features/map/domain/usecases/search_markers_usecase.dart';
import 'package:velogo/features/map/domain/usecases/get_wind_layer_usecase.dart';
import 'package:velogo/features/map/presentation/bloc/route/route_cubit.dart';
import 'package:velogo/features/map/presentation/bloc/route_difficulty/route_difficulty_cubit.dart';
import 'package:velogo/core/services/route_complexity_service.dart';
import 'package:velogo/core/services/health_integration_service.dart';
import 'package:velogo/core/services/personalization_engine.dart';
import 'package:velogo/core/services/local_storage_service.dart';

final sl = GetIt.instance;

/// Ініціалізація Dependency Injection контейнера
Future<void> init() async {
  // Core
  await _initCore();

  // Features
  await _initAuth();
  await _initWeather();
  await _initNavigation();
  await _initSettings();
  await _initMap();
  await _initProfile();
}

/// Ініціалізація core залежностей
Future<void> _initCore() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Services
  sl.registerLazySingleton<LogService>(() => LogService());
  sl.registerLazySingleton<RemoteConfigService>(() => RemoteConfigService());

  // Core services for route complexity
  sl.registerLazySingleton<LocalStorageService>(() => LocalStorageService());
  sl.registerLazySingleton<RouteComplexityService>(() => RouteComplexityService());
  sl.registerLazySingleton<HealthIntegrationService>(() => HealthIntegrationServiceFactory.create());
  sl.registerLazySingleton<PersonalizationEngine>(() => PersonalizationEngine());

  // Ініціалізація сервісів
  await LogService.init(); // Fixed: Direct static call
  await sl<RemoteConfigService>().initialize();
  await sl<LocalStorageService>().init();
}

/// Ініціалізація auth feature
Future<void> _initAuth() async {
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => RegistrationCubit(
        signInUseCase: sl(),
        signUpUseCase: sl(),
      ));
}

/// Ініціалізація weather feature
Future<void> _initWeather() async {
  // Data sources
  sl.registerLazySingleton<WeatherService>(() => WeatherService());

  // Repositories
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetWeatherDataUseCase(sl()));
  sl.registerLazySingleton(() => GetWeatherForecastUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => WeatherCubit(
        getWeatherDataUseCase: sl(),
        getWeatherForecastUseCase: sl(),
      ));
}

/// Ініціалізація navigation feature
Future<void> _initNavigation() async {
  // Repositories
  sl.registerLazySingleton<NavigationRepository>(() => NavigationRepositoryImpl());
  sl.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl());

  // Use cases
  sl.registerLazySingleton(() => GetNavigationStateUseCase(sl()));
  sl.registerLazySingleton(() => SaveNavigationStateUseCase(sl()));
  sl.registerLazySingleton(() => GetThemeUseCase(sl()));
  sl.registerLazySingleton(() => SaveThemeUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => NavigationCubit(
        getNavigationStateUseCase: sl(),
        saveNavigationStateUseCase: sl(),
      ));
  sl.registerFactory(() => ThemeCubit(
        getThemeUseCase: sl(),
        saveThemeUseCase: sl(),
      ));
}

/// Ініціалізація settings feature
Future<void> _initSettings() async {
  // Data sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSettingsUseCase(sl()));
  sl.registerLazySingleton(() => SaveSettingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateVoiceInstructionsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUnitsOfMeasurementUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMapStyleUseCase(sl()));
  sl.registerLazySingleton(() => UpdateNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateRouteAlertsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateWeatherAlertsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateGeneralNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateHealthDataIntegrationUseCase(sl()));
  sl.registerLazySingleton(() => UpdateRouteDraggingUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateRouteProfileUseCase(repository: sl()));

  // BLoCs
  sl.registerFactory(() => SettingsCubit(
        getSettingsUseCase: sl(),
        saveSettingsUseCase: sl(),
        updateVoiceInstructionsUseCase: sl(),
        updateUnitsOfMeasurementUseCase: sl(),
        updateMapStyleUseCase: sl(),
        updateNotificationsUseCase: sl(),
        updateRouteAlertsUseCase: sl(),
        updateWeatherAlertsUseCase: sl(),
        updateGeneralNotificationsUseCase: sl(),
        updateHealthDataIntegrationUseCase: sl(),
        updateRouteDraggingUseCase: sl(),
        updateRouteProfileUseCase: sl(),
      ));
}

/// Ініціалізація profile feature
Future<void> _initProfile() async {
  // Firebase dependencies
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      firestore: sl(),
      auth: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => SaveProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateNameUseCase(sl()));
  sl.registerLazySingleton(() => UpdateGenderUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAgeUseCase(sl()));
  sl.registerLazySingleton(() => profile.UpdateHealthDataIntegrationUseCase(sl()));
  sl.registerLazySingleton(() => ClearProfileCacheUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => ProfileCubit(
        getProfile: sl(),
        saveProfile: sl(),
        updateNameUseCase: sl(),
        updateGenderUseCase: sl(),
        updateAgeUseCase: sl(),
        updateHealthDataIntegrationUseCase: sl(),
        clearProfileCacheUseCase: sl(),
      ));
}

/// Ініціалізація map feature
Future<void> _initMap() async {
  // Data sources
  sl.registerLazySingleton<RouteRemoteDataSource>(
    () => RouteRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<MapRemoteDataSource>(
    () => MapRemoteDataSourceImpl(firestore: sl()),
  );

  // Repositories
  sl.registerLazySingleton<RouteRepository>(
    () => RouteRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllRoutesUseCase(sl()));
  sl.registerLazySingleton(() => CreateRouteUseCase(sl()));
  sl.registerLazySingleton(() => CreateAutomaticRouteUseCase(sl()));
  sl.registerLazySingleton(() => SearchMarkersUseCase(sl()));
  sl.registerLazySingleton(() => GetWindLayerUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => RouteCubit());
  sl.registerFactory(() => RouteDifficultyCubit());
}
