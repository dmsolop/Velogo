import 'package:get_it/get_it.dart';
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
import 'package:velogo/features/navigation/presentation/bloc/navigation/navigation_cubit.dart';
import 'package:velogo/features/navigation/presentation/bloc/theme/theme_cubit.dart';
import 'package:velogo/features/settings/presentation/bloc/settings/settings_cubit.dart';

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
}

/// Ініціалізація core залежностей
Future<void> _initCore() async {
  // Services
  sl.registerLazySingleton<LogService>(() => LogService());
  sl.registerLazySingleton<RemoteConfigService>(() => RemoteConfigService());

  // Ініціалізація сервісів
  await LogService.init(); // Fixed: Direct static call
  await sl<RemoteConfigService>().initialize();
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
  // BLoCs
  sl.registerFactory(() => NavigationCubit());
  sl.registerFactory(() => ThemeCubit());
}

/// Ініціалізація settings feature
Future<void> _initSettings() async {
  // BLoCs
  sl.registerFactory(() => SettingsCubit());
}
